using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// t_user 的摘要说明
/// </summary>
public class t_user
{
    public int userID { get; set; }
    public string userName { get; set; }
    public string userPwd { get; set; }
    public int userRole { get; set; }
    public DateTime addTime { get; set; }
}