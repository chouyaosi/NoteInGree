# MyBatis

> 平时使用JDBC访问数据库，首先要加载数据库驱动，建立数据库连接，还要操作Connection，Statement，ResultSet等辅助类，编写SQL语句并执行得到数据，然后再组装成对象。过程繁杂。使用MyBatis可以将数据库的连接，SQL的执行交给Mybatis去做。我们只需要关注SQL语句。



## ORM方式

> Mybatis通过两种方式与数据库数据形成映射，xml文件映射方式和注解映射方式

### xml文件映射方式

#### xml映射实现CRUD

##### 1. com/how2java/pojo实体类编写

**注:com/how2java/pojo实体类编写都将getter和setter函数省略了。**

```java
package com/how2java/pojo;

public class Category {
    private int id;
    private String name;
}
```

##### 2. 配置Mybatis-config.xml

```xml-dtd
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <typeAliases>
        <package name="com/how2java/pojo"/>
    </typeAliases>
    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"></transactionManager>
            <dataSource type="POOLED">
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/how2java?characterEncoding=UTF-8"/>
                <property name="username" value="root"/>
                <property name="password" value="root"/>
            </dataSource>
        </environment>
    </environments>

    <mappers>
        <mapper resource="com/how2java/pojo/Category.xml"/>
    </mappers>
</configuration>
```

##### 3. 配置映射文件xml

```xml-dtd
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.how2java.pojo.Category">
<!-- CRUD -->
    <select id="listCategory" resultType="Category">
        select * from category_;
    </select>
 	<insert id="addCategory" parameterType="Category" >
            insert into category_ ( name ) values (#{name})   
    </insert>

    <delete id="deleteCategory" parameterType="Category" >
    delete from category_ where id= #{id}  
    </delete>

    <select id="getCategory" parameterType="_int" resultType="Category">
    select * from   category_  where id= #{id}   
    </select>

    <update id="updateCategory" parameterType="Category" >
    update category_ set name=#{name} where id=#{id}   
    </update>
<!-- 多条件查询 -->
	<select id="listCategoryByIdAndName"  parameterType="map" resultType="Category">
            select * from   category_  where id> #{id}  and name like concat('%',#{name},'%')
    </select>
</mapper>
```

##### 4. 获取SqlSession,操作数据

```java
 String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        SqlSession session=sqlSessionFactory.openSession();
         
        List<Category> cs=session.selectList("listCategory");
        //多条件查询
        Map<String,Object> params = new HashMap<>();
        params.put("id", 3);
        params.put("name", "cat");

        List<Category> cs2 = session.selectList("listCategoryByIdAndName",params);
```

#### xml映射一对多

> 所有的表之间的关系都在数据库建好的那一刻设计好了， 这里的xml映射只是将这种关系对应起来。

##### 1. 编写实体类

```java
package com/how2java/pojo;
//Product实体类
public class Product {
    private int id;
    private String name;
    private float price;
}
```

Category实体类添加`List<Product> products`属性。

##### 2. 配置xml映射文件

一对多利用*resultMap*，*collection*对应。使用collection 进行一对多关系关联，指定表字段名称与对象属性名称的，两张表都有`id`属性，利用*cid*和*pid*加以区分，*column*为表字段名，*property*为实体类中对应映射变量名

```xml-dtd
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
    PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
    <mapper namespace="com.how2java.pojo.Category">
        <resultMap type="Category" id="categoryBean">
            <id column="cid" property="id" />
            <result column="cname" property="name" />
     
            <!-- 一对多的关系 -->
            <!-- ofType：指的是集合中元素的类型 -->
            <collection property="products" ofType="Product">
                <id column="pid" property="id" />
                <result column="pname" property="name" />
                <result column="price" property="price" />
            </collection>
        </resultMap>
     
        <!-- 关联查询分类和产品表 -->
        <select id="listCategory" resultMap="categoryBean">
            select c.*, p.*, c.id 'cid', p.id 'pid', c.name 'cname', p.name 'pname' from category_ c left join product_ p on c.id = p.cid
        </select>   
    </mapper>
```

#### XML映射多对一

##### 1. 编写实体类

Product实体类添加`Category category` 属性。形成多对一关系。

``` java
package com/how2java/pojo;
//Product实体类
public class Product {
    private int id;
    private String name;
    private float price;
    private Category category;
}
```

##### 2. 配置mybatis-config.xml

增加Product.xml的映射。

```xml-dtd
<mappers>
        <mapper resource="com/how2java/pojo/Category.xml"/>
        <mapper resource="com/how2java/pojo/Product.xml"/>
</mappers>
```

##### 3. 配置xml映射文件

使用association进行多对一关系关联，指定表字段名称与对象属性名称的一一对应关系

```xml-dtd
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
    PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
    <mapper namespace="com.how2java.pojo.Product">
        <resultMap type="Product" id="productBean">
            <id column="pid" property="id" />
            <result column="pname" property="name" />
            <result column="price" property="price" />
     
            <!-- 多对一的关系 -->
            <!-- property: 指的是属性名称, javaType：指的是属性的类型 -->
            <association property="category" javaType="Category">
                <id column="cid" property="id"/>
                <result column="cname" property="name"/>
            </association>
        </resultMap>
     
        
        <select id="listProduct" resultMap="productBean">
            select c.*, p.*, c.id 'cid', p.id 'pid', c.name 'cname', p.name 'pname' from category_ c left join product_ p on c.id = p.cid
        </select>   
    </mapper>
```

##### XML映射多对多

> 一张订单里 可以包含多种产品
> 一种产品 可以出现在多张订单里
> 这就是多对多关系
> 为了维系多对多关系，必须要一个中间表。

数据库表结构如下

```mysql
create table product_(
id int AUTO_INCREMENT,
name varchar(30)  DEFAULT NULL,
price float  DEFAULT 0,
    
PRIMARY KEY (id)
)AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

create table order_ (
  id int(11) AUTO_INCREMENT,
  code varchar(32) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
 
create table order_item_(
  id int(11) AUTO_INCREMENT, 
  oid int ,
  pid int ,
  number int ,
  PRIMARY KEY(id)
)AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
```

##### 1. 实体类编写

```java
package com/how2java/pojo;
//Product实体类
public class Product {
    private int id;
    private String name;
    private float price;
}
```

```java
package com/how2java/pojo;
 
public class Order {
    private int id;
    private String code;
     
    List<OrderItem> orderItems;
}
```

```java
package com/how2java/pojo;
 
public class OrderItem {
    private int id;
    private int number;
    private Order order;
    private Product product;
}
```

##### 2. 配置Mybatis-config.xml

```xml-dtd
<mappers>
        <mapper resource="com/how2java/pojo/Product.xml"/>
        <mapper resource="com/how2java/pojo/Order.xml"/>
        <mapper resource="com/how2java/pojo/OrderItem.xml"/>
</mappers>
```

##### 3. 配置xml映射文件

> 查询出所有的订单，然后遍历每个订单下的多条订单项，以及订单项对应的产品名称，价格，购买数量

```xml-dtd
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
    PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
    <mapper namespace="com.how2java.pojo.Order">
        <resultMap type="Order" id="orderBean">
            <id column="oid" property="id" />
            <result column="code" property="code" />
             
            <collection property="orderItems" ofType="OrderItem">
                <id column="oiid" property="id" />
                <result column="number" property="number" />
                <association property="product" javaType="Product">
                    <id column="pid" property="id"/>
                    <result column="pname" property="name"/>
                    <result column="price" property="price"/>
                </association>               
            </collection>
        </resultMap>
         
        <select id="listOrder" resultMap="orderBean">
            select o.*,p.*,oi.*, o.id 'oid', p.id 'pid', oi.id 'oiid', p.name 'pname'
                from order_ o
                left join order_item_ oi    on o.id =oi.oid
                left join product_ p on p.id = oi.pid
        </select>
        
    </mapper>
```

### 注解映射方式

*注：注解实现映射关系同xml实现映射都使用相同的pojo实体类，因此之后省略pojo的编写；另外因mybatis-config.xml配置文件编写类似，大部分也省略*

#### 注解映射实现CRUD

##### 1. 配置mybatis-config.xml

```xml-dtd
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
"http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <typeAliases>
      <package name="com/how2java/pojo"/>
    </typeAliases>
    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
            <property name="driver" value="com.mysql.jdbc.Driver"/>
            <property name="url" value="jdbc:mysql://localhost:3306/how2java?characterEncoding=UTF-8"/>
            <property name="username" value="root"/>
            <property name="password" value="admin"/>
            </dataSource>
        </environment>
    </environments>
    <mappers>
        <mapper resource="com/how2java/pojo/Category.xml"/>
        <mapper class="com.how2java.mapper.CategoryMapper"/> 
    </mappers>
</configuration>
```

##### 2. 编写Mapper接口

```java
public interface CategoryMapper {
  
    @Insert(" insert into category_ ( name ) values (#{name}) ") 
    public int add(Category category); 
        
    @Delete(" delete from category_ where id= #{id} ") 
    public void delete(int id); 
        
    @Select("select * from category_ where id= #{id} ") 
    public Category get(int id); 
      
    @Update("update category_ set name=#{name} where id=#{id} ") 
    public int update(Category category);  
        
    @Select(" select * from category_ ") 
    public List<Category> list(); 
}
```

##### 3. 获取Mapper，操作数据

```java
		String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        SqlSession session = sqlSessionFactory.openSession();
        CategoryMapper mapper = session.getMapper(CategoryMapper.class);
		
		List<Category> cs = mapper.list();
		
```

#### 注解一对多

##### 一个分类有多个产品

```java
public interface CategoryMapper {
    @Select(" select * from category_ ")
    @Results({ 
                @Result(property = "id", column = "id"),
                @Result(property = "products", javaType = List.class, column = "id", many = @Many(select = "com.how2java.mapper.ProductMapper.listByCategory") )
            })
    public List<Category> list();
 
}
```

> 新增加CategoryMapper接口，查询所有Category
> @Select注解获取Category类本身

```java
@Select(" select * from category_ ")
```

> @Results 通过@Result和@Many中调用ProductMapper.listByCategory()方法相结合，来获取一对多关系

```java
@Results({@Result(property = "products", javaType = List.class, column = "id", 
  many = @Many(select = "com.how2java.mapper.ProductMapper.listByCategory"))})
```
> 编写ProductMapper的listByCategory。

```java
public interface ProductMapper {

    @Select(" select * from product_ where cid = #{cid}")
    public List<Product> listByCategory(int cid);
     
}
```

#### 注解多对一

##### 多个产品对应一个分类

```java
public interface ProductMapper {
  @Select(" select * from product_ ")
  @Results({@Result(property="category",column="cid",one=@One(select="com.how2java.mapper.CategoryMapper.get")) 
    })
    public List<Product> list();
}
```

> 新增加ProductMapper接口，查询所有Product
> @Select注解获取Product类本身

```java
@Select(" select * from product_ ")
```

> @Results 通过@Result和@One中调用CategoryMapper.get()方法相结合，来获取多对一关系

```java
@Results({@Result(property="category",column="cid",one=@One(select="com.how2java.mapper.CategoryMapper.get")) 
    })
```

> 编写CategoryMapper的get。

```java
public interface CategoryMapper {
    @Select(" select * from category_ where id = #{id}")
    public Category get(int id);  
}
```

#### 注解多对多

> 之前已经解释，产品与订单为多对多关系，需要订单项表来维系关系。具体表现为：一个订单可以有多个订单项，一个订单项对应一个产品；一个产品可以存在于多个订单项中，而一个订单项对应一个订单。

##### 订单与订单项建立一对多

```java
public interface OrderMapper {
    @Select("select * from order_")
    @Results({
            @Result(property = "id", column = "id"),
            @Result(property = "orderItems", javaType = List.class, column = "id",many = @Many(select ="com.how2java.mapper.OrderItemMapper.listByOrder"))})     public List<Order> list();  
}
```

##### 订单项与产品建立多对一关系

```java
public interface OrderItemMapper {
     
  @Select(" select * from order_item_ where oid = #{oid}")
  @Results({@Result(property="product",column="pid",one=@One(select="com.how2java.mapper.ProductMapper.get"))}) 
    public List<OrderItem> listByOrder(int oid);
}
```

> 编写产品ProductMapper的get

```java
public interface ProductMapper {
    @Select("select * from product_ where id = #{id}")
    public Product get(int id);
}
```

