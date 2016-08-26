<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" value="true" name="post" />
    <div>
    <h3>登录</h3>
        <table>
            
            <tr><td>账号：</td><td>
                <input type="text" name="txtname" value="" /></td></tr>
             <tr><td>密码：</td><td>
                <input type="password" name="txtpwd" value="" /></td></tr>
             <tr><td>&nbsp;</td><td>
                <input type="submit" value="登录" /></td></tr>
        </table>
    </div>
    </form>
</body>
</html>
