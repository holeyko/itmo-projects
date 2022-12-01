<#import "commons.ftlh" as c/>

<@c.page>
    <div class="article form-box">
        <div class="header">Article</div>
        <div class="body">
            <form method="post" action="">
                <input type="hidden" name="action" value="write"/>
                <div class="field">
                    <div class="name">
                        <label for="title">Title</label>
                    </div>
                    <div class="value">
                        <input id="title" name="title"/>
                    </div>
                </div>
                <div class="field">
                    <div class="name">
                        <label for="text">Text</label>
                    </div>
                    <div class="value">
                        <textarea id="text" name="text" style="resize: none;" placeholder="Write something.."></textarea>
                    </div>
                </div>
                <div class="error"></div>
                <div class="button-field">
                    <input type="submit" value="Write">
                </div>
            </form>
        </div>
    </div>

    <script>
        $(function () {
            $(".article form").submit(function () {
                const userId = ${user.id};
                const $title = $(this).find("input[name='title']");
                const title = $title.val();
                const $text = $(this).find("textarea[name='text']");
                const text = $text.val();
                const $error = $(this).find(".error").empty();

                ajax({
                    data: {
                        action: "write",
                        userId: userId,
                        title: title,
                        text: text,
                    },
                    successFunc: function (response) {
                        if (response["error"]) {
                            $error.text(response["error"]);
                        } else {
                            $title.val("");
                            $text.val("");
                        }
                    },
                });

                return false;
            });
        })
    </script>
</@c.page>