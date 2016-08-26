using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Web_Sockets_Test___Server
{
    public class t_msg
    {
        public string userName { get; set; }
        public string msg { get; set; }
        public string replyUser { get; set; }
        public DateTime addTime { get; set; }
        public string state { get; set; }
    }
}
