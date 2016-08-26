using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Service : System.Web.UI.Page
{
    public t_user user = new t_user();
    public DataTable tb = new DataTable();
    public string data = "";
    public string newtime = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["model"] == null)
        {
            Response.Redirect("/login.aspx");
        }

        user = Session["model"] as t_user;



        tb = GetAllUser();

        newtime = GetNewTime();
    }
    /// <summary>
    /// 获取用户列表
    /// </summary>
    /// <returns></returns>
    public DataTable GetAllUser()
    {
        string sql = "select * from t_user where userRole!=1";
        DataTable tb = SqlHelper.ExecuteDataTable(sql);
        return tb;
    }
    /// <summary>
    /// 获取最新消息时间
    /// </summary>
    /// <returns></returns>
    public string GetNewTime()
    {
        string sql = "",time="";
        if (user.userRole==1)//管理员
        {
            sql = "select top 1 * from t_msg where replyUser!='admin' order by msgID desc";
        }
        else
        {
            sql = "select top 1 * from t_msg where userName='"+user.userName+"'";
        }

        DataTable tb = SqlHelper.ExecuteDataTable(sql);
        if (tb.Rows.Count>0)
        {
            foreach (DataRow row in tb.Rows)
            {
                time = Convert.ToDateTime(row["addTime"]).ToString("yyyy-MM-dd HH:mm:ss");
            }
        }
        return time;
    }

    
}