# JAVA

## Servlet

> Servlet本身不能独立运行，需要在web应用中运行，而一个web应用需要部署在tomcat中。

### 调用流程

1. 当有一个请求例如`http://127.0.0.1/hello`或者`http://127.0.0.1/login.html`页面时，因请求的是本地服务器地址，Tomcat根据本地`tomcat/conf/server.xml`文件里配置的内容`<Context path="/" docBase="e:\\project\\j2ee\\web"...`查找资源。

2. 提交`http://127.0.0.1/hello`请求时，路径为`/hello`，查找`web/WEB-INF/`下的`web.xml`配置寻找对应的Servlet类，调用`doGet`方法；

3. 请求静态页面`http://127.0.0.1/login.html`时，按上述路径需找资源文件，当提交表单`<form action="login" method="post">`时，表单中的数据被提交到`/login`路径，并附带method="post"。

4. tomcat接收到新的请求`http://127.0.0.1/login`，路径为`/login`，接着如hello请求的步骤2，查找对应Servlet类。

5. 定位Servlet后，没有实例存在就会调用Servlet的无参构造函数实例化对象，接着调用`doPost()`方法处理表单传入的数据，request对象可接收数据，response对象可响应数据，例如`response.getWriter().println(html)`。至此Servlet工作完成

6. tomcat拿到被修改过的response，根据response生成的html字符串，通过http协议回发给浏览器，浏览器再根据http协议获取这个字符串并渲染在界面上。

   ### 生命周期

   实例化——>初始化——>提供服务——>销毁——>被回收

   无参构造    init()  service(),doGet(),doPost   destroy()   

   > 无参构造方法和init()只会执行一次，Servlet为单实例.

### 提交数据方式

#### get

1. form表单默认提交方式
2. ajax指定使用get方式
3. 地址栏直接输入某个地址
4. 通过超链访问地址

#### post

1. form表单显示制定method="post"
2. ajax指定post方式

### 跳转方式

1. 服务端跳转：`request.getRequestDispatcher("success.html").forward(request, response);`
2. 客户端跳转：` response.sendRedirect("fail.html");`

![JAVA1.png](C:\Users\180559\Desktop\note\java\JAVA1.png"Servlet跳转")

### 自启动

`web.xml`中在servlet标签中添加`<load-on-startup>`标签

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app>
    <servlet>
        <servlet-name>HelloServlet</servlet-name>
        <servlet-class>HelloServlet</servlet-class>
        <load-on-startup>10</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>HelloServlet</servlet-name>
        <url-pattern>/hello</url-pattern>
    </servlet-mapping>
     
    <servlet>
        <servlet-name>LoginServlet</servlet-name>
        <servlet-class>LoginServlet</servlet-class>
    </servlet>
 
    <servlet-mapping>
        <servlet-name>LoginServlet</servlet-name>
        <url-pattern>/login</url-pattern>
    </servlet-mapping>   
</web-app>
```

`<load-on-startup>10</load-on-startup>`取值1-99，数字越小优先级越高。表示Servlet随Tomcat的启动而初始化。

## JSP

### 执行过程

![](C:\Users\180559\Desktop\note\java\JAVA_JSP_1.png"ha")

1. 把 hello.jsp转译为hello_jsp.java
2. hello_jsp.java 位于
\tomcat\work\Catalina\localhost\_\org\apache\jsp
3. hello_jsp.java是一个servlet
4. 把hello_jsp.java 编译为hello_jsp.class
5. 执行hello_jsp，生成html
6. 通过http协议把html 响应返回给浏览器

### 页面元素

1. 静态内容：html、css、javascript
2. 指令：以`<%@`开始`%>`结尾的元素
3. 表达式：`<%=   %>`
4. Java代码：`<%    %>`
5. 动作：`<jsp:include page="FileName">`
6. 注释：`<%-- --%>`不同于html注释`<!-- -->`，通过jsp的注释，浏览器也看不到相应的代码
7. 声明：`<%!   %>`之间可以声明字段或者方法，但不建议这么做

### include两种方式

1. 指令include：`<%@include file="***.jsp"%>`
2. 动作include：`<jsp:include page="***.jsp"/>`

区别：指令include会将被包含的jsp文件内容插入到转译的java文件中，只会生成一个java文件。动作include不会将jsp文件内容插入其中，但会转译成另一个Servlet，在服务端原来的Servlet会访问该Servlet

### Cookie

> 一种浏览器与服务器交互数据的方式，Cookie由服务器创建但不会保存在服务器上。创建好后发送给浏览器保存在本地。

### Session

> 会话从用户打开浏览器访问一个网站开始，无论在网站中访问了多少页面，都属于同一个会话，直到用户关闭浏览器为止。

#### 健身房的储物柜

>   考虑这个场景：
> 李佳汜到健身房去练胸肌，**首先领了钥匙**，然后进了更衣间，把衣服，裤子，手机，钱包都放在盒子里面。
>
> 毛竞也到健身房，去练**翘臀**。**首先领了钥匙**，然后 进了更衣间，把衣服，裤子，手机，《Java 21天从入门到精通》也放在了一个盒子里，但是这个盒子是和李佳汜的是不同的。
>
> 健身房，就相当于服务器，盒子，就是会话Session。

### 作用域

1. pageContext：当前页面作用域
2. requestContext：一次请求，随着本次请求结束就被回收
3. sessionContext：会话作用域，不同用户对应不同session。不同用户不能共享数据
4. applicationContext：全局作用域，所有用户共享数据

## JAVA API

### java.sql包

#### ResultSet类   基1 

##### ResultSetMetaData getMetaData()

>  得到结果集的结构信息，比如字段数、字段名等。

```java
ResultSetMetaData rsmd=rs.getMetaData();
rs.getMetaData().getTableName(1));  //就可以返回表名
rs.getMetaData().getColumnCount();  //字段数
rs.getMetaData().getColumnName(i));  //字段名
```

#### Object类

##### hashCode()方法

HashCode()方法默认行为是对在heap上的对象产生独特值，如果没被override，则一个类的两个对象怎样都不会返回相同的hashcode值。

##### equals()方法

equals()默认行为是执行"=="比较，也就是测试两个引用是否指向heap上同一个对象，如果没被覆盖同上。



## MVC

<kbd>view</kbd> `视图层`界面部分，用户唯一可以看到的一层，接收用户的输出，显示处理的结果

<kbd>control</kbd> `控制层` 控制用户界面数据的显示，响应用户出发的事件，交给model层处理

<kbd>model</kbd> `业务层`对数据库，网络的操作，业务计算 





## 网络

1. TCP端口是一个16位宽，用来识别服务器上特定程序的数字，0~1023的TCP端口号保留给特定服务使用，不同程序不能共享一个端口，否则会收到BindException异常

## 线程

> 线程是独立的执行空间

1. 同步锁：对象就算有多个同步化方法也还是只有一个锁，一旦某个线程进入该对象中的其中一个同步化方法，那么其他线程就无法进入该对象中的任何同步化方法

### 同步与异步

> 同步：如果数据在线程间共享，一个线程正在写的数据可能被另一个读到或正在读的数据被另一个程序写过，就必须使用同步。
>
> 异步：如果程序调用了一个需要执行时间很长的程序，且不希望等待方法的返回时，使用异步

## 集合

##### Collection.sort()方法

```java
public static <T extends Comparable<? super T>> void sort(List<T>list)
   //T实现Comparable接口的compareTo(T t)方法
public static void sort(List<T>list,Comparator<? super T>c)
    //传入实现Comparator接口compare()方法的对象
```

#### HashSet检查重复

先比较两对象的hashcode，如果相异则认为是不同对象；在hashcode相同情况，会调用其中一个的equals()方法来检查是否相同。

