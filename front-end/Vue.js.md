# Vue.js

> 什么是 Vue？ 
> 考虑这个需求： 我们要把一个 json对象的数据，显示到一个元素上去。
> 如果不使用 Vue, 那么就会用到 JS 或者 JQuery，通过操作 HTML DOM 的方式，把数据显示上去。
> 如果使用Vue, 那么仅仅需要提供数据，以及数据要绑定到的元素的id,就行了,不需要显式地操作HTML DOM。

## 基础使用

### 1. 引入vue.js库

`<script src="vue.min.js"></script>`

### 2. 创建Vue对象，绑定数据与视图的id

```html
<script src="vue.min.js"></script>
 
<div id="div1">
   
  {{gareen.name}}
 
</div>
  
<script>
  
//准备数据
var gareen = {"name":"盖伦","hp":616};
 
//通过vue.js 把数据和对应的视图关联起来
new Vue({
      el: '#div1',
      data: {
        message: gareen
      }
    })
  
</script>
```



## 监听事件

### v-on监听事件

1. 在js里为Vue对象的数据设置为clickNumber

   ```js
   data:{
       clickNumber:0
   }
   ```

2. 新建方法：count，作用为clickNumber自增1

   ```js
   methods:{
       count:function(){
           this.clickNumber++;
       }
   }
   ```

3. 在按钮上增加`click`监听，调用count方法

   `<button v-on:click="count">点击</button>`

```js
<script src="vue.min.js"></script>
  
<div id="div1">
  
  <div>一共点击了  {{clickNumber}}次</div> 
  <button v-on:click="count">点击</button>
  
</div>
   
<script>
   
new Vue({
      el: '#div1',
      data: {
          clickNumber:0
      },
      methods:{
          count: function(){
              this.clickNumber++;
          }
      }
    })
   
</script>
```

 4. `v-on`缩写为`@`

    `<button @click="count">点击</button>`

### 事件修饰符

1. .stop
2. .prevent
3. .capture
4. .self
5. .once

事件修饰符都是关于冒泡的，冒泡指的是父元素里有子元素，如果点击了子元素，那么click事件不仅会发生在子元素上也会发生在其父元素上，一次不停地像父元素冒泡直到document元素。

```html
<script src="vue.min.js"></script>
  
<style type="text/css">
   * {
       margin: 0 auto;
       text-align:center;
       line-height: 40px;
   }
   div {
       width: 100px;
       cursor:pointer;
   }
   #grandFather {
       background: green;
   }
   #father {
       background: blue;
   }
   #me {
       background: red;
   }#son {
        background: gray;
    }
</style>
     
<div id="content">
    <div id="grandFather"  v-on:click="doc">
        grandFather
        <div id="father" v-on:click="doc">
            father
            <div id="me" v-on:click="doc">
                me
                <div id="son" v-on:click="doc">
                son
            </div>
            </div>
        </div>
    </div>
 
</div>
   
<script>
    var content = new Vue({
        el: "#content",
        data: {
            id: ''
        },
        methods: {
            doc: function () {
                this.id= event.currentTarget.id;
                alert(this.id)
            }
        }
    })
</script>
```

#### 1. 阻止冒泡.stop

`<div id="me" v-on:click.stop="doc">`，在click后添加一个.stop，冒泡到这里就结束了，不会冒泡到father上去了。

#### 2. 优先出发.capture

在father上增加一个.capture，`<div id="father" v-on:click.capture="doc">`,当冒泡发生时，优先让father捕捉事件

#### 3. 只有自己能出发，子元素无法触发.self

修改father，增加.self，`<div id="father" v-on:click.self="doc">`，这样点击son和me都不会触发father的click事件，只有点击father自己，才会触发。

#### 4. 只能触发一次.once

修改father，增加.once，`<div id="father" v-on:click.once="doc">`，这样father点击一次后，不会再监听到click事件了。

#### 5. 组织提交.prevent

在click后添加.prevent可以阻止页面刷新`@click.prevent="jump"`也可以不跟函数`@click.prevent`

*注：只有超链和form这种会导致页面刷新的操作.prevent才有用，普通的不导致页面刷新的按钮加上这个没有任何变化*

### 条件语句

#### 1. v-if

通过toggle函数切换show的值。通过v-if语句，当show为true时显示当前元素

`<div v-if="show"> 默认这一条是看得见的</div> `

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
 
<div id="div1">
   
  <button v-on:click="toggle">切换隐藏显示</button>
  <div v-if="show"> 默认这一条是看得见的</div>
     
</div>
    
<script>
    
new Vue({
      el: '#div1',
      data: {
          show:true
      },
      methods:{
          toggle: function(){
              this.show=!this.show;
          }
      }
    })
    
</script>
```



#### 2. v-else

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
   
<div id="div1">
   
  <button v-on:click="moyiba"> 摸一把彩票 10%的几率，建议一边点击一边心里默数，多少次了,站长表示最多点了40次才中奖，妈蛋~ </button>
  <div v-if="show"> 中了500万！</div>
  <div v-else>谢谢惠顾！</div> 
     
</div>
    
<script>
    
new Vue({
      el: '#div1',
      data: {
          show:false
      },
      methods:{
          moyiba: function(){
             this.show=Math.random()<0.1
          }
      }
    })
    
</script>
```

#### 3. v-else-if

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
   
<div id="div1">
   
  <button v-on:click="toutai"> 看看下辈子投胎是做什么的 </button>
  <div v-if="number>98"> 神仙</div>
  <div v-else-if="number>95"> 国家领导人</div>
  <div v-else-if="number>90"> 大富商</div>
  <div v-else-if="number>80"> 大企业主</div>
  <div v-else-if="number>70"> 演艺明星</div>
  <div v-else-if="number>60"> 小企业主</div>
  <div v-else-if="number>50"> 普通公务员</div>
  <div v-else-if="number>40"> 小个体户</div>
  <div v-else-if="number>30"> 血汗工厂工人</div>
  <div v-else-if="number>20"> 偏远山区农民</div>
  <div v-else> 流浪汉</div>
     
</div>
    
<script>
    
new Vue({
      el: '#div1',
      data: {
          number:0
      },
      methods:{
          toutai: function(){
             this.number=Math.random()*100
          }
      }
    })
    
</script>
```

### 循环语句

#### v-for循环遍历

1. 准备jsonArray数据

   ```json
   var data = [
      		  {name:"盖伦",hp:341},
   		  {name:"提莫",hp:225},
   		  {name:"安妮",hp:427},
   		  {name:"死歌",hp:893}
       ];
   ```

2. 构建Vue对象，将数据作为参数传递进去

   ```vue
   data:	{
       heros:data
   }
   ```

3. 视图上通过v-for遍历数组

   ```html
   <tr v-for="hero in heros">
   	<td>{{hero.name}}</td>
   	<td>{{hero.hp}}</td>
   </tr>	
   ```

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
   
<style>
table tr td{
    border:1px solid gray;
}
table{
    border-collapse:collapse;
    width:300px;
}
tr.firstLine{
    background-color: lightGray;
}
</style>
 
<div id="div1">
   
    <table align="center" >
        <tr class="firstLine">
            <td>name</td>
            <td>hp</td>
        </tr>
         
        <tr v-for="hero in heros">
            <td>{{hero.name}}</td>
            <td>{{hero.hp}}</td>
        </tr>
         
    </table>
 
</div>
    
<script>
  
var data = [
          {name:"盖伦",hp:341},
          {name:"提莫",hp:225},
          {name:"安妮",hp:427},
          {name:"死歌",hp:893}
    ];
new Vue({
      el: '#div1',
      data: {
          heros:data
      }
    })
    
</script>
```

#### index用法

通过如下方式获取遍历的下标`<tr v-for="hero,index in heros">`

#### 纯数字遍历

`<div v-for="i in 10">`

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
   
<div id="div1">
    <div v-for="i in 10">
     {{ i }}
    </div>
</div>
    
<script>
  
new Vue({
      el: '#div1'
    })
    
</script>
```

### 属性绑定

#### v-bind属性绑定

通过v-bind进行属性绑定`<a v-bind:href="page">http://12306.com</a>`

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
   
<div id="div1">
    <a v-bind:href="page">http://12306.com</a>
</div>
    
<script>
  
new Vue({
      el: '#div1',
      data:{
          page:'http://12306.com'
      }
    })
    
</script>
```

*v-bind:href可以简写成:href*。如下：

`<a :href="page">http://12306.com</a>`

### 双向绑定

#### v-model双向绑定

利用v-model进行双向绑定，将视图上的数据放到Vue对象上去。

` <input v-model="name" >`

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
   
<div id="div1">
     
    hero name: <input v-model="name" >
    <button @click="doClick" >提交数据</button>
     
</div>
    
<script>
  
new Vue({
      el: '#div1',
      data:{
        name:"teemo"
      },
      methods:{
          doClick:function(){
              alert(this.name);
          }
      }
    })
    
</script>
```

#### 修饰符

vue.js还提供一些修饰符方便用户操作，常见的有：

1. lazy
2. number
3. trim

##### 1. 修饰符.lazy

对于输入元素，默认的行为方式是一旦数据变化，马上进行绑定。但是加上.lazy之后，相当于监听change操作，只有在失去焦点的时候才会进行数据绑定。

##### 2. 修饰符.number

有时候，拿到数据需要进行数学运算，为了保证运算结果，必须先把类型转换为number类型，而v-model默认是string类型，所以可以通过.number的方式确保获取到的是数字类型。

##### 3. 修饰符.trim

去掉前后的空白

### 计算属性computed

computed可以用来计算返回值，与methods区别在与：computed有缓存，当数据无变化时会直接返回以前计算出来的值，不会再次计算。methods会每次调用。

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
     
<style>
table tr td{
    border:1px solid gray;
    padding:10px;
      
}
table{
    border-collapse:collapse;
    width:800px;
    table-layout:fixed;
}
tr.firstLine{
    background-color: lightGray;
}
</style>
   
<div id="div1">
     
    <table align="center" >
        <tr class="firstLine">
            <td>人民币</td>
            <td>美元</td>
        </tr>      
        <tr>
            <td align="center" colspan="2">
            汇率： <input type="number" v-model.number="exchange" />
            </td>
        </tr>
         
        <tr>
         
            <td align="center">
                ￥: <input type="number" v-model.number = "rmb"  />
            </td>
            <td align="center">
<!--                $: {{ dollar }}   -->
                $:{{getDollar()}}
            </td>
        </tr>
    </table>
   
</div>
      
<script>
    
new Vue({
      el: '#div1',
      data: {
          exchange:6.4,
          rmb:0
      },
      computed:{
          dollar:function() {
              return this.rmb / this.exchange;
          }
      },
/*   methods:{
        getDollar:function(){
        	return this.rmb/this.exchange;
        }
   	 }*/
    })
     
</script>
```

### 监听属性

vue可以通过watch来监听属性值的变化。

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
     
<style>
table tr td{
    border:1px solid gray;
    padding:10px;
      
}
table{
    border-collapse:collapse;
    width:800px;
    table-layout:fixed;
}
tr.firstLine{
    background-color: lightGray;
}
</style>
   
<div id="div1">
     
    <table align="center" >
        <tr class="firstLine">
            <td>人民币</td>
            <td>美元</td>
        </tr>      
        <tr>
            <td align="center" colspan="2">
            汇率： <input type="number" v-model.number="exchange" />
            </td>
        </tr>
         
        <tr>
         
            <td align="center">
                ￥: <input type="number" v-model.number = "rmb"  />
            </td>
            <td align="center">
                $: <input type="number" v-model.number = "dollar"   />
            </td>
        </tr>
    </table>
   
</div>
      
<script>
    
new Vue({
      el: '#div1',
      data: {
          exchange:6.4,
          rmb:0,
          dollar:0
      },
      watch:{
          rmb:function(val) {
              this.rmb = val;
              this.dollar = this.rmb / this.exchange;
          },
          dollar:function(val) {
              this.dollar = val;
              this.rmb = this.dollar * this.exchange;
          },
      }
       
    })
 
</script>
```

### 过滤器

定义一个首字母大写过滤器

```js
	 filters:{
    	  capitalize:function(value) {
    		    if (!value) return '' //如果为空，则返回空字符串
    		    value = value.toString()
    		    return value.charAt(0).toUpperCase() + value.substring(1)
          }
      }
```

然后视图用如下方式使用：

`{{data|capitalize}}`

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
 
<style>
table tr td{
    border:1px solid gray;
    padding:10px;
      
}
table{
    border-collapse:collapse;
    width:800px;
    table-layout:fixed;
}
tr.firstLine{
    background-color: lightGray;
}
</style>
   
<div id="div1">
     
    <table align="center" >
        <tr class="firstLine">
            <td>输入数据</td>
            <td>过滤后的结果</td>
        </tr>      
        <tr>
            <td align="center">
                <input v-model= "data"  />
            </td>
            <td align="center">
                {{ data|capitalize }}
            </td>
        </tr>
    </table>
   
</div>
      
<script>
    
new Vue({
      el: '#div1',
      data: {
          data:''
      },
      filters:{
          capitalize:function(value) {
                if (!value) return '' //如果为空，则返回空字符串
                value = value.toString()
                return value.charAt(0).toUpperCase() + value.substring(1)
          }
      }
    })
     
</script>
```

#### 多个过滤器

定义两个过滤器分别是首字母大写和尾字母大写。然后`{{data|capitalize|capitalizeLastLetter}}`

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
 
<style>
table tr td{
    border:1px solid gray;
    padding:10px;
      
}
table{
    border-collapse:collapse;
    width:800px;
    table-layout:fixed;
}
tr.firstLine{
    background-color: lightGray;
}
</style>
   
<div id="div1">
     
    <table align="center" >
        <tr class="firstLine">
            <td>输入数据</td>
            <td>过滤后的结果</td>
        </tr>      
        <tr>
            <td align="center">
                <input v-model= "data"  />
            </td>
            <td align="center">
                {{ data|capitalize|capitalizeLastLetter }}
            </td>
        </tr>
    </table>
   
</div>
      
<script>
    
new Vue({
      el: '#div1',
      data: {
          data:''
      },
      filters:{
          capitalize:function(value) {
                if (!value) return '' //如果为空，则返回空字符串
                value = value.toString()
                return value.charAt(0).toUpperCase() + value.substring(1)
          },
          capitalizeLastLetter:function(value) {
                if (!value) return '' //如果为空，则返回空字符串
                value = value.toString()
                return value.substring(0,value.length-1)+ value.charAt(value.length-1).toUpperCase()
          }
      }
    })
      
</script>
```

#### 全局过滤器

过滤器定义在Vue对象里，有时候很多不同页面需要用到同一个过滤器，如果每个Vue对象都重复开发相同的过滤器，不仅开发量增加，维护负担也加重。因此可以使用全局过滤器的定义方式，在不同的Vue对象里使用。注册全局过滤器：

```js
Vue.filter('capitalize', function (value) {
	if (!value) return ''
	value = value.toString()
	return value.charAt(0).toUpperCase() + value.slice(1)
})
Vue.filter('capitalizeLastLetter', function (value) {
	if (!value) return '' //如果为空，则返回空字符串
	value = value.toString()
	return value.substring(0,value.length-1)+ value.charAt(value.length-1).toUpperCase()
})
```

### 组件

#### 局部组件

在Vue对象里增加components

```js
components:{
    'product':{
        template:'<div class="product" >MAXFEEL休闲男士手包真皮手拿包大容量信封包手抓包夹包软韩版潮</div>'
    }
}
```

视图通过如下方式调用，可重复使用。

`<product></product>`

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
 
<style>
div.product{
  float:left;
  border:1px solid lightGray;
  width:200px;
  margin:10px;
  cursor: pointer;
}
</style>
 
<div id="div1">
    <product></product>
    <product></product>
    <product></product>
</div>
  
<script>
new Vue({
  el: '#div1',
  components:{
      'product':{
          template:'<div class="product" >MAXFEEL休闲男士手包真皮手拿包大容量信封包手抓包夹包软韩版潮</div>'
      }
  }
})
</script>
```

#### 全局组件

和vue.js里的过滤器一样，有的组件要在不同页面使用，考虑使用全局组件。

```js
Vue.component('product',{
    template:'<div class="product" >MAXFEEL休闲男士手包真皮手拿包大容量信封包手抓包夹包软韩版潮</div>'
})
```

#### 参数

传递参数给组件

```js
Vue.component('product',{
    props:['name'],
    template:'<div class='product'>{{name}}</div>'
})
```

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
 
<style>
div.product{
  float:left;
  border:1px solid lightGray;
  width:200px;
  margin:10px;
  cursor: pointer;
}
</style>
 
<div id="div1">
    <product name="MAXFEEL休闲男士手包真皮手拿包大容量信封包手抓包夹包软韩版潮"></product>
    <product name="宾度 男士手包真皮大容量手拿包牛皮个性潮男包手抓包软皮信封包"></product>
    <product name="唯美诺新款男士手包男包真皮大容量小羊皮手拿包信封包软皮夹包潮"></product>
</div>
  
<script>
Vue.component('product', {
      props:['name'],
      template: '<div class="product" >{{name}}</div>'
    })
 
new Vue({
  el: '#div1'
})
</script>
```

#### 动态参数

动态参数就是组件内的参数可以和组件外的值关联起来。

name表示组件内属性name,outName就是组件外的

`<product v-bind:name="outName"></product>`

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
 
<style>
div.product{
  float:left;
  border:1px solid lightGray;
  width:200px;
  margin:10px;
  cursor: pointer;
}
</style>
 
<div id="div1">
    组件外的值：<input v-model="outName" ><br>
    <product v-bind:name="outName"></product>
</div>
  
<script>
Vue.component('product', {
      props:['name'],
      template: '<div class="product" >{{name}}</div>'
    })
 
new Vue({
  el: '#div1',
  data:{
      outName:'产品名称'
  }
})
</script>
```

#### 自定义事件

和在Vue对象上增加methods是一样的做法，先来个methods：

```js
methods:{
    increaseSale:function(){
        this.sale++;
    }
}
```

然后再组件里`v-on:click="increaseSale"`

*这是在组件里增加的，而不是在视图上增加的*

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
 
<style>
div.product{
  float:left;
  border:1px solid lightGray;
  width:200px;
  margin:10px;
  cursor: pointer;
}
</style>
 
<div id="div1">
    <product name="MAXFEEL休闲男士手包真皮手拿包大容量信封包手抓包夹包软韩版潮" sale="10" ></product>
    <product name="宾度 男士手包真皮大容量手拿包牛皮个性潮男包手抓包软皮信封包" sale="20" ></product>
    <product name="唯美诺新款男士手包男包真皮大容量小羊皮手拿包信封包软皮夹包潮" sale="30" ></product>
</div>
 
<script>
Vue.component('product', {
      props:['name','sale'],
      template: '<div class="product" v-on:click="increaseSale">{{name}} 销量: {{sale}} </div>',
      methods:{
          increaseSale:function(){
              this.sale++
          }
      }
    })
 
new Vue({
  el: '#div1'
})
</script>
```

#### 遍历json数组

大部分时候拿到的是Json数组，遍历json数组为多个组件实例。

1. 准备产品数组

   ```html
   products:[
               {"name":"MAXFEEL休闲男士手包真皮手拿包大容量信封包手抓包夹包软韩版潮","sale":"18"},
               {"name":"宾度 男士手包真皮大容量手拿包牛皮个性潮男包手抓包软皮信封包","sale":"35"},
               {"name":"唯美诺新款男士手包男包真皮大容量小羊皮手拿包信封包软皮夹包潮","sale":"29"}
               ]
   ```

2. 在试图力通过v-for遍历products

   ```html
   <product v-for="item in products" v-bind:product="item"></product>
   ```

3. 修改组件，组件里的product参数接收到item数据，显示和方法里也通过`product.xxx`来调用

   ```html
   Vue.component('product', {
   	  props:['product'],
   	  template: '<div class="product" v-on:click="increaseSale">{{product.name}} 销量: {{product.sale}} </div>',
   	  methods:{
   		  increaseSale:function(){
   			  this.product.sale++
   		  }
   	  }
   	})
   
   ```

代码如下：

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
 
<style>
div.product{
  float:left;
  border:1px solid lightGray;
  width:200px;
  margin:10px;
  cursor: pointer;
}
div.product:hover{
  border:1px solid #c40000;
   
}
div.price{
  color:#c40000; 
  font-weight:bold;
  font-size:1.2em;
  margin:10px;
}
div.productName{
  color:gray;
  font-size:0.8em;
  margin:10px;
}
div.sale{
  float:left; 
  width:100px;
  border:1px solid lightgray;
  border-width:1px 0px 0px 0px;
  color:gray;
  font-size:0.8em;
  padding-left:10px;
}
div.review{
  overflow:hidden;
  border:1px solid lightgray;
  border-width:1px 0px 0px 1px;
  color:gray;
  font-size:0.8em; 
  padding-left:10px;
} 
</style>
 
<div id="tempalate" style="display:none">
    <div class="product" v-on:click="increaseSales">
        <div class="price">
                    ¥ {{product.price}}
        </div>
        <div class="productName">
            {{product.name}}
        </div>
        <div class="sale"> 月成交 {{product.sale}} 笔</div>
        <div class="review"> 评价 {{product.review}} </div>
    </div>
</div>
 
<div id="div1">
    <product v-for="item in products" v-bind:product="item"></product>
</div>
  
<script>
var tempalateDiv=document.getElementById("tempalate").innerHTML;
var templateObject = {
    props: ['product'],
    template: tempalateDiv,
      methods: {
            increaseSales: function () {
                this.product.sale = parseInt(this.product.sale);
              this.product.sale += 1
              this.$emit('increment')
            }
          }
 
}
 
Vue.component('product', templateObject)
 
new Vue({
  el: '#div1',
  data:{
      products:[
                {"name":"MAXFEEL休闲男士手包真皮手拿包大容量信封包手抓包夹包软韩版潮","price":"889","sale":"18","review":"5"},
                {"name":"宾度 男士手包真皮大容量手拿包牛皮个性潮男包手抓包软皮信封包","price":"322","sale":"35","review":"12"},
                {"name":"唯美诺新款男士手包男包真皮大容量小羊皮手拿包信封包软皮夹包潮","price":"523","sale":"29","review":"3"},
                ]
  }
})
</script>
```

### 自定义指令

像`v-if,v-on,v-bind`都是vue.js自带指令，除了自带指令，开发者还可以自定义指令。

#### 简单实例

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
 
<div id="div1">
     
    <div v-xart> 好好学习，天天向上 </div>
  
</div>
 
<script>
 
Vue.directive('xart', function (el) {
    el.innerHTML = el.innerHTML + ' ( x-art ) '
    el.style.color = 'pink'
})
 
new Vue({
  el: '#div1'
})
</script>
```

1. 使用Vue.directive来自定义
2. 第一个参数就是指令名称`xart`
3. el表示当前html DOM对象
4. 在方法体内就可以通过innerHTML style.color等方式操控当前元素

#### 带参数的自定义指令

`binding.value`就是指`v-xart="xxx"`里的这个xxx，此时xxx是一个json对象，所以就可以通过`.text`，`.color`取出对应值。

```js
Vue.directive('xart', function (el,binding) {
	el.innerHTML = el.innerHTML + '( ' + binding.value.text + ' )'
	el.style.color = binding.value.color
})
```

视图上传递了json对象进去

```html
<div v-xart="{color:'red',text:'best learning video'}"> 好好学习，天天向上 </div>
```

当然也可以传递个简单的

```html
<div v-xart="blue"> 好好学习，天天向上 </div>
```

那么在函数里直接调用binding.value就好了。

*完整代码：*

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
 
<div id="div1">
     
    <div v-xart="{color:'red',text:'best learning video'}"> 好好学习，天天向上 </div>
     
</div>
 
<script>
 
Vue.directive('xart', function (el,binding) {
    el.innerHTML = el.innerHTML + '( ' + binding.value.text + ' )'
    el.style.color = binding.value.color
})
 
new Vue({
  el: '#div1'
})
</script>
```

#### 钩子函数

  钩子函数 又叫做回调函数，或者事件响应函数。 指的是，一个指令在创建过程中，经历不同生命周期的时候，vue.js 框架调用的函数。
事件常见的有如下几种：
bind：只调用一次，指令第一次绑定到元素时调用。在这里可以进行一次性的初始化设置。
update：所在组件的 VNode 更新时调用，但是可能发生在其子 VNode 更新之前。指令的值可能发生了改变，也可能没有。但是你可以通过比较更新前后的值来忽略不必要的模板更新 (详细的钩子函数参数见下)。
unbind：只调用一次，指令与元素解绑时调用。
以bind为例，可以传递主要是用到binding里的属性
name：指令名，不包括 v- 前缀。
value：指令的绑定值，本例就是hello vue.js
oldValue：指令绑定的前一个值，仅在 update 和 componentUpdated 钩子中可用。无论值是否改变都可用。
expression：字符串形式的指令绑定值表达式。本例就是 message
arg：传给指令的参数，本例就是hello
modifiers：一个包含修饰符的对象。本例就是 .a .b
这样拿到这些自定义指令的各项参数，那么在函数体里就方便做各种自定义功能了
vnode是虚拟节点，里面具体什么意思，我也不太懂。。。好像也用不到，pass 吧~  

*代码*

```html
<script src="http://how2j.cn/study/vue.min.js"></script>
 
<div id="div1">
     
    <div v-xart:hello.a.b="message"> </div>
     
</div>
 
<script>
Vue.directive('xart', {
      bind: function (el, binding, vnode) {
            var s = JSON.stringify
            el.innerHTML =
              'name: '       + s(binding.name) + '<br>' +
              'value: '      + s(binding.value) + '<br>' +
              'expression: ' + s(binding.expression) + '<br>' +
              'argument: '   + s(binding.arg) + '<br>' +
              'modifiers: '  + s(binding.modifiers) + '<br>' +
              'vnode keys: ' + Object.keys(vnode).join(', ')
      },
       
      update: function (newValue, oldValue) {
        // 值更新时的工作
        // 也会以初始值为参数调用一次
      },
      unbind: function () {
        // 清理工作
        // 例如，删除 bind() 添加的事件监听器
      }
    })
     
new Vue({
  el: '#div1',
  data:{
      message:'hello vue.js'
  }
})
//运行效果
name: "xart"
value: "hello vue.js"
expression: "message"
argument: "hello"
modifiers: {"a":true,"b":true}
vnode keys: tag, data, children, text, elm, ns, context, fnContext, fnOptions, fnScopeId, key, componentOptions, componentInstance, parent, raw, isStatic, isRootInsert, isComment, isCloned, isOnce, asyncFactory, asyncMeta, isAsyncPlaceholder
</script>


```

