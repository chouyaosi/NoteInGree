## 遇到的问题总结

### 站点过滤

如果子表站点过滤， 那么子表站点需与主表一致，否则无法显示

同样， 如果一个表A站点过滤， 表B想通过关系找到表A，必须有相同站点，否则无法找到。   

### 不允许ADD

![啊啊啊](C:/Users/180559/Desktop/note/SAMEX/%E6%B5%8B%E8%AF%95%E4%BA%A7%E5%93%81%E5%8D%95_%E4%B8%8D%E5%85%81%E8%AE%B8ADD.png)

权限管理里，  将"为所有地点授权该组" 然后重启服务器问题才解决。

### BUG解决

1）、工装点检APP资产无法查看

给胡工解决无法查看资产问题， 由于权限问题无法查看。数据库有一张UserRightsView用来查看某hrid有无对对应app的权限

```sql
select * from asset where assetnum='ffa00002580-001' and exists (select 1  from UserRightsView x with(nolock)  where  x.hrid = '661277' and x.app = 'ASSET' and (x.authallsites = 1 or asset.siteid=x.siteid) and x.optionname = 'READ')
```

