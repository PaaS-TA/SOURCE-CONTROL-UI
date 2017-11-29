/**
 * Created by ijlee on 2017-07-05.
 */

// CALL AJAX
/**
 * jQuery.get( url [, data ] [, success ] [, dataType ] )
 *  url
 *    Type: String
 *    A string containing the URL to which the request is sent.
 *  data
 *    Type: PlainObject or String
 *    A plain object or string that is sent to the server with the request.
 *        success
 *    Type: Function( PlainObject data, String textStatus, jqXHR jqXHR )
 *    A callback function that is executed if the request succeeds. Required if dataType is provided, but you can use null or jQuery.noop as a placeholder.
 *        dataType
 *    Type: String
 *    The type of data expected from the server. Default: Intelligent Guess (xml, json, script, text, html).
 */
var goHome ="/user/repository/?page=0&size=10";

var moveHome = function(){
    location.href = goHome;
}
// GET DASHBOARD URL
var procGetUrl = function () {
    var currentUrl = location.pathname;
    var splitString = "/";
    var splits = currentUrl.split(splitString);

    return splitString + splits[1] + splitString + splits[2];
};

var getProcCallAjax = function (reqUrl, param, callback) {
    console.log("GET REQUEST: " + reqUrl);
    var param = JSON.stringify(param);
    var jqxhr = $.get(reqUrl, function (param) {
        // procCallSpinner('START');
        console.log(reqUrl + " : Data Load" + param + " : jqxhr success");
    }).success(function (data) {
        if (data) {
            callback(data, param);
        } else {
        }
        console.log(reqUrl + " : success");
    }).error(function (xhr, status, error) {
        console.log("ERROR :: error :: ", error);
    }).complete(function (data) {
        //procCallSpinner('STOP');
        console.log("COMPLETE :: data :: ", data);
    });
};


var delProcCallAjax = function (reqUrl, callback) {
    console.log("reqUrl:" + reqUrl);
    $.ajax({
        url: reqUrl,
        type: 'DELETE',
        dataType: 'json',
        contentType: "application/json",
        success: function (data) {
            if (data) {
                callback(data);
            } else {
            }
        },
        error: function (xhr, status, error) {
            console.log("ERROR :: error ::", error);
            //alert("삭제에 실패하였습니다.")
            popupAlertClick("삭제에 실패하였습니다.");
        },
        complete: function (data) {
            console.log("COMPLETE :: data :: ", data);
        }
    });
};


var postProcCallAjax = function (reqUrl, param, callback) {
    console.log("POST REQUEST");

    var reqData = {};

    if (param != null) {
        reqData = JSON.stringify(param);
    }
    console.log(reqData);
    $.ajax({
        url: reqUrl,
        method: "POST",
        data: reqData,
        dataType: 'json',
        contentType: "application/json",
        beforeSend: function (xhr) {
        },
        success: function (data) {
            if (data) {
                callback(data);
            } else {
            }
        },
        error: function (xhr, status, error) {
            console.log("ERROR :: error :: ", error);
        },
        complete: function (data) {
            console.log("COMPLETE :: data :: ", data);
        }
    });
};


var putProcCallAjax = function (reqUrl, param, callback) {
    console.log("PUT REQUEST");

    var reqData = {};

    if (param != null) {
        reqData = JSON.stringify(param);
        console.log("reqData::::" + reqData);
    }

    $.ajax({
        url: reqUrl,
        method: "PUT",
        data: reqData,
        dataType: 'json',
        contentType: "application/json",
        beforeSend: function (xhr) {
        },
        success: function (data) {
            if (data) {
                callback(data);
            } else {
            }
        },
        error: function (xhr, status, error) {
            console.log("ERROR :: error :: ", error);
        },
        complete: function (data) {
            console.log("COMPLETE :: data :: ", data);
        }
    });
};


//get 을 할때 procCallAjax('get', '/admin/serviceInstantList'?검색명,.param {"이름":"입력이름"}, callback)
var procCallAjax = function (callRequest, reqUrl, param, callback) {
    if (callRequest == 'get') {
        getProcCallAjax(reqUrl, param, callback);
    }
    if (callRequest == 'post') {
        postProcCallAjax(reqUrl, param, callback);
    }
    if (callRequest == 'put') {

        putProcCallAjax(reqUrl, param, callback);
    }
    if (callRequest == 'delete') {
        delProcCallAjax(reqUrl, callback);
    }
};


// MOVE PAGE
var procMovePage = function (pageUrl) {
    if (pageUrl == null || pageUrl.length < 1) {
        return false;
    }

    if ((!!pageUrl && typeof pageUrl == 'number') && -1 == pageUrl) {
        history.back();
    } else {
        pageUrl = ("/" == pageUrl) ? "" : pageUrl;
        location.href = location.pathname + pageUrl;
    }
};
/**팝업 확인**/
var popupConfirmClick = function (reqTitle, reqMessage, procFunction, reqButtonText) {

    if (null == reqTitle || reqTitle.length < 1) return false;
    if (null == reqMessage || reqMessage.length < 1) return false;
    if (null == procFunction) return false;

    var objButtonText = $('#commonPopupConfirmButtonText');
    var buttonText = (null == reqButtonText || '' == reqButtonText || undefined == reqButtonText) ? reqMessage.split(' ')[0] : reqButtonText;

    $('#commonPopupConfirmTitle').html(reqTitle);
    $('#commonPopupConfirmMessage').html(reqMessage);

    objButtonText.html(buttonText);
    objButtonText.attr('onclick', procFunction);

    $('#modalConfirm').modal('toggle');
};
/**팝업 확인**/
var popupAlertClick = function (reqMessage) {

    if (null == reqMessage || reqMessage.length < 1) return false;
    $('#commonPopupAlertMessage').html(reqMessage);
    $('#modalAlert').modal('toggle');

};

/**팝업 닫기**/
var procClosePopup = function () {
    $('div.modal').modal('hide');
};

/**팝업 열기**/
var procPopupAlert = function (reqMessage, procFunction, reqClosePopup) {
    if (null == reqClosePopup || undefined == reqClosePopup) {
        procClosePopup();
    }
    if (reqMessage == null || reqMessage.length < 1) return false;

    $('#commonPopupAlertMessage').html(reqMessage);

    var objModalAlert = $('#modalAlert');

    objModalAlert.modal('show');
    objModalAlert.on('hide.bs.modal', function () {
        if (null != procFunction && undefined != procFunction && reqMessage.length > 0) {
            setTimeout(function () {
                eval(procFunction);
            }, 3);
        }
    })
};
/**
 * [!@#$%&'*+/=?<>{|}\'\\\",;:] 이 들어있으면 false
 * @param repositoryName
 * @returns {boolean}
 */
var validRepositoryName = function (repositoryName) {
    var rtnVal = false;
    if(repositoryName == null || repositoryName == "") {
        return false;
    }

    var r1 = new RegExp("[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]");
    if (repositoryName.match(r1) == null) {
        var r2 = new RegExp("[!@#$%&'*+/=?<>{|}\'\\\",;:]");
        (repositoryName.match(r2) == null) ? rtnVal = true : rtnVal = false;
    }
    return rtnVal;
};

var validUserName;
validUserName = function (validUserName) {
    var rtnVal = false;

    if(validUserName.length < 2) {
        return false;
    }

    if(validUserName == null || validUserName == "") {
        return false;
    }

    var r1 = new RegExp("[]");
    if (validUserName.match(r1) == null) {
        var r2 = new RegExp("[!@#$%&'*+/=?<>{|}\'\\\",;:]");
        (validUserName.match(r2) == null) ? rtnVal = true : rtnVal = false;
    }
    return rtnVal;
};


function getParamValue(param) {
    var urlParamString = location.search.split(param + "=");
    if (urlParamString.length <= 1) return "";
    else {
        var tmp = urlParamString[1].split("&");
        return tmp[0];
    }
}