window.notify = function (message) {
    $.notify(message, {
        position: "right bottom",
        className: "success"
    });
}

window.ajax = function (ajaxArgs) {
    $.ajax({
        type: "POST",
        url: "",
        dataType: "json",
        data: ajaxArgs.data,
        success: function (response) {
            if (response["message"]) {
                notify(response["message"]);
            }

            if (response["redirect"]) {
                location.href = response["redirect"];
            } else {
                ajaxArgs.successFunc(response);
            }
        }
    });
}
