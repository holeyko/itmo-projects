<#-- @ftlvariable name="viewUser" type="ru.itmo.wp.domain.User" -->
<#import "commons.ftlh" as c>

<@c.page>
    <#if viewUser?hasContent>
        <div class="user-info">
            <div class="header">User information</div>
            <div class="body">
                <div class="info">
                    <div class="user-id">ID: ${viewUser.id}</div>
                    <div class="user-login">Login: ${viewUser.login}</div>
                    <div class="user-creationTime">Creation Time: ${viewUser.creationTime}</div>
                </div>
            </div>
        </div>
    <#else>
        No Such User
    </#if>
</@c.page>