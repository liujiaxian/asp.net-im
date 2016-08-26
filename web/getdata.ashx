<%@ WebHandler Language="C#" Class="getdata" %>

using System;
using System.Web;

using System.Text;
using System.Data;
using System.Web.SessionState;

public class getdata : IHttpHandler,IRequiresSessionState {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string action=context.Request["action"];
        if (action=="getdata")
        {
            GetData(context);
        }
    }
    public t_user user = new t_user();
    /// <summary>
    /// 异步获取数据
    /// </summary>
    /// <returns></returns>
    public void GetData(HttpContext context)
    {
        if (context.Session["model"] == null)
        {
            context.Response.Redirect("/login.aspx");
        }

        user = context.Session["model"] as t_user;

        string userid=context.Request["user"];
        
        string sql = "";
        if (user.userRole==1)//管理员
        {
            sql = "select * from t_msg where userName='" + userid + "' or replyUser='" + userid + "'";
        }
        else
        {
            sql = "select * from t_msg where userName='" + user.userName + "' or replyUser='" + user.userName + "'";
        }
        
        DataTable tb = SqlHelper.ExecuteDataTable(sql);
        StringBuilder sb = new StringBuilder();
        if (tb.Rows.Count > 0)
        {
            foreach (DataRow row in tb.Rows)
            {
                string sendUser = row["userName"].ToString();
                string currentUser = row["replyUser"].ToString();
                string msg = row["msg"].ToString();
                string time = Convert.ToDateTime(row["addTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                if (user.userName != sendUser)
                {
                    sb.Append("<div class='chat-message' style='width:50%;margin-left:50%;'><img class='message-avatar' src='/static/img/a6.jpg' alt='' style='float:right;'><div class='message' style='margin-right:57px;'><a class='message-author' href='#'>" + sendUser + "</a><span class='message-date'>&nbsp;&nbsp;" + time + "</span><span class='message-content'>" + msg + "</span></div></div>");
                }
                else//管理员
                {
                    sb.Append("<div class='chat-message' style='width:50%;'><img class='message-avatar' src='/static/img/a6.jpg' alt='' style='float:left;'><div class='message' style='margin-left:57px;'><a class='message-author' href='#'>" + sendUser + "</a><span class='message-date'>&nbsp;&nbsp;" + time + "</span><span class='message-content'>" + msg + "</span></div></div>");
                }
            }
        }

        context.Response.Write(sb.ToString());
        context.Response.End();
    }
    
    
    public bool IsReusable {
        get {
            return false;
        }
    }

}