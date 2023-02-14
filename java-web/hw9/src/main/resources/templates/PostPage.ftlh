<#import "spring.ftl" as spring>
<#import "commons.ftlh" as c>

<@c.page>
    <@c.post post/>

    <#if user??>
    <div class="write-comment form">
        <div class="header">Write Comment</div>
        <div class="body">
            <form method="post" action="">
                <div class="field">
                    <div class="name">
                        <label for="text">Text</label>
                    </div>
                    <div class="value">
                        <@spring.bind "newComment.text"/>
                        <textarea id="text" name="text">${newComment.text!}</textarea>
                    </div>
                    <@c.error "newComment.text"/>
                </div>
                <div class="button-field">
                    <input type="submit" value="Write">
                </div>
            </form>
        </div>
    </div>
    </#if>

    <#list post.comments as comment>
        <@c.comment comment/>
    </#list>
</@c.page>
