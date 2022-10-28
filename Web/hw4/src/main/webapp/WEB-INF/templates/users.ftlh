<#import "./common.ftlh" as c>

<@c.page>
    <div class="datatable">
        <div class="caption">Users</div>
        <table>
            <#assign thData=[
            {"title": "id", "valueName": "id"},
            {"title": "handle", "valueName": "handle"},
            {"title": "name", "valueName": "name"}
            ]/>
            <thead>
            <tr>
                <#list thData as thCell>
                    <th>${thCell.title}</th>
                </#list>
            </tr>
            </thead>

            <tbody>
            <#list users as u>
                <tr>
                <#list thData as thCell>
                    <#if thCell.valueName == "handle">
                        <td><@c.userLinkWrapper u, u.handle/></td>
                    <#else>
                        <td>${u[thCell.valueName]}</td>
                    </#if>
                </#list>
                </tr>
            </#list>
            </tbody>
        </table>
    </div>
</@c.page>
