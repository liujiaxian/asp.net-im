# asp.net-im
使用websocket进行即时聊天，类似客服……

### new - Web Sockets chat - Server 服务端
> 进行数据添加到数据库


### webim 客户端
> 主要是页面的交互以及一些逻辑的处理

### 数据库 
> 数据库脚本 sql server

### 案列开始

#### 登录

> 进行权限的区分，这里区分两种角色，管理员和普通用户。

![](/images/login.png)

#### 管理员

> 管理员聊天窗口 可以和所有的用户进行聊天，还有一个群发功能，发送给所有用户。

##### 聊天窗口
![](/images/adminindex.png)

##### 群发
![](/images/adminall.png)

##### 私法
![](/images/adminperson.png)

#### 普通用户

> 普通用户只能和管理员进行聊天。

![](/images/clientindex.png)

> 这只是初期demo，还会不断的完善，增加一些功能，本人的计划是完善成一个通过脚本引用的插件，分享给更多的人使用。<br>
如果您有更好的意见或建议，本人非常欢迎您指出，谢谢。
