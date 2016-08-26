using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string post=Request["post"];
        if (post=="true")
        {
            string name = Request["txtname"];
            string pwd=Request["txtpwd"];
            string sql = "select * from t_user where userName=@loginName and userPwd=@loginPwd";
            SqlParameter[] pams = { 
                                  new SqlParameter("@loginName",name),
                                  new SqlParameter("@loginPwd",pwd)
                                  };
            SqlDataReader dr=SqlHelper.ExecuteReader(sql,pams);
            t_user user = new t_user();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    user.userID = Convert.ToInt32(dr["userID"]);
                    user.userName = dr["userName"].ToString();
                    user.userPwd = dr["userPwd"].ToString();
                    user.userRole = Convert.ToInt32(dr["userRole"]);
                    user.addTime = Convert.ToDateTime(dr["addTime"]);
                }
            }
            else
            {
                user = null;
            }
            if (user!=null)
            {
                Session["model"] = user;
                Response.Write("<script>window.location='/Service.aspx';</script>");

            }
            else
            {
                Response.Write("<script>alert('登录失败！');window.history.go(-1);</script>");
            }
        }
    }
}