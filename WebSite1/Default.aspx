﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="scripts/jquery-3.3.1.min.js"></script>
        
    <title>HostedPayment Test Page</title>
    <style type="text/css">
        body {
            margin: 0px;
            padding: 0px;
        }

        #divAuthorizeNetPopupScreen {
            left: 0px;
            top: 0px;
            width: 100%;
            height: 100%;
            z-index: 1;
            background-color: #808080;
            opacity: 0.5;
            -ms-filter: 'progid:DXImageTransform.Microsoft.Alpha(Opacity=50)';
            filter: alpha(opacity=50);
        }

        #divAuthorizeNetPopup {
            position: absolute;
            left: 50%;
            top: 50%;
            margin-left: -200px;
            margin-top: -200px;
            z-index: 2;
            overflow: visible;
        }

        .AuthorizeNetPopupGrayFrameTheme .AuthorizeNetPopupOuter {
            background-color: #dddddd;
            border-width: 1px;
            border-style: solid;
            border-color: #a0a0a0 #909090 #909090 #a0a0a0;
            padding: 4px;
        }

        .AuthorizeNetPopupGrayFrameTheme .AuthorizeNetPopupTop {
            height: 23px;
        }

        .AuthorizeNetPopupGrayFrameTheme .AuthorizeNetPopupClose {
            position: absolute;
            right: 7px;
            top: 7px;
        }

            .AuthorizeNetPopupGrayFrameTheme .AuthorizeNetPopupClose a {
                background-image: url('content/closeButton1.jpg');
                background-repeat: no-repeat;
                height: 16px;
                width: 16px;
                display: inline-block;
            }

                .AuthorizeNetPopupGrayFrameTheme .AuthorizeNetPopupClose a:hover {
                    background-image: url('content/closeButton1h.jpg');
                }

                .AuthorizeNetPopupGrayFrameTheme .AuthorizeNetPopupClose a:active {
                    background-image: url('content/closeButton1a.jpg');
                }

        .AuthorizeNetPopupGrayFrameTheme .AuthorizeNetPopupInner {
            background-color: #ffffff;
            border-width: 2px;
            border-style: solid;
            border-color: #cfcfcf #ebebeb #ebebeb #cfcfcf;
        }

        .AuthorizeNetPopupGrayFrameTheme .AuthorizeNetPopupBottom {
            height: 30px;
        }

        .AuthorizeNetPopupGrayFrameTheme .AuthorizeNetPopupLogo {
            position: absolute;
            right: 9px;
            bottom: 4px;
            width: 200px;
            height: 25px;
            background-image: url('content/powered_simple.png');
        }

        .AuthorizeNetPopupSimpleTheme .AuthorizeNetPopupOuter {
            border: 1px solid #585858;
            background-color: #ffffff;
        }
    </style>
</head>
<body>
    <form runat="server" id ="form1">
        <asp:Button ID="btnGenerateToken" Text="Generate Authorize Net Token" runat="server" OnClick="btnGenerateToken_Click" />         
        <asp:TextBox ID="txtToken" runat="server" Text=""  /> 
        </form>

    <br />
    <hr />
    <form method="post" action="https://test.authorize.net/payment/payment" id="formAuthorizeNetPopup" name="formAuthorizeNetPopup" target="iframeAuthorizeNet" style="display: none;">
        <input type="hidden" id="popupToken" name="token" value="" />
    </form>

    Tocken Required for payment page <input type="text" id="inputtoken" value="" /> <br />
    <br />
    <hr />
    <div>
        Trigger Accept Transaction
	
        <button id="btnOpenAuthorizeNetPopup" onclick="AuthorizeNetPopup.openPopup()">Open AuthorizeNetPopup</button>
        <hr />
    </div>
    <div id="divAuthorizeNetPopup" style="display: none;" class="AuthorizeNetPopupGrayFrameTheme">
        <div class="AuthorizeNetPopupOuter">
            <div class="AuthorizeNetPopupTop">
                <div class="AuthorizeNetPopupClose">
                    <a href="javascript:;" onclick="AuthorizeNetPopup.closePopup();" title="Close"></a>
                </div>
            </div>
            <div class="AuthorizeNetPopupInner">
                <iframe name="iframeAuthorizeNet" id="iframeAuthorizeNet" src="empty.html" frameborder="0" scrolling="no"></iframe>
            </div>
            <div class="AuthorizeNetPopupBottom">
                <div class="AuthorizeNetPopupLogo" title="Powered by Authorize.Net"></div>
            </div>
            <div id="divAuthorizeNetPopupScreen" style="display: none;"></div>
        </div>
    </div>

    <script type="text/javascript">
        //Copied from https://github.com/tigermax139/hello_world
        (function () {
            if (!window.AuthorizeNetPopup) window.AuthorizeNetPopup = {};
            if (!AuthorizeNetPopup.options) AuthorizeNetPopup.options = {
                onPopupClosed: null
            };

            AuthorizeNetPopup.closePopup = function () {
                document.getElementById("divAuthorizeNetPopupScreen").style.display = "none";
                document.getElementById("divAuthorizeNetPopup").style.display = "none";
                document.getElementById("iframeAuthorizeNet").src = "empty.html";
                document.getElementById("btnOpenAuthorizeNetPopup").disabled = false;
                if (AuthorizeNetPopup.options.onPopupClosed) AuthorizeNetPopup.options.onPopupClosed();
            };


            AuthorizeNetPopup.openPopup = function () {
                var popup = document.getElementById("divAuthorizeNetPopup");
                var popupScreen = document.getElementById("divAuthorizeNetPopupScreen");
                var ifrm = document.getElementById("iframeAuthorizeNet");
                var form = document.forms["formAuthorizeNetPopup"];
                $("#popupToken").val($("#inputtoken").val());
                form.action = "https://test.authorize.net/payment/payment";
                ifrm.style.width = "442px";
                ifrm.style.height = "578px";

                form.submit();

                popup.style.display = "";
                popupScreen.style.display = "";
                centerPopup();
            };

            AuthorizeNetPopup.onReceiveCommunication = function (querystr) {
                var params = parseQueryString(querystr);
                switch (params["action"]) {
                    case "successfulSave":
                        AuthorizeNetPopup.closePopup();
                        break;
                    case "cancel":
                        AuthorizeNetPopup.closePopup();
                        break;
                    case "transactResponse":
                        var response = params["response"];
                        document.getElementById("token").value = response;
                        AuthorizeNetPopup.closePopup();
                        break;
                    case "resizeWindow":
                        var w = parseInt(params["width"]);
                        var h = parseInt(params["height"]);
                        var ifrm = document.getElementById("iframeAuthorizeNet");
                        ifrm.style.width = w.toString() + "px";
                        ifrm.style.height = h.toString() + "px";
                        centerPopup();
                        break;
                }
            };


            function centerPopup() {
                var d = document.getElementById("divAuthorizeNetPopup");
                d.style.left = "50%";
                d.style.top = "50%";
                var left = -Math.floor(d.clientWidth / 2);
                var top = -Math.floor(d.clientHeight / 2);
                d.style.marginLeft = left.toString() + "px";
                d.style.marginTop = top.toString() + "px";
                d.style.zIndex = "2";
                if (d.offsetLeft < 16) {
                    d.style.left = "16px";
                    d.style.marginLeft = "0px";
                }
                if (d.offsetTop < 16) {
                    d.style.top = "16px";
                    d.style.marginTop = "0px";
                }
            }

            function parseQueryString(str) {
                var vars = [];
                var arr = str.split('&');
                var pair;
                for (var i = 0; i < arr.length; i++) {
                    pair = arr[i].split('=');
                    vars.push(pair[0]);
                    vars[pair[0]] = unescape(pair[1]);
                }
                return vars;
            }
        }());

	</script>
</body>
</html>
