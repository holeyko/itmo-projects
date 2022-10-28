<#-- @ftlvariable name="uri" type="java.lang.String" -->

<#import "./post.ftlh" as p>

<#macro page>
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <title>Codeforces</title>
        <link rel="stylesheet" href="/css/normalize.css">
        <link rel="stylesheet" href="/css/style.css">
        <link rel="icon" href="/favicon.ico">
    </head>
    <body>
    <@header/>
    <div class="middle">
        <@sidebar/>
        <main>
            <#nested/>
        </main>
    </div>
    <@footer/>
    </body>
    </html>
</#macro>

<#macro header>
    <header>
        <a href="#" class="logo"><img alt="Codeforces" title="Codeforces"
                                      src="/img/codeforces-logo-with-telegram.png"></a>
        <div class="languages">
            <a href="#"><img alt="In English" title="In English"
                             src="/img/gb.png"></a>
            <a href="#"><img alt="In Russian" title="In Russian"
                             src="/img/ru.png"></a>
        </div>
        <div class="enter-or-register-box">
            <#if user??>
                <@userLinkWrapper user, user.name, false/>
                |
                <a href="/logout">Logout</a>
            <#else>
                <a href="/enter">Enter</a>
                |
                <a href="/register">Register</a>
            </#if>
        </div>
        <nav>
            <#assign items=[
            {"href": "/index", "name": "Home"},
            {"href": "/users", "name": "Users"},
            {"href": "/misc/help", "name": "Help"},
            {"href": "/contests", "name": "Contests"}
            ]/>
            <ul>
                <#list items as item>
                    <li>
                        <#if item.href == uri>
                            <a class="current_place" href="${item.href}">${item.name}</a>
                        <#else>
                            <a href="${item.href}">${item.name}</a>
                        </#if>
                    </li>
                </#list>
            </ul>
        </nav>
    </header>
</#macro>

<#macro sidebar>
    <aside>
        <#list posts?reverse as post>
            <section>
                <div class="header">Post #${post.id}</div>
                <div class="body"><@p.main post false/></div>
                <div class="footer">
                    <@postLinkWrapper post, "View all"/>
                </div>
            </section>
        </#list>
    </aside>
</#macro>

<#macro footer>
    <footer>
        2010-2021 &copy; by Mike Mirzayanov
    </footer>
</#macro>

<#function findBy items key value>
    <#list items as item>
        <#if item[key]?? && item[key] == value>
            <#return item/>
        </#if>
    </#list>
</#function>

<#function filterBy items key value>
    <#assign filtred = []>
    <#list items as item>
        <#if item[key] == value>
            <#assign filtred = filtred + [item]/>
        </#if>
    </#list>
    <#return filtred/>
</#function>

<#macro linkWrapper ref inner class="">
<#-- @ftlvariable name="ref" type="java.lang.String" -->
<#-- @ftlvariable name="class" type="java.lang.String" -->
    <#if ref?? && ref?hasContent>
        <a class="${class}" href="${ref}">${inner}</a>
    <#else>
        ${inner}
    </#if>
</#macro>

<#macro userLinkWrapper user inner withColor=true>
<#-- @ftlvariable name="user" type="ru.itmo.web.hw4.model.User" -->
<#-- @ftlvariable name="withColor" type="java.lang.Boolean" -->
    <#if user?? && user?hasContent>
        <#if nameOnly?? || withColor == false>
            <@linkWrapper "/user?nameOnly&handle=${user.handle}", inner, "user_link"/>
        <#else>
            <@linkWrapper "/user?handle=${user.handle}", inner, "user_link " + user.color.colorName/>
        </#if>
    <#else>
        ${inner}
    </#if>
</#macro>

<#macro postLinkWrapper post inner>
<#-- @ftlvariable name="post" type="ru.itmo.web.hw4.model.Post" -->
    <#if post?? && post?hasContent>
        <@linkWrapper "/post?post_id=${post.id}", inner/>
    <#else>
        ${inner}
    </#if>
</#macro>
