<#import "commons.ftlh" as c>

<@c.page>
    <div class="users datatable">
        <div class="caption">User</div>
        <table>
            <thead>
            <tr>
                <th>Id</th>
                <th>Login</th>
                <th>Created</th>
                <th>Toggle Disabled Status</th>
            </tr>
            </thead>
            <tbody>
            <#if users?size==0>
                <tr class="noData">
                    <td colspan="4">
                        No data
                    </td>
                </tr>
            <#else>
                <#list users as u>
                <tr>
                    <td class="id">${u.id}</td>
                    <td class="login">${u.login}</td>
                    <td class="creationTime">${u.creationTime}</td>
                    <td class="toggleDisable">
                        <form method="post" action="">
                            <div class="button-field">
                                <input type="hidden" name="userId" value="${u.id}">
                                <#if u.disabled>
                                    <input id="toggle" type="submit" name="toggleDisabled" value="Enable">
                                <#else>
                                    <input id="toggle" type="submit" name="toggleDisabled" value="Disable">
                                </#if>
                            </div>
                        </form>
                    </td>
                </tr>
                </#list>
            </#if>
            </tbody>
        </table>
    </div>
</@c.page>
