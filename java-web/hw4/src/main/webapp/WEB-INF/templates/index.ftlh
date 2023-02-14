<#import "./common.ftlh" as c>
<#import "./post.ftlh" as p>

<@c.page>
    <#list posts?reverse as post>
        <@p.postView post, false/>
    </#list>
</@c.page>
