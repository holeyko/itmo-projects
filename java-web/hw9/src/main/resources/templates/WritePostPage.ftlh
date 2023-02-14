<#-- @ftlvariable name="post" type="ru.itmo.wp.domain.Post" -->

<#import "/spring.ftl" as spring>
<#import "commons.ftlh" as c>

<@c.page>
    <div class="form post">
        <div class="header">Write Post</div>
        <div class="body">
            <form method="post" action="">
                <div class="field">
                    <div class="name">
                        <label for="title">Title</label>
                    </div>
                    <div class="value">
                        <input autofocus id="title" name="title" value="${postForm.title!}"/>
                    </div>
                    <@c.error "postForm.title"/>
                </div>
                <div class="field">
                    <div class="name">
                        <label for="text">Text</label>
                    </div>
                    <div class="value">
                        <textarea id="text" name="text">${postForm.text!}</textarea>
                    </div>
                    <@c.error "postForm.text"/>
                </div>
                <div class="field">
                    <div class="name">
                        <label for="tags">Tags</label>
                    </div>
                    <div class="value">
                        <textarea id="tags" name="tags">${postForm.tags!}</textarea>
                    </div>
                    <@c.error "postForm.tags"/>
                </div>
                <div class="button-field">
                    <input type="submit" value="Write">
                </div>
            </form>
        </div>
    </div>
</@c.page>
