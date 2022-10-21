<#-- @ftlvariable name="user_id" type="java.lang.Long" -->
<#-- @ftlvariable name="handle" type="java.lang.String" -->
<#import "./common.ftlh" as c>

<@c.page>
    <#assign u></#assign>
    <#if handle??>
        <#assign u = c.findBy(users, "handle", handle)!/>
    <#elseIf user_id??>
        <#assign u = c.findBy(users, "id", user_id)!/>
    </#if>

    <#if u?hasContent>
        <div class="user_box">
            <div class="user_info">
                <h2>${c.userLinkWrapper(u, u.name)}</h2>
                <ul>
                    <li>Id: ${u.id}</li>
                    <li>Handle: ${u.handle}</li>
                    <li>Name: ${u.name}</li>
                    <li>Count posts: ${c.linkWrapper(
                        "/post?user_id=${u.id}",
                        (c.filterBy(posts, "userId", u.id)?size)
                        )}</li>
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
        <@slider key val/>
    <#else>
        No such user
    </#if>
</@c.page>

<#macro slider key value>
    <div class="user_slider">
        <div class="arrow">
            <#assign prevu = shiftUser(users, c.findBy(users, key, value), -1)!>
            <#local leftarrow>&larr;</#local>
            ${c.userLinkWrapper(prevu, leftarrow)}
        </div>
        <div class="arrow">
            <#assign nextu = shiftUser(users, c.findBy(users, key, value), 1)!>
            <#local rightarrow>&rarr;</#local>
            ${c.userLinkWrapper(nextu, rightarrow)}
        </div>
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
