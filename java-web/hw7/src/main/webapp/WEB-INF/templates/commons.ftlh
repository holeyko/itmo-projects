<#-- @ftlvariable name="user" type="ru.itmo.wp.model.domain.User" -->
<#-- @ftlvariable name="message" type="java.lang.String" -->
<#-- @ftlvariable name="userCount" type="java.lang.Integer" -->

<#macro page>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Codeforces</title>
        <link rel="stylesheet" type="text/css" href="/css/normalize.css">
        <link rel="stylesheet" type="text/css" href="/css/style.css">
        <link rel="stylesheet" type="text/css" href="/css/form.css">
        <link rel="stylesheet" type="text/css" href="/css/datatable.css">
        <link rel="stylesheet" type="text/css" href="/css/talk.css">
        <link rel="stylesheet" type="text/css" href="/css/article.css">
        <script src="/js/jquery-3.6.1.min.js"></script>
        <script src="/js/notify.min.js"></script>
        <script src="/js/app.js"></script>
    </head>
    <body>
    <@header/>
    <@middle>
        <#nested/>
    </@middle>
    <@footer/>
    <script>
        $(function () {
            {
                <#if message??>
                notify("${message?js_string}");
                </#if>
            }

            {
                const $headerNavList = $("header nav ul");
                const $template = $("header template");
                const pages = [
                    {name: "Home", href: "/index", forAuthorized: false},
                    {name: "Users", href: "/users", forAuthorized: false},
                    {name: "Talks", href: "/talks", forAuthorized: true},
                    {name: "Article", href: "/article", forAuthorized: true},
                    {name: "My Articles", href: "/myArticles", forAuthorized: true},
                ];

                for (let i in pages) {
                    const page = pages[i];
                    let flag = true;

                    if (page.forAuthorized) {
                        <#if !user??>
                        flag = false;
                        </#if>
                    }

                    if (flag) {
                        const $li = $($template.prop("content")).clone();
                        $li.find("a").attr("href", page.href).text(page.name);

                        $headerNavList.append($li);
                    }
                }
            }
        })
    </script>
    </body>
    </html>
</#macro>

<#macro header>
    <header>
        <a href="/index"><img src="/img/logo.png" alt="Codeforces" title="Codeforces"/></a>
        <div class="languages">
            <a href="#"><img src="/img/gb.png" alt="In English" title="In English"/></a>
            <a href="#"><img src="/img/ru.png" alt="In Russian" title="In Russian"/></a>
        </div>
        <div class="enter-or-register-box">
            <#if user??>
                ${user.login}
                |
                <a href="/logout">Logout</a>
            <#else>
                <a href="/enter">Enter</a>
                |
                <a href="/register">Register</a>
            </#if>
        </div>
        <nav><ul></ul></nav>
        <template>
            <li><a></a></li>
        </template>
    </header>
</#macro>

<#macro middle>
    <div class="middle">
        <aside>
            <section>
                <div class="header">
                    Pay attention
                </div>
                <div class="body">
                    Lorem ipsum dolor sit amet, consectetur adipisicing elit. Cupiditate ducimus enim facere impedit
                    nobis,
                    nulla placeat quam suscipit unde voluptatibus.
                </div>
                <div class="footer">
                    <a href="#">View all</a>
                </div>
            </section>
        </aside>
        <main>
            <#nested/>
        </main>
    </div>
</#macro>

<#macro footer>
    <footer>
        <a href="/index">Codeforces</a> &copy; 2022 by Mike Mirzayanov
        <div class="user-count">Users count: ${userCount}</div>
    </footer>
</#macro>

<#function findBy items key value>
    <#list items as item>
        <#if item[key] == value>
           <#return item>
        </#if>
    </#list>
</#function>