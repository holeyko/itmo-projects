<#import "commons.ftlh" as c>

<@c.page>
    <div class="articles">
        <div class="noData">No data</div>
        <template>
            <article>
                <div class="title"></div>
                <div class="information"></div>
                <div class="body"></div>
            </article>
        </template>
    </div>
    <script>
        const $articles = $(".articles");
        const $noData = $articles.find(".noData");
        $noData.text("Loading...");
        const $articleTemplateInner = $($articles.find("template").prop("content"));

        ajax({
            data: {
                action: "findAllArticles",
            },
            successFunc: function (response) {
                $noData.hide();

                response["articles"].forEach(function (article) {
                    const $article = $articleTemplateInner.clone();
                    const user = response["writers"][article["userId"]];

                    $article.find(".title").text(article["title"]);
                    $article.find(".information").text("Wrote by " + user["login"]);
                    $article.find(".body").text(article["text"]);

                    $articles.append($article);
                });
            }
        })
    </script>
</@c.page>
