# 概念说明

- Region
	- 在openstack世界里，可以部署多套，他们共享keystone和horizon，以套openstack就称为一个Region。在概念上可以理解为不同区域部署一套openstack；
	- 每个Region都有各自的一套服务endpoints(服务入口)；
	- 多个Region共享一套keystone来提供访问控制；

- Service
	- Keystone中注册管理的服务，比如Nova计算服务，Glance镜像服务等；
	- 每个服务提供了一套endpoints，用户通过这些endpoints来访问这些服务;
	- 用户可以通过/v3/auth/catalog API查询到keystone中注册的所有服务以及他们对应的endpoints;
	
- Endpoint
	- 一个可以通过网络访问的URL(一般是HTTP的)，用户通过这个URL访问对应的服务；
	- 每一个Service在不同的Region中有不同的一组endpoints;
	- Endpoint可以设置为不同的类型：admin：表示只有Admin用户才可以使用的；internal：表示内部服务使用的；external：表示外部服务使用的。
	
- User
	- 使用Keystone管理服务的实体，可以是一个具体的人，系统或者服务；
	- 用户在创建的一刻就决定了他的归属（只能属于某一个且只能属于某一个Domain，创建用户时可以指定Domain，如果不指定用Token中的Domain），也就是说一个Domain中不能存在同名用户；
	- 用户在创建之后，必须以某种角色和Domian或者Project绑定，然后才可以使用绑定的Domain或者Project生成scoped token;
	- 用户需要先登录（用户名+密码+scope）keystone，然后使用keystone分配的scoped token来访问keystone管理的服务；

- Domian 
	- 云服务的客户，一个独立的组织，在逻辑上，命名空间中需要和其他组织隔离的的实体；
	- 组织中的管理员有权限为这个组织创建结构（user,group），资源划分（project）和权限（role）的分配等； 
