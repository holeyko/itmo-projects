<#-- @ftlvariable name="user_id" type="java.lang.Long" -->
<#-- @ftlvariable name="handle" type="java.lang.String" -->
<#import "./common.ftlh" as c>

<@c.page>
    <#assign user></#assign>
    <#if handle??>
        <#assign user = c.findBy(users, "handle", handle)!/>
    <#elseIf user_id??>
        <#assign user = c.findBy(users, "id", user_id)!/>
    </#if>

    <#if user?hasContent>
        <div class="user_box">
            <div class="user_info">
                <h2><@c.userLinkWrapper user, user.name/></h2>
                <ul>
                    <li>Id: ${user.id}</li>
                    <li>Handle: ${user.handle}</li>
                    <li>Name: ${user.name}</li>
                    <li>Count posts: <@c.linkWrapper
                        "/post?user_id=${user.id}",
                        (c.filterBy(posts, "userId", user.id)?size)
                        /></li>
                </ul>
            </div>
            <img class="user_pic" src="/img/user-pic.jpg" alt="User picture">
        </div>
        <#assign key></#assign>
        <#assign val></#assign>

        <#if handle??>
            <#assign key = "handle" val = handle/>
        <#elseIf user_id??>
            <#assign key = "id" val = user_id/>
        </#if>
        <@sliders key val/>
    <#else>
        No such user
    </#if>
</@c.page>

<#macro sliders key value>
    <div class="user_slider">
        <#local leftarrow>&larr;</#local>
        <@slider key, value, leftarrow, -1/>

        <#local rightarrow>&rarr;</#local>
        <@slider key, value, rightarrow, 1/>
    </div>
</#macro>

<#macro slider key value inner step>
    <div class="arrow">
        <#assign shiftedUser = shiftUser(users, c.findBy(users, key, value), step)!>
        <@c.userLinkWrapper shiftedUser, inner/>
    </div>
</#macro>

<#function shiftUser users curu step>
<#-- @ftlvariable name="users" type="ru.itmo.web.hw4.model.User[]" -->
<#-- @ftlvariable name="curu" type="ru.itmo.web.hw4.model.User" -->
    <#list users as u>
        <#if u == curu>
            <#return users[u_index + step]>
        </#if>
    </#list>
</#function>
