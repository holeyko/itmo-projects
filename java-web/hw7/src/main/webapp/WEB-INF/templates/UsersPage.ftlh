<#-- @ftlvariable name="users" type="ru.itmo.wp.model.domain.User[]" -->
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
                <#if user?? && user.admin>
                    <th class="user-toggleAdmin-header">Toggle Admin</th>
                </#if>
            </tr>
            </thead>
            <tbody>
            <template>
                <tr>
                    <td class="user-id"></td>
                    <td class="user-login"></td>
                    <td class="user-creationTime"></td>
                    <#if user?? && user.admin>
                        <td class="user-toggleAdmin">
                            <form method="post" action="">
                                <input type="hidden" name="action" value="toggleAdmin">
                                <div class="button-field">
                                    <input type="submit" value="">
                                </div>
                            </form>
                        </td>
                    </#if>
                </tr>
            </template>
            <tr class="noData">
                <td colspan="4">
                    No data
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <script>
        $(function () {
            const $noData = $(".users .noData");
            $noData.find("td").text("Loading...");

            ajax({
                data: {
                    action: "findAll"
                },
                successFunc: function (response) {
                    $noData.hide();

                    response["users"].forEach(function (user) {
                        <#if user?? && user.admin>
                            if (user["id"] === ${user.id}) {
                                return;
                            }
                        </#if>

                        const $tr = $($(".users template").prop("content")).clone();
                        $tr.find(".user-id").text(user["id"]);
                        $tr.find(".user-login").text(user["login"]);
                        $tr.find(".user-creationTime").text(user["creationTime"]);
                        <#if user?? && user.admin>
                            const $toggleForm = $tr.find(".user-toggleAdmin form");
                            const $toggleInput = $toggleForm.find("input");
                            $toggleInput.val(user["admin"] ? "Disable" : "Enable");

                            $toggleForm.submit(function () {
                                ajax({
                                    data: {
                                        action: "toggleAdmin",
                                        userAdminId: ${user.id},
                                        userToggleAdminId: user["id"],
                                        admin: $toggleInput.val() === "Enable",
                                    },
                                    successFunc: function (response) {
                                        if ($toggleInput.val() === "Disable") {
                                            $toggleInput.val("Enable");
                                        } else {
                                            $toggleInput.val("Disable");
                                        }
                                    }
                                })

                                return false;
                            });
                        </#if>

                        $tr.find("tr").attr("data-userId", user["id"]);
                        $(".users tbody").append($tr);
                    });

                    $(".users tr").click(function () {
                        const userId = $(this).attr("data-userId")
                        ajax({
                            data: {
                                action: "findUser",
                                userId: userId,
                            },
                            successFunc: function (response) {
                                notify(response["user"].creationTime);
                            }
                        });
                    });
                },
            });

            return false;
        });
    </script>
</@c.page>
