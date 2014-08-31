# JXAddressBook

JXAddressBook是一个获取手机通讯录信息的小组件, 它可以很方便的获取手机通讯录的所有信息.


## 如何使用JXAddressBook 


### 1. 准备工作

1. 将src中的文件导入项目
*  引入ABAddressBook.framework

### 2. 如何获取通讯录信息

**获取通讯录所有用户信息**

```
[JXAddressBook getPersonInfo:^(NSArray *personInfos) {
    for (JXPersonInfo *personInfo in personInfos) {
        NSLog(@"%@", personInfo);
    }
}];
```

**通过关键字匹配用户的信息**

```
[JXAddressBook searchPersonInfo:@"searchText" addressBookBlock:^(NSArray *personInfos) {
    for (JXPersonInfo *personInfo in personInfos) {
        NSLog(@"%@", personInfo);
    }
}];
```

**将搜索结果进行排序**

	+ (NSArray *)sortPersonInfos:(NSArray *)personInfos

可以将杂乱无章的通讯录信息进行排序, 返回的数组结构如下

* arr
	* subArr (一共26组子数据 元素类型为**`JXPersonInfo`**)


#### 3. 通讯录用户信息类 JXPersonInfo

JXPersonInfo为简单的模型类, 它可以获取通讯录用户的所有信息

|           字段      |   字段类型   |      字段介绍           |
|---------------------|------------|------------------------|
|     firstName      |   String    |      姓                | 
|     lastName       |	 String     |      名                | 
|     middlename     |	 String     |    中间名               |
|     fullname       |	 String     |     名字全称            |
|     firstSpell     |	 String     |     姓名首字母           |
|     prefix         |	 String     |     前缀                |
|     suffix         |	 String     |     后缀                |
|     nickname       |	 String     |     昵称                |
|  firstnamePhonetic |	 String     |     姓_音标             |
|  lastnamePhonetic  |	 String     |     名音标              |
|  middlenamePhonetic|	 String     |     中间名_音标          |
|    organization    |	 String     |     公司                |
|     jobtitle       |	 String     |     工作                |
|     department     |	 String     |     部门                |
|     birthday       |	 String     |     生日                |
|       note         |	 String     |     备忘                |
|     firstknow      |	 String     |   第一次创建通讯录时间     |
|     firstknow      |	 String     |   最后一次创建通讯录时间    |
|        kind        |	 String     |     类型                 |
|     	 email       |	Array[Dict] |     邮箱                 |
|     	 address     |	Array[Dict] |     地址                 |
|     	dates				|	Array[Dict] |     日期                 |
|     iMessage       |	Array[Dict] |   iMessage              |
|     	phone        |	Array[Dict] |   电话号码               |
|    		 url         |	Array[Dict] |    url链接               |
|     	image        |	 UIImage    |   设置头像               |

## Contact

**author:** Andy Jin  
**Email:** andy_ios@163.com

##Licenses

All source code is licensed under the [MIT License](https://github.com/andy0323/JXAddressBook/blob/master/LICENSE).

