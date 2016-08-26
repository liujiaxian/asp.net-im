<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Service.aspx.cs" Inherits="Service" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>聊天室</title>
    <script src="jquery-min.js" type="text/javascript"></script>

    <link rel="shortcut icon" href="favicon.ico">
    <link href="/static/css/bootstrap.min14ed.css?v=3.3.6" rel="stylesheet">
    <link href="/static/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
    <link href="/static/css/animate.min.css" rel="stylesheet">
    <link href="/static/css/style.min862f.css?v=4.1.0" rel="stylesheet">

    <script type="text/javascript">
        var ws;
        var SocketCreated = false;
        var isUserloggedout = false;

        function lockOn(str) {
            var lock = document.getElementById('skm_LockPane');
            if (lock)
                lock.className = 'LockOn';
            lock.innerHTML = str;
        }

        function lockOff() {
            var lock = document.getElementById('skm_LockPane');
            lock.className = 'LockOff';
        }

        function ToggleConnectionClicked() {
            if (SocketCreated && (ws.readyState == 0 || ws.readyState == 1)) {
                //lockOn("离开聊天室...");
                SocketCreated = false;
                isUserloggedout = true;
                ws.close();
            } else {
                //lockOn("进入聊天室...");
                //Log("准备连接到聊天服务器 ...");
                try {
                    if ("WebSocket" in window) {
                        ws = new WebSocket("ws://" + document.getElementById("Connection").value);
                    }
                    else if ("MozWebSocket" in window) {
                        ws = new MozWebSocket("ws://" + document.getElementById("Connection").value);
                    }

                    SocketCreated = true;
                    isUserloggedout = false;
                } catch (ex) {
                    Log(ex, "ERROR");
                    return;
                }
                //document.getElementById("ToggleConnection").innerHTML = "断开";
                ws.onopen = WSonOpen;
                ws.onmessage = WSonMessage;
                ws.onclose = WSonClose;
                ws.onerror = WSonError;
            }
        };


        function WSonOpen() {
            lockOff();
            //Log("连接已经建立。", "OK");
            //$("#SendDataContainer").show();
            //发送json
            var currentUser = '<%=user.userName %>';
            var par = {
                userName: currentUser,
                state: "login"
            };
            ws.send(JSON.stringify(par));
        };

        function WSonMessage(event) {
            Log(event.data);
        };

        function WSonClose() {
            lockOff();
            var currentUser = '<%=user.userName %>';
            var par = {
                userName: currentUser,
                state: "layout"
            };
            //ws.send("dsafasf");
            if (isUserloggedout)
                Log(JSON.stringify(par));
<%--            ws.send("【<%=user.userName %>】离开了聊天室！");--%>

        };

        function WSonError() {
            lockOff();
            //Log("远程连接中断。", "ERROR");
        };

        //发送数据
        function SendDataClicked() {
            if (document.getElementById("DataToSend").value.trim() != "") {
                //发送json
                var time = new Date().Format("yyyy-MM-dd hh:mm:ss");
                var currentUser = '<%=user.userName %>';
                var userRole = '<%=user.userRole %>';
                var content = document.getElementById("DataToSend").value;
                var replyUser;
                var state = $(".txtchatwindow").text().trim();

                if (userRole == "1") {//管理员
                    replyUser = $(".txtchatwindow").text();
                }
                else {
                    replyUser = "admin";
                }


                if (state == "所有") {
                    state = "all";
                }
                var par = {
                    userName: currentUser,
                    msg: content,
                    state: state,
                    replyUser: replyUser,
                    addTime: time
                };
                ws.send(JSON.stringify(par));
                document.getElementById("DataToSend").value = "";
            }
        };


        function Log(Text, MessageType) {

            //if (MessageType == "OK") Text = "<div style='text-align:center'><span style='color: green;'>" + Text + "</span></div>";
            //if (MessageType == "ERROR") Text = "<div style='text-align:center'><span style='color: red;'>" + Text + "</span></div>";
            //处理json
            Text = JSON.parse(Text);
            //alert(Text.state);
            if (Text.state == "login") {
                online(Text);
                return;
            }
            if (Text.state == "layout") {
                offline(Text);
                //alert(Text.userName);
                return;
            }
            //alert($(".txtchatwindow").text());
            var s2 = "";
            if (Text.userName == "<%=user.userName %>") { //自己
                s2 += "<div class='chat-message' style='width:50%;'><img class='message-avatar' src='/static/img/a6.jpg' alt='' style='float:left;'><div class='message' style='margin-left:57px;'><a class='message-author' href='#'>" + Text.userName + "</a><span class='message-date'>&nbsp;&nbsp;" + Text.addTime + "</span><span class='message-content'>" + Text.msg + "</span></div></div>";
            } else if (Text.replyUser == "<%=user.userName %>") {
                //alert(Text.userName + "|" + $(".txtchatwindow").text());
                if ("<%=user.userRole%>" == "1" && $(".txtchatwindow").text() != Text.userName) {
                } else {
                    s2 += "<div class='chat-message' style='width:50%;margin-left:50%;'><img class='message-avatar' src='/static/img/a6.jpg' alt='' style='float:right;'><div class='message' style='margin-right:57px;'><a class='message-author' href='#'>" + Text.userName + "</a><span class='message-date'>&nbsp;&nbsp;" + Text.addTime + "</span><span class='message-content'>" + Text.msg + "</span></div></div>";
                }
            }
            //alert(s2);
            //var s3=document.getElementById("LogContainer").innerHTML.trim()+s2;
            //document.getElementById("LogContainer").innerHTML = document.getElementById("LogContainer").innerHTML.trim() + s2;
            //alert(s3);
        $("#LogContainer").append(s2);

        var LogContainer = document.getElementById("LogContainer");
        LogContainer.scrollTop = LogContainer.scrollHeight;
            //alert(document.getElementById("LogContainer").innerHTML);
            //alert(s3);
    };


    $(document).ready(function () {
        //$("#SendDataContainer").hide();
        var WebSocketsExist = true;
        //try {
        //    var dummy = new WebSocket("ws://localhost:8989/test");
        //} catch (ex) {
        //    try {
        //        webSocket = new MozWebSocket("ws://localhost:8989/test");
        //    }
        //    catch (ex) {
        //        WebSocketsExist = false;
        //    }
        //}

        if (WebSocketsExist) {
            //Log("您的浏览器支持WebSocket. 您可以尝试连接到聊天服务器!", "OK");
            document.getElementById("Connection").value = "169.254.133.141:4141/chat";
        } else {
            //Log("您的浏览器不支持WebSocket。请选择其他的浏览器再尝试连接服务器。", "ERROR");
            //document.getElementById("ToggleConnection").disabled = true;
            alert("你的浏览器不支持！");
        }

        $("#DataToSend").keypress(function (evt) {
            if (evt.keyCode == 13) {
                if ($(".txtchatwindow").text() == "") {
                    alert('请选择聊天好友');
                    return;
                }
                //$("#SendData").click();
                SendDataClicked();
                evt.preventDefault();
            }
        })

        ToggleConnectionClicked();

        //异步加载数据
        getdata();
    });


    // 对Date的扩展，将 Date 转化为指定格式的String
    // 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
    // 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
    // 例子： 
    // (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
    // (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
    Date.prototype.Format = function (fmt) { //author: meizz 
        var o = {
            "M+": this.getMonth() + 1, //月份 
            "d+": this.getDate(), //日 
            "h+": this.getHours(), //小时 
            "m+": this.getMinutes(), //分 
            "s+": this.getSeconds(), //秒 
            "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
            "S": this.getMilliseconds() //毫秒 
        };
        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    }


    //点击与谁聊天
    function chatwindow(name) {
        $(".txtchatwindow").text(name);

        $("#LogContainer").children().remove();

        getdata();
    }

    //异步加载聊天信息
    function getdata() {
        var user = $(".txtchatwindow").text();
        $.post("/getdata.ashx", { action: "getdata", user: user }, function (data) {
            $("#LogContainer").append(data);

            var LogContainer = document.getElementById("LogContainer");
            LogContainer.scrollTop = LogContainer.scrollHeight;
        });
    }

    //在线
    function online(Text) {

        $(".users-list div a").each(function () {
            var a = $(this).html();
            //alert(Text.userName+"|"+a);
            if (Text.userName == a) {

                $(this).parent().parent().find(".isinline").children().remove();
                $(this).parent().parent().find(".isinline").append("<span class='pull-right label label-primary'>在线</span>");
            }
        });
    }

    //离线
    function offline(Text) {
        $(".users-list div a").each(function () {
            var a = $(this).html();
            alert(Text.userName + "|" + a);
            if (Text.userName == a) {
                $(this).parent().parent().find(".isinline").children().remove();
            }
        });
    }

    //群发
    function sendall() {
        $("#LogContainer").children().remove();
        $(".txtchatwindow").text("所有");
    }
    </script>
</head>
<body>
    <div id="skm_LockPane" class="LockOff"></div>
    <form id="form1" runat="server">
        <h1>Web Socket 聊天室</h1>
        <br />
        <%--        <div>
            按下连接按钮，会通过WebSocket发起一个到聊天浏览器的连接。
        </div>
        服务器地址:
        <input type="hidden" id="Connection" />
        用户名：
        <input type="text" id="txtName" value="<%=user.userName %>" />
        <button id='ToggleConnection' type="button" onclick='ToggleConnectionClicked();'>连接</button>--%>
        <input type="hidden" id="Connection" />
        <%--        <br />
        <br />
        <div id='LogContainer' class='container'></div>
        <br />
        <div id='SendDataContainer'>
            <input type="text" id="DataToSend" size="88" />
            <button id='SendData' type="button" onclick='SendDataClicked();'>发送</button>
        </div>--%>
        <br />

        <div class="wrapper wrapper-content  animated fadeInRight">

            <div class="row">
                <div class="col-sm-12">

                    <div class="ibox chat-view">

                        <div class="ibox-title">
                            <small class="pull-right text-muted">
                                <%if (user.userRole==1)
                                  {%>
                                <input type="button" onclick="sendall()" value="群发" />&nbsp;
                                      
                                  <%} %>最新消息：<%=newtime %></small> 与 <span class="txtchatwindow"><%
                                                                                                                                                         if (user.userRole != 1)
                                                                                                                                                         {
                                                                                                                                                             Response.Write("admin");
                                                                                                                                                         }
                                                                                                                                                         else
                                                                                                                                                         {
                                                                                                                                                             Response.Write("所有");
                                                                                                                                                         } %></span> 聊天窗口
                        </div>


                        <div class="ibox-content">

                            <div class="row">

                                <div class="col-md-9 ">
                                    <div class="chat-discussion" id='LogContainer'>
                                    </div>

                                </div>
                                <div class="col-md-3">
                                    <div class="chat-users">


                                        <div class="users-list">
                                            <%if (tb.Rows.Count > 0 && user.userRole == 1)
                                              {
                                                  foreach (System.Data.DataRow row in tb.Rows)
                                                  {%>
                                            <div class="chat-user" onclick="chatwindow('<%=row["userName"] %>')">
                                                <span class="isinline"></span>
                                                <img class="chat-avatar" src="/static/img/a4.jpg" alt="">
                                                <div class="chat-user-name">
                                                    <a href="javascript:;"><%=row["userName"] %></a>
                                                </div>
                                            </div>

                                            <%}
                                              }
                                              else
                                              {%>
                                            <div class="chat-user">
                                                <img class="chat-avatar" src="/static/img/a4.jpg" alt="">
                                                <div class="chat-user-name">
                                                    <a href="#">管理员</a>
                                                </div>
                                            </div>
                                            <%} %>



                                            <%--  <div class="chat-user">
                                            <img class="chat-avatar" src="/static/img/a1.jpg" alt="">
                                            <div class="chat-user-name">
                                                <a href="#">从未出现过的风景__</a>
                                            </div>
                                        </div>
                                        <div class="chat-user">
                                            <span class="pull-right label label-primary">在线</span>
                                            <img class="chat-avatar" src="/static/img/a2.jpg" alt="">
                                            <div class="chat-user-name">
                                                <a href="#">冬伴花暖</a>
                                            </div>
                                        </div>
                                        <div class="chat-user">
                                            <span class="pull-right label label-primary">在线</span>
                                            <img class="chat-avatar" src="/static/img/a3.jpg" alt="">
                                            <div class="chat-user-name">
                                                <a href="#">ZM敏姑娘	</a>
                                            </div>
                                        </div>
                                        <div class="chat-user">
                                            <img class="chat-avatar" src="/static/img/a5.jpg" alt="">
                                            <div class="chat-user-name">
                                                <a href="#">才越越</a>
                                            </div>
                                        </div>
                                        <div class="chat-user">
                                            <img class="chat-avatar" src="/static/img/a6.jpg" alt="">
                                            <div class="chat-user-name">
                                                <a href="#">时光十年TENSHI</a>
                                            </div>
                                        </div>
                                        <div class="chat-user">
                                            <img class="chat-avatar" src="/static/img/a2.jpg" alt="">
                                            <div class="chat-user-name">
                                                <a href="#">刘顰颖</a>
                                            </div>
                                        </div>
                                        <div class="chat-user">
                                            <span class="pull-right label label-primary">在线</span>
                                            <img class="chat-avatar" src="/static/img/a3.jpg" alt="">
                                            <div class="chat-user-name">
                                                <a href="#">陈泳儿SccBaby</a>
                                            </div>
                                        </div>--%>
                                        </div>

                                    </div>
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="chat-message-form">

                                        <div class="form-group">

                                            <textarea class="form-control message-input" id="DataToSend" name="message" placeholder="输入消息内容，按回车键发送"></textarea>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript" src="/static/js/jquery.min.js?v=2.1.4"></script>
    <script type="text/javascript" src="/static/js/bootstrap.min.js?v=3.3.6"></script>
    <script type="text/javascript" src="/static/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script type="text/javascript" src="/static/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <script type="text/javascript" src="/static/js/plugins/layer/layer.min.js"></script>
    <script type="text/javascript" src="/static/js/hplus.min.js?v=4.1.0"></script>
    <script type="text/javascript" src="/static/js/contabs.min.js"></script>

</body>
</html>
