>  SSM(H)开发过程中，需要做大量的配置工作，很多配置行为本身只是手段并不是目的，基于这个考虑，把该简化的简化，该省略的省略，开发人员只关心提供业务功能就行了，这就是springboot。换言之，Springboot可以简单地看成简化了的、按照约定开发的SSM(H)。其本质上是一个 Java 应用程序。

# Springboot入门

## Web应用

### 创建应用

#### 1. 创建工程

##### (1)new Project

如图选项创建，但是需要联网环境。

![](C:\Users\180559\Desktop\note\springboot\springboot1.png"创建springboot的Web工程")

##### (2)项目参数

指定项目Group和Artifact

![](C:\Users\180559\Desktop\note\springboot\springboot2.png)

##### (3) 选择Web模块

创建Web工程，选择Web模块

![](C:\Users\180559\Desktop\note\springboot\springboot3.png)

##### (4) 指定项目路径

此项目指定为`E:\project\springboot` 。项目创建成功，项目结构如下。

![](C:\Users\180559\Desktop\note\springboot\springboot4.png)

#### 2. SpringbootApplication.java

项目创建好，就自带一个SpringbootApplication，其被`@SpringbootApplication`标记，表示是一个Springboot应用。

![](C:\Users\180559\Desktop\note\springboot\springboot5.png)

#### 3. HelloController.java

新建包com.how2java.springboot.web，在其下新建类HelloController.java。这个类就是SpringMVC里的一个普通的控制器。@RestController是Spring4里的新注解，是@ResponseBody和@Controller的缩写。

```java
package com.how2java.springboot.web;

@RestController
public class HelloController {
    @RequestMapping("/hello")
    public String hello() {
        return "Hello Spring Boot!";
    }
}
```

#### 4. 运行并测试

运行SpringbootApplication.java，然后访问地址`http://127.0.0.1:8080/hello`,效果如下

![](C:\Users\180559\Desktop\note\springboot\springboot6.png)



### 两种部署

#### 1. jar部署

在cmd命令行下切换到springboot项目根目录下，执行mvn install。在项目target文件夹下会生成一个\*-0.0.1-SNAPSHOT.jar文件。接着输入 java -jar target/\*-0.0.1-SNAPSHOT.jar
就启动了jar，这样此jar会上传到服务器达到部署效果

#### 2.war部署

##### (1)改变Application类

在Application类前添加@ServletComponentScan注解，并继承SpringBootServletInitializer

##### (2)修改pom.xml

1. 增加`<packaging>war</packaging>`;
2. spring-boot-starter-tomcat修改为provided方式，即增加<scope>provided</scope>避免和独立tomcat容器冲突，provided表示只在编译和测试时候使用，打包时就没它了(这个它是指tomcat容器吗？)
##### (3)创建war包

cmd命令行切换到项目根目录执行mvn clean package。会在target文件夹下生成\*-0.0.1-SNAPSHOT.war

#####  (4)重命名war包部署:

如果用\*-0.0.1-SNAPSHOT.war，访问的时候就要加上路径 \*-0.0.1-SNAPSHOT。所以把文件重命名ROOT.war，并把其放到tomcat的webapps目录下，部署成功

#####   (5)启动tomcat并访问:

运行`startup.bat`，访问`http://localhost:8080/hello`

### Springboot与JSP

>  Springboot的默认视图支持是Thymeleaf，Springboot支持JSP的方式

#### 1. 添加依赖

```xml
	<dependency>              
            <groupId>org.springframework.boot</groupId>        
            <artifactId>spring-boot-starter-tomcat</artifactId>  
    </dependency>
	<!-- servlet依赖. -->
    <dependency>
          <groupId>javax.servlet</groupId>
          <artifactId>javax.servlet-api</artifactId>  
    </dependency>
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>jstl</artifactId>
    </dependency>             
    <!-- tomcat的支持.-->                                 
    <dependency>                       <!-- 这个依赖没有就不行-->
           <groupId>org.apache.tomcat.embed</groupId> 
           <artifactId>tomcat-embed-jasper</artifactId>
    </dependency> 
            
```

#### 2. application.properties

在src/main/resources目录下增加 application.properties文件，用于视图重定向jsp文件的位置

```properties
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp
```

#### 3. HelloController

在application.java同级创建web目录，其中创建HelloController.java。把本来的@RestController 改为@Controller。这时返回"hello"就不再是字符串，而是根据application.properties 中的视图重定向，到/WEB-INF/jsp目录下去寻找hello.jsp文件

```java
@Controller
public class HelloController {
    @RequestMapping("/hello")
    public String hello(Model m) {
        m.addAttribute("now", DateFormat.getDateTimeInstance().format(new Date()));
        return "hello";
    }
}
```

#### 4. hello.jsp

main目录下，新建->webapp/WEB-INF/jsp目录，新建hello.jsp。其中使用EL表达式显示放在HelloController的model中的当前时间

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
Hi JSP. 现在时间是  ${now}
```

#### 5. 启动测试

`http://127.0.0.1:8080/hello`

![](C:\Users\180559\Desktop\note\springboot\springboot9.png)

### springboot热部署

Springboot提供了热部署的方式，当发现任何类发生了改变，马上通过JVM类加载的方式，加载最新的类到虚拟机中。 这样就不需要重新启动也能看到修改后的效果了
一步到位：在pom.xml中增加一个依赖和插件

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <optional>true</optional> <!-- 这个需要为 true 热部署才有效 -->
</dependency>
<plugin>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-maven-plugin</artifactId>
</plugin>
```

### SpringBoot异常处理

#### 1. 修改HelloController

修改HelloController，是的访问`/hello`一定会产生异常: some exception

```java
package com.how2java.springboot.web;
import java.text.DateFormat;
import java.util.Date;
 
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
  
@Controller
public class HelloController {
  
    @RequestMapping("/hello")
    public String hello(Model m) throws Exception {
        m.addAttribute("now", DateFormat.getDateTimeInstance().format(new Date()));
        if(true){
            throw new Exception("some exception");
        }
        return "hello";
    }    
}
```

#### 2. GlobalExceptionHandler

新增GlobalExceptionHandler，用于捕捉Exception异常及其自类。捕捉到异常之后，将异常信息放进ModelAndView里，然后跳转到errorPage.jsp

```java
package com.how2java.springboot.exception;
 
import javax.servlet.http.HttpServletRequest;
 
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
 
@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(value = Exception.class)
    public ModelAndView defaultErrorHandler(HttpServletRequest req, Exception e) throws Exception {
        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", e);
        mav.addObject("url", req.getRequestURL());
        mav.setViewName("errorPage");
        return mav;
    }
}
```

#### 3. errorPage.jsp

格式化一下，稍微好看点。

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<div style="width:500px;border:1px solid lightgray;margin:200px auto;padding:80px">
 
系统 出现了异常，异常原因是：
    ${exception}
    <br><br>
    出现异常的地址是：
    ${url}
    </div>
    
```

#### 4. 重启测试

`http://127.0.0.1:8080/hello`

![](C:\Users\180559\Desktop\note\springboot\springboot7.png)

### Springboot配置文件

#### 1. application.properties

通过修改`application.properties`，可以修改访问的端口号和上下文路径。

```properties
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp
server.port=8888
server.context-path=/test
```

##### 配置切换

有时候本地测试使用8080端口，上线使用的又是80端口。此时就可以通过多配置文件实现配置切换

3个配置文件：

1. 核心配置文件：application.properties
2. 开发环境用的配置文件：application-dev.properties
3. 生产环境用的配置文件：application-pro.properties

这样就可以通过application.properties里的spring.profiles.active灵活地切换使用哪个环境了

```properties
#application.properties
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp
spring.profiles.active=pro
#application-dev.properties
server.port=8080
server.context-path=/test
#application-pro.properties
server.port=80
server.context-path=/
```

##### 部署

不仅可以通过application.properties文件进行切换，还可以在部署时，指定不同参数来选定自己想要的配置。

`java -jar target/springboot-0.0.1-SNAPSHOT-SNAPSHOT.jar --spring.profiles.active=pro`

或者

`java -jar target/springboot-0.0.1-SNAPSHOT.jar --spring.profiles.active=dev`

#### 2. yml格式

左边application.properties写法，右边application.yml写法。效果相同

![](C:\Users\180559\Desktop\note\springboot\springboot8.png)

书写注意：

1. 不同“等级”用冒号隔开
2. 次等级的前面是空格，*不能使用tab*
3. 冒号之后如果有值，那么冒号和值之间至少有一个空格，**不能紧贴着**

这样的配置下，访问路径是：

`http://127.0.0.1:8888/test/hello`

## JPA

> JPA(Java Persistence API)是Sun官方提出的Java持久化规范，用来方便大家操作数据库。
> 真正干活的可能是Hibernate,TopLink等等实现了JPA规范的不同厂商,默认是Hibernate。

### Springboot中的JPA应用

#### 1. 数据库

```mysql
create database how2java;
use how2java;
CREATE TABLE category_ (
  id int(11) AUTO_INCREMENT,
  name varchar(30),
  PRIMARY KEY (id)
) DEFAULT CHARSET=UTF8;

insert into category_ values(null,'category 1');
insert into category_ values(null,'category 2');
insert into category_ values(null,'category 3');
insert into category_ values(null,'category 4');
```

#### 2. application.properties

```properties
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp
spring.datasource.url=jdbc:mysql://127.0.0.1:3306/how2java?characterEncoding=UTF-8
spring.datasource.username=root
spring.datasource.password=admin
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.jpa.properties.hibernate.hbm2ddl.auto=update
```

`spring.jpa.properties.hibernate.hbm2ddl.auto=update`表示会自动更新表结构，所以创建表这一步其实是可以不需要的~

#### 3. pom.xml

```xml-dtd
        <!-- mysql-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.21</version>
        </dependency>
 
        <!-- jpa-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency> 
```

#### 4. pojo

增加一个包：com.how2java.springboot.pojo，创建实体类Category。一下省略setter和getter函数

@Entity 注解表示这是个实体类

@Table(name = "category\_") 表示这个类对应的表名是 category\_ ，注意有下划线哦

@Id 表明主键

@GeneratedValue(strategy = GenerationType.IDENTITY) 表明自增长方式

@Column(name = "id") 表明对应的数据库字段名

```java
package com.how2java.springboot.pojo;
 
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
 
@Entity
@Table(name = "category_")
public class Category {
 
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;
     
    @Column(name = "name")
    private String name;
}
```

#### 5. DAO

增加包：com.how2java.springboot.dao，创建接口CategoryDAO,继承JpaRepository，提供泛型<Category,Integer>表示这个是针对Category类的DAO，Integer表示主键是Integer。JpaRepository这个父接口提供了CRUD，分页一系列操作，不需要二次开发

```java
package com.how2java.springboot.dao;
 
import org.springframework.data.jpa.repository.JpaRepository;
import com.how2java.springboot.pojo.Category;
 
public interface CategoryDAO extends JpaRepository<Category,Integer>{
 
}
```

#### 6. CategoryController

增加包：com.how2java.springboot.web，创建类CategoryController类。

1. 接收listCategory映射
2. 然后获取所有分类数据
3. 接着放入Modelzhong 
4. 跳转到listCategory.jsp中

```java
package com.how2java.springboot.web;
import java.util.List;
 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import com.how2java.springboot.dao.CategoryDAO;
import com.how2java.springboot.pojo.Category;
  
@Controller
public class CategoryController {
    @Autowired CategoryDAO categoryDAO;
     
    @RequestMapping("/listCategory")
    public String listCategory(Model m) throws Exception {
        List<Category> cs=categoryDAO.findAll();
         
        m.addAttribute("cs", cs);
         
        return "listCategory";
    }
}
```

#### 7. listCategory.jsp

用jstl遍历从CategoryController传递过来的集合：cs

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
   
<table align='center' border='1' cellspacing='0'>
    <tr>
        <td>id</td>
        <td>name</td>
    </tr>
    <c:forEach items="${cs}" var="c" varStatus="st">
        <tr>
            <td>${c.id}</td>
            <td>${c.name}</td>      
        </tr>
    </c:forEach>
</table>
```

#### 8. 重启测试

`http://127.0.0.1:8080/listCateogry`

![](C:\Users\180559\Desktop\note\springboot\springboot10.png)

## MyBatis

> 在springboot中进行Mybatis配置更加简便，并且Mybatis的两种映射方式在springboot中都将通过Mapper来操作。、

数据库

```sql
create database how2java;
use how2java;
CREATE TABLE category_ (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(30),
  PRIMARY KEY (id)
) DEFAULT CHARSET=UTF8;
insert into category_ values(null,'category 1');
insert into category_ values(null,'category 2');
insert into category_ values(null,'category 3');
insert into category_ values(null,'category 4');
```

### 注解方式

#### 1. application.properties

```properties
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp
spring.datasource.url=jdbc:mysql://127.0.0.1:3306/how2java?characterEncoding=UTF-8
spring.datasource.username=root
spring.datasource.password=admin
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
```

#### 2. pom.xml

增加对Mysql和Mybatis的支持

```xml-dtd
<!-- mybatis -->
<dependency>
	<groupId>org.mybatis.spring.boot</groupId>
	<artifactId>mybatis-spring-boot-starter</artifactId>
	<version>1.1.1</version>
</dependency>
<!-- mysql -->
<dependency>
	<groupId>mysql</groupId>
	<artifactId>mysql-connector-java</artifactId>
	<version>5.1.21</version>
</dependency>
```

#### 3. pojo

增加包：com.how2java.springboot.pojo，创建实体类Category

```java
package com.how2java.springboot.pojo;
 
public class Category {
  
    private int id;
    private String name;
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }      
}
```

#### 4. Mapper

增加一个包：com.how2java.springboot.mapper，创建接口CategoryMapper。

注解@Mapper表示这是一个Mybatis Mapper接口；

使用@Select注解表示调用findAll方法会去执行对应的sql语句。

```java
package com.how2java.springboot.mapper;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import com.how2java.springboot.pojo.Category;
 
@Mapper
public interface CategoryMapper {

    @Select("select * from category_ ")
    List<Category> findAll();
}
```

#### 5. Controller

增加包：com.how2java.springboot.web，创建CategoryController类。

1. 接收listCategory映射
2. 然后获取所有的分类数据
3. 接着放入Model中
4. 跳转到listCategory.jsp中

```java
package com.how2java.springboot.web;
import java.util.List;
 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import com.how2java.springboot.mapper.CategoryMapper;
import com.how2java.springboot.pojo.Category;
   
@Controller
public class CategoryController {
    @Autowired CategoryMapper categoryMapper;
    
    @RequestMapping("/listCategory")
    public String listCategory(Model m) throws Exception {
        List<Category> cs=categoryMapper.findAll();
          
        m.addAttribute("cs", cs);
          
        return "listCategory";
    }    
}
```

#### 6. listCategory.jsp

用jstl便利CategoryController传递过来的集合：cs

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
   
<table align='center' border='1' cellspacing='0'>
    <tr>
        <td>id</td>
        <td>name</td>
    </tr>
    <c:forEach items="${cs}" var="c" varStatus="st">
        <tr>
            <td>${c.id}</td>
            <td>${c.name}</td>             
        </tr>
    </c:forEach>
</table>
```

#### 7. 重启测试

`http://127.0.0.1:8080/listCategory`



### XML方式

与注解方式大同小异，需要改几处配置，但都用Mapper映射操作。

#### 1.application.properties

修改application.properties指明从哪里去找xml配置文件

```properties
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp
spring.datasource.url=jdbc:mysql://127.0.0.1:3306/how2java?characterEncoding=UTF-8
spring.datasource.username=root
spring.datasource.password=admin
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
 
mybatis.mapper-locations=classpath:com/how2java/springboot/mapper/*.xml
mybatis.type-aliases-package=com.how2java.springboot.pojo
```

#### 2. Mapper

去掉了sql语句注解

```java
package com.how2java.springboot.mapper;
 
import java.util.List;
 
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
 
import com.how2java.springboot.pojo.Category;
 
@Mapper
public interface CategoryMapper {
 
   List<Category> findAll();
}
```

#### 3. Category.xml

Mapper类旁增加Category.xml，放置SQL语句

```xml-dtd
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
    PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
  
    <mapper namespace="com.how2java.springboot.mapper.CategoryMapper">
        <select id="findAll" resultType="Category">
            select * from category_
        </select>   
    </mapper>
```

#### 4. pom.xml

how2j站长的代码出问题，Category.xml没有编译到target中。解决办法，修改pom.xml配置，让编译器把`src/main/java`目录下的xml文件一同编译。

```xml-dtd
<!--添加在pom.xml build节点下-->
<resources>
            <resource>
                <directory>src/main/java</directory>
                <includes>
                    <include>**/*.xml</include>
                </includes>
            </resource>
</resources>

```

#### 5. 重启测试

`http://127.0.0.1:8080/listCategory`

## Thymeleaf

> thymeleaf 跟 JSP 一样，就是运行之后，就得到纯 HTML了。 区别在与，运行之前， thymeleaf 也是 纯 html ...
> 所以 thymeleaf 不需要 服务端的支持，就能够被以 html 的方式打开，这样就方便前端人员独立设计与调试, jsp 就不行了， 不启动服务器 jsp 都没法运行出结果来。

### Web—Hello页面

> Thymeleaf可以配合Servlet运行，常见配合springboot运行，不过本质上还是配合springboot里的springmvc来运行的，springboot像个老鸨，干活的还是springmvc。

#### 1. pom.xml

```xml
<!-- 增加thymeleaf的支持-->
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-thymeleaf</artifactId>	
</dependency>
```

#### 2. application.properties

```properties
#thymeleaf 配置
spring.thymeleaf.mode=HTML5
spring.thymeleaf.encoding=UTF-8
spring.thymeleaf.servlet.content-type=text/html
#缓存设置为false, 这样修改之后马上生效，便于调试
spring.thymeleaf.cache=false
#上下文
server.servlet.context-path=/thymeleaf
```

#### 3. Controller

```java
package com.how2java.springboot.web;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
 
@Controller
public class HelloController {
    //访问地址hello，跳转到hello.html，并带上数据"name"，其值是"thymeleaf"
    @RequestMapping("/hello")
    public String hello(Model m) {
        m.addAttribute("name", "thymeleaf");
        return "hello";
    }
}
```

#### 4. hello.html

在resources目录下新建目录templates，然后新建文件hello.html。

```html
<!DOCTYPE HTML>
<！-- 声明当前文件是thymeleaf，之后可以用th开头属性 -->
<html xmlns:th="http://www.thymeleaf.org">

<head>
    <title>hello</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
<!--用th:text属性，将"name"里的值放在p标签里，${name}这种写法叫ognl，跟EL表达式一样。取出的值将p标签里的值覆盖-->  
<p th:text="${name}" >name</p>
<!--字符串拼写的两种方式-->
<p th:text="'Hello！ ' + ${name} + '!'" >hello world</p>
<p th:text="|Hello！ ${name}!|" >hello world</p>
</body>
 
</html>
```

用这种方式，就可以把服务端的数据，显示在当前html里了。 **重要的是：** 这种写法是完全合法的 html 语法，所以可以直接通过浏览器打开 hello.html,也是可以看到效果的， 只不过看到的是 "name", 而不是 服务端传过来的值 "thymeleaf"。

#### 5. 测试

运行Application.java，访问地址`http://127.0.0.1:8080/thymeleaf/hello`

### URL

![](C:\Users\180559\Desktop\note\springboot\springboot11.png)

如图，对话框和灰色边框效果通过@URL外部引用css和Js文件得到

#### 1. css文件

![](C:\Users\180559\Desktop\note\springboot\springboot13.png)

目录结构java/webapp/static/css/style.css

```css
div.showing{
    width:80%;
    margin:20px auto;
    border:1px solid grey;
    padding:30px;
}
```

#### 2. js文件

目录结构java/webapp/static/js/thymeleaf.js

```js
function testFunction(){
    alert("test Thymeleaf.js!");
}
```

#### 3. 修改hello.html

通过`th:href="@{/static/css/style.css}"`和`th:src="@{/static/js/thymeleaf.js}"`引入css和js文件

**注意**：

1. 使用@这种方式引入，在渲染后的html里会自动生成上下文路径，即如图所示的/thymeleaf这个路径![](C:\Users\180559\Desktop\note\springboot\springboot12.png)
2. 如果使用浏览器直接打开templates文件夹里的hello.html，依然可以看到css和js效果，因为href和src标签作用。所以这样可以方便前端开发测试。

```html
<!DOCTYPE HTML>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>hello</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" type="text/css" media="all" href="../../webapp/static/css/style.css" th:href="@{/static/css/style.css}"/>
    <script type="text/javascript" src="../../webapp/static/js/thymeleaf.js" th:src="@{/static/js/thymeleaf.js}"></script>


    <script>
        testFunction();
    </script>
</head>
<body>
<div class="showing">
<p th:text="${name}" >name</p>
<p th:text="'Hello！ ' + ${name} + '!'" >hello world</p>
<p th:text="|Hello！ ${name}!|" >hello world</p>
</div>
</body>

</html>

```

#### 4. 重启测试

重启Application，访问`http://127.0.0.1:8080/thymeleaf/hello`

### 表达式

#### 1. pojo

*以下省略setter和getter函数*

```java
package com.how2java.springboot.pojo;
 
public class Product {
    private int id;
    private String name;
    private int price;   
}
```

#### 2. Controller

控制器里准备数据，映射/test路径，返回到test.html中。

```java
package com.how2java.springboot.web;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping; 
import com.how2java.springboot.pojo.Product;
  
@Controller
public class TestController {
  
    @RequestMapping("/test")
    public String test(Model m) {
        String htmlContent = "<p style='color:red'> 红色文字</p>";
        Product currentProduct =new Product(5,"product e", 200);
         
        m.addAttribute("htmlContent", htmlContent);
        m.addAttribute("currentProduct", currentProduct);
         
        return "test";
    }
}
```

#### 3. thymeleaf页面
```html
<!DOCTYPE HTML>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>hello</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" type="text/css" media="all" href="../../webapp/static/css/style.css" th:href="@{/static/css/style.css}"/>
    <script type="text/javascript" src="../../webapp/static/js/thymeleaf.js" th:src="@{/static/js/thymeleaf.js}"></script>
     
    <style>
        h2{
            text-decoration: underline;
            font-size:0.9em;
            color:gray;
        }
    </style>       
</head>
<body>
 
<div class="showing">
    <h2>显示 转义和非转义的 html 文本</h2>
    <p th:text="${htmlContent}" ></p>
    <p th:utext="${htmlContent}" ></p>
</div>
 
<div class="showing">
    <h2>显示对象以及对象属性</h2>
    <p th:text="${currentProduct}" ></p>
    <p th:text="${currentProduct.name}" ></p>
    <p th:text="${currentProduct.getName()}" ></p>
</div>
 
<div class="showing" th:object="${currentProduct}">
    <h2>*{}方式显示属性</h2>
    <p th:text="*{name}" ></p>
</div>
 
<div class="showing">
    <h2>算数运算</h2>
    <p th:text="${currentProduct.price+999}" ></p>
</div>
 
</body>
</html>
```
test.html把控制器中的数据展示出来

1. 转义和非转义的html

   ```htm
   <p th:text="${htmlContent}" ></p>
   <p th:utext="${htmlContent}" ></p>
   ```
   
2. 获取对象属性的两种方式，*私有属性*也可以。

   ```html
   <p th:text="${currentProduct.name}" ></p>
   <p th:text="${currentProduct.getName()}" ></p>
   ```
   
3. 使用`*{}`方式显示当前对象的属性
   
   ```html
   <div class="showing" th:object="${currentProduct}">
       <h2>*{}方式显示属性</h2>
       <p th:text="*{name}" ></p>
   </div>
   ```
   
4. 算数运算，此处仅演示加法，其他略过不表

   ```html
   <p th:text="${currentProduct.price+999}" ></p>
   ```

#### 4. 重启测试

重启Application，访问`http://127.0.0.1:8080/thymeleaf/test`

效果如图：

![](C:\Users\180559\Desktop\note\springboot\springboot14.png)

### 包含

#### 1. include.html

templates文件夹下新建include.html，利用th:fragment标记代码片段。footer1不带参，footer2带参。

```html
<html xmlns:th="http://www.thymeleaf.org">
<footer th:fragment="footer1"> 
   <p >All Rights Reserved</p>
</footer>
<footer th:fragment="footer2(start,now)"> 
   <p th:text="|${start} - ${now} All Rights Reserved|"></p>
</footer>
</html>
```

#### 2. 修改页面test.html

使用按如下方式：

```html
<div th:replace="include::footer1" ></div>
<div th:replace="include::footer2(2015,2018)" ></div>
```

就达到了包含效果，第二种可以传参，除了th:replace，还可以空th:insert，区别:

* th:insert:保留自己的主标签，保留th:fragment的主标签
* th:replace:不要自己的主标签，保留th:fragment的主标签

#### 3. 重启测试

重新运行Application，访问地址`http://127.0.0.1:8080/thymeleaf/test`

效果图：![](C:\Users\180559\Desktop\note\springboot\springboot15.png)

### 条件

#### 1. 背景

在一个饥寒交迫的夜晚，颤颤发抖的小彬在路上捡到了testBoolean盒子，没有钥匙的小彬把盒子送到开盒店test，test老板帮小彬开盒子，开盒子的结果是？？？

```java
package com.how2java.springboot.web;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
 
import com.how2java.springboot.pojo.Product;
  
@Controller
public class TestController {
  
    @RequestMapping("/test")
    public String test(Model m) {
        
        boolean testBoolean = true;
         
        m.addAttribute("testBoolean", testBoolean);
         
        return "test";
    }
}
```

#### 2. test老板

```html
<div class="showing">
    <h2>条件判断</h2>
    <p th:if="${testBoolean}" >如果testBoolean 是 true ，test老板告知有钱</p>
    <p th:if="${not testBoolean}" >取反 ，所以如果testBoolean 是 true ，有钱也不告诉你</p>
    <p th:unless="${testBoolean}" >unless 等同于上一句，所以如果testBoolean 是 true ，不告诉你有钱</p>
    <p th:text="${testBoolean}?'当testBoolean为真的时候，显示本句话，这是用三相表达式做的':''" ></p>
</div>
```

#### 3. 去test开盒店

访问`http://127.0.0.1:8080/thymeleaf/test`

#### 4. 画风转回来

> 不只是布尔值的 true 和 false, th:if 表达式返回其他值时也会被认为是 true 或 false，规则如下:
>
> boolean 类型并且值是 true, 返回 true
> 数值类型并且值不是 0, 返回 true
> 字符类型(Char)并且值不是 0, 返回 true
> String 类型并且值不是 "false", "off", "no", 返回 true
> 不是 boolean, 数值, 字符, String 的其他类型, 返回 true
>
> 值是 null, 返回 false  

### 遍历

#### 1. 数据

在Controller里添加数据

```java
package com.how2java.springboot.web;
import java.util.ArrayList;
import java.util.List;
 
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
 
import com.how2java.springboot.pojo.Product;
  
@Controller
public class TestController {
  
    @RequestMapping("/test")
    public String test(Model m) {
        String htmlContent = "<p style='color:red'> 红色文字</p>";
        Product currentProduct =new Product(5,"product e", 200);
        boolean testBoolean = true;
         
        List<Product> ps = new ArrayList<>();
        ps.add(new Product(1,"product a", 50));
        ps.add(new Product(2,"product b", 100));
        ps.add(new Product(3,"product c", 150));
        ps.add(new Product(4,"product d", 200));
        ps.add(currentProduct);
        ps.add(new Product(6,"product f", 200));
        ps.add(new Product(7,"product g", 200));   
        
        m.addAttribute("ps", ps);
        m.addAttribute("htmlContent", htmlContent);
        m.addAttribute("currentProduct", currentProduct);
        m.addAttribute("testBoolean", testBoolean);
         
        return "test";
    }
}
```

#### 2. 遍历类型

##### (1) 普通遍历

使用`th:each` 遍历

```html
<table>
        <thead>
            <tr>
                <th>id</th>
                <th>产品名称</th>
                <th>价格</th>
            </tr>
        </thead>
        <tbody>
            <tr th:each="p: ${ps}">
                <td th:text="${p.id}"></td>
                <td th:text="${p.name}"></td>
                <td th:text="${p.price}"></td>
            </tr>
        </tbody>
</table>
```

##### (2) 带状态的遍历

使用`th:each="p,status:${ps}"`方式遍历就把状态放在`status`里面了，同时还用3元表达式判断奇偶赋值于class属性。`th:class="${status.even}?'even':'odd'" `

status里还包含如下信息：

1. index属性，0开始的索引值
2. count属性，1开始的索引值
3. size属性，集合内元素的总量
4. current属性，当前迭代对象
5. even/odd属性，boolean类型，用来判断是奇数个还是偶数个
6. first属性，boolean类型，是否是第一个
7. last属性，boolean类型，是否是最后一个

```html
 <table>
        <thead>
            <tr>
                <th>index</th>
                <th>id</th>
                <th>产品名称</th>
                <th>价格</th>
            </tr>
        </thead>
        <tbody>
            <tr th:class="${status.even}?'even':'odd'" th:each="p,status: ${ps}">
                <td  th:text="${status.index}"></td>
                <td th:text="${p.id}"></td>
                <td th:text="${p.name}"></td>
                <td th:text="${p.price}"></td>
            </tr>
        </tbody>
    </table>
```

##### (3) 结合select 

还是用`th:each`，但是放在`option`元素上，就可以遍历出多个下拉框出来了，其中`th:selected`表示被选中的项。

```html
 <select size="3">
        <option th:each="p:${ps}" th:value="${p.id}"     th:selected="${p.id==currentProduct.id}"    th:text="${p.name}" ></option>
    </select>
```

##### (4) 结合单选框

做法同样，其中`th:checked`用于判断是否选中

```html
 <input name="product" type="radio" th:each="p:${ps}" th:value="${p.id}"  th:checked="${p.id==currentProduct.id}"     th:text="${p.name}"  />  
<!--不能没有name属性，如果没有就有可以多选的情况发生-->
```



## 遇到的异常

###### JPA链接数据库出错

1. 数据库版本过高，数据库驱动myql-connector-java版本低，不兼容  //之后验证其实是数据库可以向下兼容
2. 数据库驱动类名低版本为`com.mysql.jdbc.Driver`高版本变为`com.mysql.cj.jdbc.Driver`
3. 服务器时区问题：出现` The server time zone value 'ÖÐ¹ú±ê×¼Ê±¼ä' is unrecognized or represents more than one time zone`  将数据库连接url变为`jdbc:mysql://127.0.0.1:3306/how2java?characterEncoding=UTF-8&serverTimezone=UTC`

###### 关于Field *** required a bean错误

bean加载失败了， 百度之后是原因之一是JPA冲突了，pom.xml配置依赖里，spring-boot-start-data-jpa版本号与spring-boot-starter-web版本号不一致导致。

###### Whitelabel 白页异常

springboot程序只加载主程序.java所在包及其子包下的内容，所以更改路径解决问题。

另我的错误发生在application.properties配置中`spring.mvc.view.prefix=/WEB-INF/jsp` 程序进入Controller映射函数中，完成数据读取处理，返回到jsp页面时无法达到。 正确配置`spring.mvc.view.prefix=/WEB-INF/jsp/` 

