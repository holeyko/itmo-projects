<#-- @ftlvariable name="userArticles" type="ru.itmo.wp.model.domain.Article[]" -->
<#import "commons.ftlh" as c>

<@c.page>
    <div class="user-articles datatable">
        <div class="caption">Your Articles</div>
        <table>
            <thead>
            <tr>
                <th>Id</th>
                <th>Title</th>
                <th>Hide/Show</th>
            </tr>
            </thead>
            <tbody>
            <#list userArticles as userArt>
                <tr>
                    <td class="userArt-id">${userArt.id}</td>
                    <td class="userArt-title">${userArt.title}</td>
                    <td class="userArt-toggleHidden">
                        <form method="post" action="">
                            <input type="hidden" name="action" value="toggleHidden">
                            <div class="button-field">
                                <#if userArt.hidden>
                                    <input type="submit" value="Show">
                                <#else>
                                    <input type="submit" value="Hide">
                                </#if>
                            </div>
                        </form>
                    </td>
                </tr>
            </#list>
            </tbody>
        </table>
    </div>

    <script>
        $(function () {
            $(".user-articles tbody tr").each(function () {
                const $tr = $(this);
                const $form = $tr.find("form");
                const $toggleInput = $form.find("input");
                const articleId = $tr.find(".userArt-id").text();
                const userId = ${user.id};

                $form.submit(function () {
                    ajax({
                        data: {
                            action: "toggleHidden",
                            articleId: articleId,
                            userId: userId,
                            hide: $toggleInput.val() === "Hide",
                        },
                        successFunc: function (response) {
                            if ($toggleInput.val() === "Hide") {
                                $toggleInput.val("Show");
                            } else {
                                $toggleInput.val("Hide");
                            }
                        }
                    });

                    return false;
                })
            })
        })
    </script>
</@c.page>