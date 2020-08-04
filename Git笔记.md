# Git

## 创建版本库

### 创建仓库命令

在需要版本控制的文件夹目录下右键点击`git bash here` ， 在命令行使用`git init `命令创建仓库。

> 版本控制系统只能追踪文本文件的改动，例如txt，网页，所有程序代码。而图片、视频这些二进制文件，虽然也能由版本控制系统管理，但没法跟踪文件的变化，只能把二进制文件每次改动串起来，也就是只知道图片从100KB改成了120KB，但到底改了啥，版本控制系统不知道，也没法知道。 

### 文件放到仓库

1. `git add <文件名>` 将文件添加到仓库
2. `git commit -m "<备注>"`将文件提交到仓库

## 时光机穿梭

### 查看仓库状态

使用`git status`查看仓库的状态 ，`git diff`命令查看修改痕迹。修改文件之后，  再进行add 和commit命令操作。

### 版本回退

`git log`命令可以查看提交日志，`git log --pretty=oneline`查看简化的日志信息。`git log --graph --pretty=oneline --abbrev-commit` 图形方式查看提交日志。

每次commit都是一个快照版本， 都有一个commit id。在Git中`head`表示当前版本，`head^`是上一个版本`head^^`是上上个版本。`head~100`是往上100个版本。

```ascii
┌────┐
│HEAD│
└────┘
   │
   └──> ○ append GPL
        │
        ○ add distributed
        │
        ○ wrote a readme file
┌────┐
│HEAD│
└────┘
   │
   │    ○ append GPL
   │    │
   └──> ○ add distributed
        │
        ○ wrote a readme file
```

使用`git reset --hard <commit id>或者head~n`可以回溯到对应版本。 `git reflog`记录每一次命令

### 工作区和暂存区

我们的工程文件目录就是工作区，隐藏目录`.git`是版本库(Repository)，版本库里最重要的是称为`stage`的暂存区，还有Git为我们自动创建的一条`master`分支，以及指向`master`的一个指针叫`head`

![暂存区](C:\Users\180559\Desktop\note\暂存区.jpg)



分支和`HEAD`的概念我们以后再讲。

前面讲了我们把文件往Git版本库里添加的时候，是分两步执行的：

第一步是用`git add`把文件添加进去，实际上就是把文件修改添加到暂存区；

第二步是用`git commit`提交更改，实际上就是把暂存区的所有内容提交到当前分支。

因为我们创建Git版本库时，Git自动为我们创建了唯一一个`master`分支，所以，现在，`git commit`就是往`master`分支上提交更改。

你可以简单理解为，需要提交的文件修改通通放到暂存区，然后，一次性提交暂存区的所有修改。

Git管理的是修改不是文件本身， `git diff HEAD -- readme.txt`命令查看工作区和版本库最新版本的区别。

### 撤销修改

`git checkout -- 文件名` 可以丢弃工作区的修改： 

命令`git checkout -- readme.txt`意思就是，把`readme.txt`文件在工作区的修改全部撤销，这里有两种情况：

一种是`readme.txt`自修改后还没有被放到暂存区，现在，撤销修改就回到和版本库一模一样的状态；

一种是`readme.txt`已经添加到暂存区后，又作了修改，现在，撤销修改就回到添加到暂存区后的状态。

总之，就是让这个文件回到最近一次`git commit`或`git add`时的状态。

如何放弃暂存区的文件，使用`git reset HEAD 文件名 `可以把暂存区的修改撤销掉（unstage），重新放回工作区 。   

#### 小结

又到了小结时间。

场景1：当你改乱了工作区某个文件的内容，想直接丢弃工作区的修改时，用命令`git checkout -- file`。

场景2：当你不但改乱了工作区某个文件的内容，还添加到了暂存区时，想丢弃修改，分两步，第一步用命令`git reset HEAD <file>  `，就回到了场景1，第二步按场景1操作。

场景3：已经提交了不合适的修改到版本库时，想要撤销本次提交，参考[版本回退](https://www.liaoxuefeng.com/wiki/896043488029600/897013573512192)一节，不过前提是没有推送到远程库。

## 分支管理

### 创建与合并分支

#### 创建、切换、查看分支

`git checkout -b dev` 或者`git switch -c dev`命令创建并切换分支到dev分支，相当于以下两条命令

```
$ git branch dev
$ git checkout dev
```

![分支1](分支1.png)

`git branch`命令查看分支,当前分支前多一个`*`

```
$ git branch
* dev
  master
```

在dev分支上进行提交

![分支3](C:\Users\180559\Desktop\note\分支3.png)

将分支切回主分支`git checkout master `，也可以使用`git switch master`

![](C:\Users\180559\Desktop\note\分支2.png)

此时查看文件内容， 还是dev分支提交前的内容，因为当前分支为master。

#### 合并、删除分支

`git merge dev` 将当前分支与dev分支进行合并。



![](C:\Users\180559\Desktop\note\分支4.png)

使用`git branch -d dev`合并完成后，就可以删除分支dev。

![](C:\Users\180559\Desktop\note\分支5.png)



### 解决冲突

当有冲突的两条分支如下图

![](C:\Users\180559\Desktop\note\分支6.png)

`git merge feature1`命令，Git无法执行“快速合并”出现

```
$ git merge feature1
Auto-merging readme.txt
CONFLICT (content): Merge conflict in readme.txt
Automatic merge failed; fix conflicts and then commit the result.
```

 Git告诉我们，`readme.txt`文件存在冲突，必须手动解决冲突后再提交。`git status`也可以告诉我们冲突的文件 

打开冲突文件修改冲突内容后再进行提交

```
$ git add readme.txt 
$ git commit -m "conflict fixed"
```

 现在，`master`分支和`feature1`分支变成了下图所示： 

![](C:\Users\180559\Desktop\note\分支7.png)

合并后， 可以删除feature1分支了。

### 分支管理策略

 通常，合并分支时，Git会用`Fast forward`模式，但这种模式下，删除分支后，会丢掉分支信息。 

 如果要强制禁用`Fast forward`模式，Git就会在merge时生成一个新的commit，这样，从分支历史上就可以看出分支信息。 

`git merge --no-ff -m "merge with no-ff" dev` 禁用快速模式，分支情况如下：

![](C:\Users\180559\Desktop\note\分支8.png)

#### 分支策略

在实际开发中，我们应该按照几个基本原则进行分支管理：

首先，`master`分支应该是非常稳定的，也就是仅用来发布新版本，平时不能在上面干活；

那在哪干活呢？干活都在`dev`分支上，也就是说，`dev`分支是不稳定的，到某个时候，比如1.0版本发布时，再把`dev`分支合并到`master`上，在`master`分支发布1.0版本；

你和你的小伙伴们每个人都在`dev`分支上干活，每个人都有自己的分支，时不时地往`dev`分支上合并就可以了。

所以，团队合作的分支看起来就像这样：

![](C:\Users\180559\Desktop\note\分支9.png)

#### 小结

Git分支十分强大，在团队开发中应该充分应用。

合并分支时，加上`--no-ff`参数就可以用普通模式合并，合并后的历史有分支，能看出来曾经做过合并，而`fast forward`合并就看不出来曾经做过合并。

### BUG分支

`git stash`命令保留工作区未提交及暂存区的文件并隐藏，清空工作区和暂存区的修改。 在自己的分支上进行工作到一半的时候需要修改BUG可以使用stash把工作现场“储存”起来。修改完BUG之后使用`git cherry-pick BUG分支提交id` 可以复制修改BUG所做的修改。

### feature分支

开发一个新feature，最好新建一个分支；

如果要丢弃一个没有被合并过的分支，可以通过`git branch -D `强行删除。

### 多人协作

- 查看远程库信息，使用`git remote -v`；
- 本地新建的分支如果不推送到远程，对其他人就是不可见的；
- 从本地推送分支，使用`git push origin branch-name`，如果推送失败，先用`git pull`抓取远程的新提交；
- 在本地创建和远程分支对应的分支，使用`git checkout -b branch-name origin/branch-name`，本地和远程分支的名称最好一致；
- 建立本地分支和远程分支的关联，使用`git branch --set-upstream branch-name origin/branch-name`；
- 从远程抓取分支，使用`git pull`，如果有冲突，要先处理冲突。

### Rebase

`git rebase`命令将远程pull下来的分叉分支整理成直线。

## 标签管理

### 创建标签

`git tag v1.0` 默认在当前分支最新的commit打标签。对历史版本打标签使用`git tag v0.9 <commit id>` ,`git show <tagname>`查看标签信息。`git tag -a v1.0 -m "version 1.0 release"`通过这种命令添加说明文字 

### 操作标签

#### 小结

- 命令`git push origin <tagname> `可以推送一个本地标签；
- 命令`git push origin --tags`可以推送全部未推送过的本地标签；
- 命令`git tag -d `可以删除一个本地标签；
- 命令`git push origin :refs/tags/`可以删除一个远程标签。

### Git取消对某个文件的跟踪

`git rm --cached <fileName>  `

fileName 为文件路径， 绝对相对路径均可

