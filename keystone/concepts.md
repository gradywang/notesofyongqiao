## 概念说明
- **Credentials**:　用来确认用户的身份，包含三种：
	- 用户名和密码
	- 用户名和API Key
	- Keystone签发的Token
- **Service**：Keystone中注册的服务，比如Nove计算服务，Glance镜像服务等。每一个服务提供了一个或者多个endpoints，用户通过这些endpoints来使用这个服务。**整个Keystone中全局唯一**
- **Endpoint**：一个可以通过网络访问的URL（一般是Http的），用户通过这个URL访问对应的服务。Endpoint支持模板，用户通过这个模板URL可以访问某个Region中的多个服务。**Region之间隔离，每个Service在不同的Region之间有不同的Endpoints**。一个服务在一个Region中可以按不同的接口对应多个endpoints（admin：表示只有Admin用户可以使用，internal：内部服务使用，public：外部服务使用）
- **User**：使用keystone管理的服务的实体，可以是一个具体的人，系统或者服务。 用户需要先登录keystone，然后使用keystone分配的token来访问keystone管理的服务。用户必须以某种角色和Project绑定，才可以使用服务。
			- 
