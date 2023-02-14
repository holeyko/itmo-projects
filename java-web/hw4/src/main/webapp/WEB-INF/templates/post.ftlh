<#-- @ftlvariable name="post_id" type="java.lang.Long" -->

<#import "./common.ftlh" as c>
<#import "./nopage.ftlh" as np>

<@c.page>
    <#if user_id??>
        <#assign u = c.findBy(users, "id", user_id)!/>
        <@userPosts u/>
    <#elseIf post_id??>
        <#assign post = c.findBy(posts, "id", post_id)!/>
        <@postView post true/>
    <#else>
        No such post
    </#if>
</@c.page>

<#macro userPosts user>
    <#-- @ftlvariable name="user" type="ru.itmo.web.hw4.model.User" -->
    <#if user?? && user?hasContent>
        <#list c.filterBy(posts, "userId", user.id) as post>
            <@postView post true/>
        </#list>
    <#else>
        No such user
    </#if>
</#macro>

<#macro postView post isFull>
    <#-- @ftlvariable name="post" type="ru.itmo.web.hw4.model.Post" -->
    <#-- @ftlvariable name="isFull" type="java.lang.Boolean" -->

    <#if post?hasContent>
        <article>
            <@header post/>
            <@main post isFull/>
            <@attachment/>
            <@footer/>
        </article>
    <#else>
        No such post
    </#if>
</#macro>

<#macro header post>
    <div class="title"><@c.postLinkWrapper post, post.title/></div>
    <#assign u = c.findBy(users, "id", post.userId)/>
    <div class="information">Author: <@c.userLinkWrapper u, u.name/></div>
</#macro>

<#macro main post isFull>
    <div class="body">
        <#assign text></#assign>
        <#if isFull || (post.text?length <= 350)>
            <#assign text = post.text>
        <#else>
            <#assign text = post.text?substring(0, 350) + "...">
        </#if>

        <p>${text}</p>
    </div>
</#macro>

<#macro attachment>
    <ul class="attachment">
        <li>Announcement of <a href="#">Codeforces Round #510 (Div. 1)</a></li>
        <li>Announcement of <a href="#">Codeforces Round #510 (Div. 2)</a></li>
    </ul>
</#macro>

<#macro footer>
    <div class="footer">
        <div class="left">
            <img src="img/voteup.png" title="Vote Up" alt="Vote Up"/>
            <span class="positive-score">+173</span>
            <img src="img/votedown.png" title="Vote Down" alt="Vote Down"/>
        </div>
        <div class="right">
            <img src="img/date_16x16.png" title="Publish Time" alt="Publish Time"/>
            2 days ago
            <img src="img/comments_16x16.png" title="Comments" alt="Comments"/>
            <a href="#">68</a>
        </div>
    </div>
</#macro>
