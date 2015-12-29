测试账户：
				导购：daogou01/123456（无权限）
				设计师：shejs01/123456（有权限）
				
账号过期：目前系统设定过期时间为30分钟，正式上线后可调至60分钟等等			
	
状态值说明：
	( "10000", "用户名或者密码为空") ;
	( "10001", "用户不存在") ;
	( "10002", "用户密码错误") ;
	( "10003", "用户没有权限") ;
	( "10004", "用户登录成功") ;
	( "10005", "用户注销成功") ;
	( "10006", "用户注销失败") ;
	( "10007", "用户会话正常") ;
	( "10008", "用户会话过期") ;		
			
请求前缀：http://crm.osnyun.com/rpcmanager/control/

1、登录请求：ipadUserLogin
参数说明：userLoginId【登录账号】
				password【密码】
返回值：
	格式：{"returnValue":{"data":[{"userLoginId":"shejs01","personName":"设计师1"}],"status":"10004","message":"用户登录成功","accessToken":"1iePpROtx3g8xEGav5jlZ2"}}		
	说明：返回值中其他属性不用管，这是系统自带的，每个请求里面都有的。
			 ( "10000", "用户名或者密码为空") ;
			 ( "10001", "用户不存在") ;
			 ( "10002", "用户密码错误") ;
			 ( "10003", "用户没有权限") ;
			 ( "10004", "用户登录成功") ;
	
2、注销请求：ipadUserLogout
参数说明：userLoginId【登录账号】
				accessToken【令牌】	
返回值：略
			( "10005", "用户注销成功") ;
			( "10006", "用户注销失败") ;

3、会话验证是否过期请求：ipadUserSessionJudge
参数说明：userLoginId【登录账号】
				accessToken【令牌】	
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10008", "用户会话过期") ;	
			( "10007", "用户会话正常") ;
			
4、装修案例首页-【空间|风格|户型】-查询项数据请求：ipadDcCaseTagSelectData【2014-12-02】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadDcCaseTagSelectData?userLoginId=shejs01&accessToken=28_zhJHKVbIrYBmpBR7I8a
参数说明：userLoginId【登录账号】
				accessToken【令牌】	
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;
			
5、装修案例首页-案例列表数据请求：ipadDcCaseListData【2014-12-03】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadDcCaseListData?userLoginId=shejs01&accessToken=28_zhJHKVbIrYBmpBR7I8a
参数说明：userLoginId【登录账号】
				accessToken【令牌】	
				viewIndex【当前页数，默认从1开始】
				viewSize【每页记录数】
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;							
			
6、装修案例首页-案例列表数据请求（带参数查询）：ipadDcCaseListData【2014-12-03】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadDcCaseListData?userLoginId=shejs01&accessToken=1PJrsnidxdwo2gC9t5R7D8&exhibitionName=厨房
参数说明：userLoginId【登录账号】
				accessToken【令牌】	
				viewIndex【当前页数，默认从0开始】
				viewSize【每页记录数】
				exhibitionName【案例名】
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;					
					
					
7、装修案例首页-案例列表数据请求（空间|风格|户型查询）：ipadDcCaseListData【2014-12-04】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadDcCaseListData?userLoginId=shejs01&accessToken=1PJrsnidxdwo2gC9t5R7D8&exhibitionName=&roomId=&styleId=&houseTypeId=
参数说明：userLoginId【登录账号】
				accessToken【令牌】	
				viewIndex【当前页数，默认从0开始】
				viewSize【每页记录数】
				exhibitionName【案例名】
				
				roomId【空间】-------------ipadDcCaseTagSelectData接口数据中enumId属性值
				styleId【风格】-------------ipadDcCaseTagSelectData接口数据中enumId属性值
				houseTypeId【户型】--------ipadDcCaseTagSelectData接口数据中enumId属性值
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;			
			
			
8、装修案例详情页数据请求：ipadDcCaseDetailData【2014-12-05】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadDcCaseDetailData?userLoginId=shejs01&accessToken=3duT2vWT1eQqu0hjdA-0Gk&exhibitionId=10070
参数说明：userLoginId【登录账号】
				accessToken【令牌】	
				exhibitionId【案例ID】
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;					
			
9、焦点图数据请求：ipadFocusImageData【2014-12-06】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadFocusImageData?userLoginId=shejs01&accessToken=3duT2vWT1eQqu0hjdA-0Gk&factoryId=&municipalId=&shopId=
参数说明：userLoginId【登录账号】
				accessToken【令牌】	
				factoryId【平台级ID】	
				municipalId【经销商ID】	
				shopId【门店级ID】	
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;			
			
10、装修案例首页-案例列表数据请求（修改）：ipadDcCaseListData【2014-12-07】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadDcCaseListData?userLoginId=shejs01&accessToken=1PJrsnidxdwo2gC9t5R7D8&exhibitionName=厨房
参数说明：userLoginId【登录账号】
				accessToken【令牌】	
				viewIndex【当前页数，默认从1开始】
				viewSize【每页记录数】
				exhibitionName【案例名】
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;						
			
11、登录请求：ipadUserLogin【2014-12-09】
参数说明：userLoginId【登录账号】
				password【密码】
返回值：
	格式：{"returnValue":{"data":[{"userLoginId":"shejs01","personName":"设计师1"}],"status":"10004","message":"用户登录成功","accessToken":"1iePpROtx3g8xEGav5jlZ2"}}		
	说明：接口更新，返回信息中加入登录用户的省市区信息
			 ( "10000", "用户名或者密码为空") ;
			 ( "10001", "用户不存在") ;
			 ( "10002", "用户密码错误") ;
			 ( "10003", "用户没有权限") ;
			 ( "10004", "用户登录成功") ;	
	
12、楼盘主页-用户所在城市所有区域-数据请求：ipadUserCityAreaData【2014-12-09】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadUserCityAreaData?userLoginId=shejs01&accessToken=1PJrsnidxdwo2gC9t5R7D8&provinceId=&cityId=
参数说明：userLoginId【登录账号】
				accessToken【令牌】
				provinceId【省ID】
				cityId【城市ID】		
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;				
			
13、装修案例首页-案例列表数据请求：ipadBuildingListData【2014-12-13】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadBuildingListData?userLoginId=shejs01&accessToken=1PJrsnidxdwo2gC9t5R7D8&provinceId=&cityId=&areaId=&buildingName=
参数说明：userLoginId【登录账号】
				accessToken【令牌】	
				viewIndex【当前页数，默认从1开始】
				viewSize【每页记录数】
				buildingName【楼盘名】
				provinceId【省ID】
				cityId【城市ID】
				areaId【区域ID】				
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;		
			
14、小区楼盘详情页-（楼盘详情信息，户型列表信息，案例列表信息）请求：ipadBuildingModelAndCaseInfoData【2014-12-14】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadBuildingModelAndCaseInfoData?userLoginId=shejs01&accessToken=3zxet_IP1eDHeVKnFzL0Sm&buildingId=Mtjsf_10050
				userLoginId【登录账号】
				accessToken【令牌】	
				buildingId【楼盘主键】
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;
			
15、小区楼盘-三级详情页面-案例图片浏览请求：ipadBuildingCaseBrowseImageData【2014-12-15】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadBuildingCaseBrowseImageData?userLoginId=shejs01&accessToken=3zxet_IP1eDHeVKnFzL0Sm&buildingId=&modelId=&exhibitionId=
				userLoginId【登录账号】
				accessToken【令牌】	
				buildingId【楼盘主键】
				modelId【楼盘户型主键】
				exhibitionId【案例主键】--可选参数
				roomId【空间Id】--可选参数，当值为all的时候，查询出所有案例
说明：1、由”户型图“点击到该页面传前面四个参数，
		 2、由样板房（案例）点击到该页面5个参数都要传，返回值中有	isCurrentRoom，isCurrentCase两个参数要注意
		       isCurrentRoom为true，表示对应的空间tab高亮，isCurrentCase为true表示打开页面，对应的图片为当前图片
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;
			
16、产品库主页-页面左边栏查询项数据请求：ipadOcnProductQueryItemData【2014-12-16】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadOcnProductQueryItemData?userLoginId=shejs01&accessToken=0397N9sBxcB8aIh7Vm7-aC
				userLoginId【登录账号】
				accessToken【令牌】	
说明：略
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;	
			
17、产品库主页-主体产品数据请求：ipadOcnProductListData【2014-12-16】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadOcnProductListData?userLoginId=shejs01&accessToken=0397N9sBxcB8aIh7Vm7-aC&type=
				userLoginId【登录账号】
				accessToken【令牌】	
				viewIndex【当前页数，默认从1开始】
				viewSize【每页记录数】
				type【类型】【recommend,classify,room,style,standard】【精品推荐,产品分类,产品空间,产品风格,产品规格】
				recommendId【精品推荐ID】
				classifyId【产品分类ID】
				subClassifyId【产品分类子类ID】
				roomId【产品空间ID】
				styleId【产品风格ID】
				standardId【产品规格ID】
				queryItemValue【系统默认查编号或者名字】
说明：传入的几个ID是互斥的，根据type的值传入相应的ID即可。
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;																	 
			 						
18、产品库详情页-产品详情信息，关联案例列表信息 数据请求：ipadOcnProductDetailData【2014-12-16】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadOcnProductDetailData?userLoginId=shejs01&accessToken=0397N9sBxcB8aIh7Vm7-aC&ocnProductId=10740
				userLoginId【登录账号】
				accessToken【令牌】	
				ocnProductId【产品主键】
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;		
			
19、客户管理-新建客户-表单枚举数据请求：ipadCrmFormEnumerationData【2014-12-24】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmFormEnumerationData?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO
				userLoginId【登录账号】
				accessToken【令牌】	
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;

20、客户管理-新建客户-验证客户的手机号：ipadCrmValidateCustomerMobile【2015-03-17】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmValidateCustomerMobile?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO&mobile=
				userLoginId【登录账号】
				accessToken【令牌】	
				mobile【手机号】
说明：如果手机号不存在，则调用ipadCrmCreateCustomer，存在则调用ipadCrmUpdateCustomer
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;
			
21、客户管理-创建新客户：ipadCrmCreateCustomer【2015-03-17】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmCreateCustomer?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				customerName【姓名】【必输参数】
				mobile【手机号码】【必输参数】
				genderId【性别】
				qq【QQ号码】
				email【电子邮箱】
				customerAge【年龄】
				buildingName【楼盘名称】
				provinceId【省】
				cityId【市】
				areaId【区】
				address【地址】
				addressBuilding【楼/座】
				addressFloor【层】
				addressRoom【室】
				notes【备注】
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;
			( "20002", "输入参数错误") ;
			
22、客户管理-更新客户信息：ipadCrmUpdateCustomer【2015-03-17】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmUpdateCustomer?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				customerId【客户表主键】【必输参数】
				customerName【姓名】
				mobile【手机号码】
				genderId【性别】
				qq【QQ号码】
				email【电子邮箱】
				customerAge【年龄】
				provinceId【省】
				cityId【市】
				areaId【区】
				address【地址】
				addressBuilding【楼/座】
				addressFloor【层】
				addressRoom【室】
				notes【备注】
				
				recommendCustomerId【推荐人客户ID】
				recommendName【推荐人姓名】
				recommendMobile【推荐人手机号】
				typeId【客户类型】
				
说明：	根据推荐人输入的手机号，调用接口查询，如果存在客户，则客户ID值给参数recommendCustomerId赋值
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;			
			( "20002", "输入参数错误") ;
			
23、客户管理-加入购物车信息：ipadCrmCreateShoppingCartData【2015-03-23】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmCreateShoppingCartData?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO&customerId=&productId=
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				customerId【客户表主键】【必输参数】
				productId【产品表主键】【必输参数】
				
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;			
			( "20002", "输入参数错误") ;
			
24、客户管理-更新购物车信息：ipadCrmUpdateShoppingCartData【2015-03-23】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmUpdateShoppingCartData?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO&customerId=&updateDataJson=
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				customerId【客户表主键】【必输参数】
				updateDataJson【待更新数据串】【必输参数】
				
说明：	updateDataJson字符串格式如下：【购物车表主键，折率，产品数量】
			[{"shoppingCartId":"10240","discountRate":"86","productNumber":"4"},
				{"shoppingCartId":"10241","discountRate":"95","productNumber":"5"}
	      	]
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;			
			( "20002", "输入参数错误") ;	
			
25、客户管理-删除购物车信息：ipadCrmDeleteShoppingCartData【2015-03-23】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmDeleteShoppingCartData?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO&multiIdList=
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				multiIdList【购物车主键字符串】【必输参数】
				
说明：	multiIdList字符串格式如下：
			10240;10241;10240[分号隔开的字符串]
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;			
			( "20002", "输入参数错误") ;	
			
26、客户管理-获取购物车信息：ipadCrmGetShoppingCartData【2015-03-23】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmGetShoppingCartData?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO&customerId=
				serLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				customerId【客户表主键】【必输参数】
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;			
			
27、客户管理-新建客户-获取某客户信息：ipadCrmGetCustomer【2015-04-01】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmGetCustomer?userLoginId=shihuaitong&accessToken=3OeK2I9Sp6XHy5FMGNSZxm&customerId=1009010445
				userLoginId【登录账号】
				accessToken【令牌】	
				customerId【客户主键】【必输参数】
说明：
返回值：部分字段说明：
			
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;					
			
28、客户管理-获取购物车产品-加工数据：ipadCrmGetMachiningListData【2015-04-07】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmGetMachiningListData?userLoginId=shihuaitong&accessToken=3OeK2I9Sp6XHy5FMGNSZxm&customerId=1009010445
				userLoginId【登录账号】
				accessToken【令牌】	
				customerId【客户主键】【必输参数】
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;					
			
29、客户管理-购物车产品-创建加工数据：ipadCrmCreateMachiningData【2015-04-07】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmCreateMachiningData?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				customerId【客户主键】【必输参数】
				shoppingCartId【购物车ID】【必输参数】
				
				machiningNbr【待加工数量】
				moNumber【开数】【默认值为1】
				processes【工序】
				machinedName【加工后产品名称/规格】
				machinedNbr【加工后数量】【默认值等于待加工数量】
				machingUnit【加工单位】
				machingPrice【加工单价】【默认值为0】
				machingMoney【加工合计】【默认值为0】
				otherMoney【其他金额】【默认值为0】
				totalMoney【总金额】【默认值为0】
				description【描述】
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;
			( "20002", "输入参数错误") ;												

30、客户管理-购物车产品-更新加工数据：ipadCrmUpdateMachiningData【2015-04-07】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmUpdateMachiningData?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				customerId【客户主键】【必输参数】
				shoppingCartId【购物车ID】【必输参数】
				
				machiningNbr【待加工数量】
				moNumber【开数】【默认值为1】
				processes【工序】
				machinedName【加工后产品名称/规格】
				machinedNbr【加工后数量】【默认值等于待加工数量】
				machingUnit【加工单位】
				machingPrice【加工单价】【默认值为0】
				machingMoney【加工合计】【默认值为0】
				otherMoney【其他金额】【默认值为0】
				totalMoney【总金额】【默认值为0】
				description【描述】
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;
			( "20002", "输入参数错误") ;		
			
31、客户管理-购物车产品-删除加工数据：ipadCrmDeleteMachiningData【2015-04-07】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmDeleteMachiningData?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				machiningId【加工产品主键】【必输参数】
				
说明：单个删除
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;
			( "20002", "输入参数错误") ;		
				
32、客户管理-购物车里的某产品-加工数量信息：ipadCrmGetMachiningCountData【2015-04-07】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmGetMachiningCountData?userLoginId=shihuaitong&accessToken=3OeK2I9Sp6XHy5FMGNSZxm&customerId=1009010445
				userLoginId【登录账号】
				accessToken【令牌】	
				shoppingCartId【购物车主键】【必输参数】
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;					
			
33、客户管理-购物车产品-生成报价单数据：ipadCrmGenerateQuotationsData【2015-04-09】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmGenerateQuotationsData?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				customerId【客户ID】【必输参数】
				shopId【门店ID】【必输参数】
				discountRateT【产品折扣】【必输参数】【默认值100，单位%】
				dealPrice【成交价格】【必输参数】
				
说明：        discountedAmount【折后金额】
                machiningMoney【加工费用】
                subtotal【小计】
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;
			( "20002", "输入参数错误") ;		

34、客户管理-购物车产品-生成合同数据：ipadCrmGenerateContractData【2015-04-09】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmGenerateContractData?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				customerId【客户ID】【必输参数】
				shopId【门店ID】【必输参数】
				discountRateT【产品折扣】【必输参数】【默认值100，单位%】
				dealPrice【成交价格】【必输参数】
				
说明：        discountedAmount【折后金额】
                machiningMoney【加工费用】
                subtotal【小计】
                dealPrice【成交价格】
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;
			( "20002", "输入参数错误") ;
			
35、客户管理-生成新客户ID：ipadCrmGenerateCustomerId【2015-04-10】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmGenerateCustomerId?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
说明：		
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;
			( "20002", "输入参数错误") ;			
			
36、客户管理-合并客户：ipadCrmCombineCustomer【2015-04-10】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmCombineCustomer?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				newCustomerId【新接待客户创建的ID】【必输参数】
				existCustomerId【已存在客户的ID】【必输参数】
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;
			( "20002", "输入参数错误") ;
			
37、案例收藏，产品收藏等：ipadCustomerCollectGoods【2015-04-10】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCustomerCollectGoods?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				customerId【客户ID】【必输参数】
				collectType【类型】【必输参数】【值为Exhibition|OcnProduct】
				goodsId【物品ID】【必输参数】【案例或产品ID】
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;
			( "20002", "输入参数错误") ;		
			
38、客户管理-购物车产品-保存合同数据：ipadCrmCreateContractData【2015-04-10】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmCreateContractData?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				customerId【客户ID】【必输参数】
				quoteId【报价单ID】【必输参数】
				shippedOnDate【交付日期】【必输参数】【格式：2015-05-13】
				consignee【收货人】【必输参数】
				address【收货地址】【必输参数】
				phone【联系电话】
				dealPrice【成交价格】
				prepayments【预付款】
				pendingPayments【待付款】
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;
			( "20002", "输入参数错误") ;			
			
39、更新客户接待记录：ipadUpdateCustomerReceptionRecord【2015-04-29】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadUpdateCustomerReceptionRecord?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				customerId【客户ID】【必输参数】
				receptionType【类型】【必输参数】【值为Exhibition|OcnProduct】
				goodsId【物品ID】【必输参数】【案例或产品ID】
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;
			( "20002", "输入参数错误") ;		
			
40、查看客户接待记录：ipadViewCustomerReceptionRecord【2015-05-08】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadViewCustomerReceptionRecord?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				customerId【客户ID】【必输参数】
				receptionType【类型】【必输参数】【值为Exhibition|OcnProduct】
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;
			( "20002", "输入参数错误") ;			
			
41、客户完成接待：ipadCrmCompleteReception【2015-05-08】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmCompleteReception?userLoginId=shejs01&accessToken=3NKdCxDmZ5Lb4_PneyB5rO
				userLoginId【登录账号】【必输参数】
				accessToken【令牌】	【必输参数】
				customerId【客户ID】【必输参数】
				
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;
			( "10008", "用户会话过期") ;
			( "10011", "用户操作权限正常") ;
			( "20002", "输入参数错误") ;		
			
42、客户管理-获取该门店的所有客户：ipadCrmGetCustomerList【2015-05-14】
测试链接：http://crm.osnyun.com/rpcmanager/control/ipadCrmGetCustomerList?userLoginId=shihuaitong&accessToken=3OeK2I9Sp6XHy5FMGNSZxm
				userLoginId【登录账号】
				accessToken【令牌】	
				viewIndex【当前页数，默认从1开始】
				viewSize【每页记录数】
				queryValue【查询值，支持姓名和手机号查询】	
说明：
返回值：略
			( "10001", "用户不存在") ;
			( "10002", "用户密码错误") ;
			( "10003", "用户没有权限") ;
			( "10009", "用户令牌值错误") ;			
			( "10010", "用户查询权限正常") ;	


43、 查询所有IPAD换砖——U3D文件getIpadUthreeDFloors【2015-12-19】 add by huanghubing
         测试链接：http://crm.osnyun.com/rpcmanager/control/getIpadUthreeDFloors
         参数无：
         返回值：略	

            ( "10003", "查询成功") ;
			( "10004", "查询失败") ;
																			
44、根据二维码扫码链接查询产品ID
    测试链接：http://crm.osnyun.com/rpcmanager/control/ipadFindOcnProductIdByQrcodeUrl?qrcodeUrl=http://weixin.qq.com/q/TXVxGsjlJR9czOk8gFnP
    参数：qrcodeUrl 【二维码扫码链接】【必须】
    返回值：code: 0 失败 1 成功
           msg: err失败 success成功
           ocnProductId:产品ID