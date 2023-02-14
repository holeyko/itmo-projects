<#-- @ftlvariable name="targetUser" type="ru.itmo.wp.model.domain.User" -->
<#import "commons.ftlh" as c>

<@c.page>
    <@sendMessage/>
    <@messageHistory/>
</@c.page>

<#macro sendMessage>
    <div class="form-box talk">
        <div class="header">Talk</div>
        <div class="body">
            <form method="post" action="">
                <input type="hidden" name="action" value="sendMessage"/>
                <div class="field">
                    <div class="name">
                        <label for="target-login">Choose target user</label>
                    </div>
                    <div class="value">
                        <select id="target-login" name="targetLogin">
                            <#list users as u>
                                <#if user?? && user.id != u.id>
                                    <#if targetUser?? && targetUser.id == u.id>
                                        <option selected="selected">${u.login}</option>
                                    <#else>
                                        <option>${u.login}</option>
                                    </#if>
                                </#if>
                            </#list>
                        </select>
                    </div>
                </div>
                <div class="field">
                    <div class="name">
                        <label for="text">Text</label>
                    </div>
                    <div class="value">
                        <textarea id="text" name="text" style="resize: none;"
                                  placeholder="Write something.."></textarea>
                    </div>
                </div>
                <#if error??>
                    <div class="error">
                        ${error!}
                    </div>
                </#if>
                <div class="button-field">
                    <input type="submit" value="Send Message">
                </div>
            </form>
        </div>
    </div>
</#macro>

<#macro messageHistory>
    <#if talks?hasContent>
        <div class="datatable talk-history">
            <div class="caption">History</div>
            <table>
                <thead>
                <tr>
                    <th>From</th>
                    <th>To</th>
                    <th>Text</th>
                    <th>Sending Time</th>
                </tr>
                </thead>
                <tbody>
                <#list talks as talk>
                    <tr>
                        <td>${c.findBy(users, "id", talk.sourceUserId).login}</td>
                        <td>${c.findBy(users, "id", talk.targetUserId).login}</td>
                        <td>${talk.text}</td>
                        <td>${talk.creationTime}</td>
                    </tr>
                </#list>
                </tbody>
            </table>
        </div>
    </#if>
</#macro>