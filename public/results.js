// This project is libre, and licenced under the terms of the
// DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE, version 3.1,
// as published by dtf on July 2019. See the COPYING file or
// https://ph.dtf.wtf/w/wtfpl/#version-3-1 for more details.

function resend(e) {
    buttonClicked = $(e);
    input = buttonClicked.parent().find("input");
    requestData = unsanitize(buttonClicked.parent().parent().find("pre").html());
    requestDataJson = JSON.parse(requestData);
    url = input.val();
    input.val("");
    $.ajax(
        {
            url: url, 
            type: requestDataJson['request'], 
            data: JSON.stringify(requestDataJson['body']), 
            headers: requestDataJson['headers'], 
            contentType: requestDataJson['headers']['Content-Type'], 
            complete: function(jqxhr, status){alert(status);}
        }
    );
}

function unsanitize(html){
    return html
        .replace("&lt", "<")
        .replace("&gt", ">");
}
