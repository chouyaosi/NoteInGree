# SAMEX环境开发笔记

## API

>注：目前理解PaoField为物件栏对应的对象，Pao为物件对象

### 接口

#### PaoRemote接口

>父接口:Remote
>
>实现类:Pao,SimplePao,StatefulPao

##### get***

get方法获得Pao里属性值,例如`getString("name")`

##### PaoRemote getOwner()



##### setValue(String atrributeName, * value，long accessModifier)

设置指定属性`atrributeName`的值为对应类型的`value`

##### PaoSetRemote getPaoSet(String name/\*,String objectName,String relationWhere\*/)

从已注册的管理物件对象中获取关联的物件对象集合。 如果未找到，直接通过objectName获取，并设置为relationship. 获取的PAO set会通过relationWhere过滤。

##### PaoSetRemote getThisPaoSet()

获得自身对象的集合

#### PaoSetRemote接口

>父接口：Remote
>
>实现类：PaoSet,SimplePaoSet

##### Vector getSelection()

获取所勾选的记录

##### PaoRemote addAtEnd(//long accessModifier)

在物件对象集合末尾添加记录使用。  调用对应物件对象Pao的`init()`方法和`add()`方法

##### double max(String attributeName)

得到Pao集合中关于某个属性值得最大值

#### PaoConstants接口

>存储了常量字段值
>
>实现类：Pao,PaoSet,StatefulPao,PaoField,SimplePao,SimplePaoSet

| p2.pao.[PaoConstants](p2/pao/PaoConstants.html) |                                          |            |
| ----------------------------------------------- | ---------------------------------------- | ---------- |
| `public static final int`                       | `ALLROWS`                                | `10000000` |
| `public static final long`                      | `CHANGEDBY_USER`                         | `16L`      |
| `public static final int`                       | `COUNT_ADDITIONS`                        | `2`        |
| `public static final int`                       | `COUNT_AFTERSAVE`                        | `16`       |
| `public static final int`                       | `COUNT_DATABASE`                         | `1`        |
| `public static final int`                       | `COUNT_DELETED`                          | `4`        |
| `public static final int`                       | `COUNT_EXISTING`                         | `8`        |
| `public static final long`                      | `DELAYVALIDATION`                        | `4L`       |
| `public static final long`                      | `DISCARDABLE`                            | `39L`      |
| `public static final long`                      | `NO_RELATEDPAOS_OF_OWNERSCHILDREN_FETCH` | `16L`      |
| `public static final long`                      | `NOACCESSCHECK`                          | `2L`       |
| `public static final long`                      | `NOACTION`                               | `8L`       |
| `public static final long`                      | `NOADD`                                  | `1L`       |
| `public static final long`                      | `NOCOMMIT`                               | `2L`       |
| `public static final long`                      | `NODELETE`                               | `4L`       |
| `public static final long`                      | `NONE`                                   | `0L`       |
| `public static final long`                      | `NOSAVE`                                 | `8L`       |
| `public static final long`                      | `NOSETVALUE`                             | `32L`      |
| `public static final long`                      | `NOUPDATE`                               | `2L`       |
| `public static final long`                      | `NOVALIDATION`                           | `1L`       |
| `public static final long`                      | `NOVALIDATION_AND_NOACTION`              | `9L`       |
| `public static final long`                      | `READONLY`                               | `7L`       |
| `public static final long`                      | `REBUILD`                                | `1L`       |
| `public static final long`                      | `REQUIRED`                               | `8L`       |
| `public static final long`                      | `SAMEVALUEVALIDATION`                    | `16L`      |
| `public static final long`                      | `USER`                                   | `256L`     |

#### PaoFieldListener接口

>实现类：PaoFieldAdapter

##### void action()

PaoField验证完毕后的默认处理

#### PaoServer接口



---

### 类

#### PaoSet类

>实现:PaoSetRemote接口
>
>子类:SimplePaoSet

##### PaoRemote getOwner()

获得现在集合的owner Pao（理解为主表的PaoRemote）

##### PaoRemote getPao(int index)

获得指定索引的PaoRemote或者无参获得现在的PaoRemote

##### void setWhere(String where)

设定过滤条件

#### PaoFieldAdapter类

> 实现接口：PaoConstants,PaoFieldListener

##### public PaoField  getPaoField()

获得当前物件栏对象

####  PaoField类

> 实现接口:PaoConstants，PaoAccessInterface

##### public Pao getPao()

获得当前物件栏对象属于的Pao对象(物件对象)

##### public get***()

获得当前值，例如 getInt()。

public boolean isNull()

检查当前对象是否有Null值

---

### 绑定数据源的4种方式

#### 1.等同物件栏

例如使用等同物件栏，在数据库管理中将PRODUCT物件的SITEID栏等同SITE的对应栏，在关系中设定siteid=:siteid，此时JAVA类自动加载SITEID绑定的类。在应用设计SITEID栏为文本组合框，设定查找SITE

#### 2. 自定义动态绑定

1. 设置动态绑定，名为SUPERVISOR，绑定物件PP_HR，过滤条件"title='单位领导' and siteid=:siteid"，设定绑定物件栏的映射，displayname<--->supervisordesc；hrid<--->supervisor
2. 数据库管理中，物件栏设定数据绑定名称SUPERVISOR
3. 应用设计中，使用文本框查找SUPERVISOR、

#### 3. 代码设置

1. 新建JAVA类，设置外表链接PP_HR，字段映射，过滤条件
3. 数据库管理中，物件栏设置中，SUPERVISOR2DESC栏位设定JAVA类
4. 应用设计中，使用文本框查找PP_HR

#### 4. 使用自带动态绑定

1. 数据库管理中，PRODUCER设定数据绑定PP_HR
2. 与表PP_HR建立关系，hrid=:producer
3. 应用组合文本框查找PP_HR，物件栏2设定PP_HR.displayname

#### 5.静态绑定



### API调用过程

#### 状态更改

##### 当应用添加了更改状态的权限，点击更改状态有一下调用：

1. 调用`getStatusHandler()` 方法内返回一个`StatusHandler`实例

2. 再点击确定更改状态后，调用`changeStatus()`

3. 调用`getStatusHistory()` ，方法返回一个`历史表` 实例，历史表用于存储状态历史，更改状态时间等。    //系统默认有StatusHistory历史表，可不用自己创建历史表和对应类

4. 调用历史表`add()`方法，增加历史状态

   

##### 点击了查看历史

调用`getStatusHistory()`，有多少条历史状态记录调用多少次，利用`getPaoSet("历史表")`返回所在历史表Set。



### 一些API的调用结果

#### UserInfo和SystemUserInfo的get***方法

```java
//        String userName = P2Server.getP2Server().getSystemUserInfo().getUserName();   //P2ADMIN
//        String userId = P2Server.getP2Server().getSystemUserInfo().getHRID();         //P2ADMIN
//        String siteId = P2Server.getP2Server().getSystemUserInfo().getInsertSite();   //GREE

//        UserInfo userInfo = getUserInfo();
//        String userName =  userInfo.getUserName();               //SAMADMIN
//        String hrid = userInfo.getHRID();                        //SAMADMIN
//        String loginId = userInfo.getLoginID();                  //samadmin
//        String displayName = userInfo.getDisplayName();          //系统角色
//        String insertSite = userInfo.getInsertSite();            //0234
```





## Birt报表插件使用

## 数据绑定

### 配置数据源

配置数据源，添加数据库驱动jar包。sqlserver为`sqljdbc41.jar` 。驱动名有下拉框可选，为`com.microsoft.sqlserver.jdbc.SQLServerDriver (v6.0)`。链接字串为`jdbc:sqlserver://[host]:[port];databaseName=数据库名` 。点解`TestConnection`测试连接成功。

### 绑定数据集

点击<kbd>Data Sets</kbd> ,右键新建<kbd>Data Set</kbd>。书写SQL语句，点击<kbd>Preview Results</kbd>可以查看从数据库返回的数据记录。

### 编写过滤参数

1. 右键<kbd>Report Parameter</kbd>新建过滤参数，配置参数名和提示信息。
2. 编写script，在`beforeOpen`时的过滤SQL。

### 设置界面Layout和标题Master Page



