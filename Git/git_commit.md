查看commit

```
$ git log
```

查看最新commit信息

```
$ git show
```

查看某条commit消息

```
$ git show commit_id
```


回滚提交

```
$ git reset 
```

此次提交之后的修改会被退回到暂存区

```
$ git reset --soft
```

此次提交之后的修改不做任何保留，git status 查看工作区是没有记录

```
$ git reset --hard
```

### 回滚代码

如果需要删除的 commit 是最新的，那么可以通过 git reset 命令将代码回滚到之前某次提交的状态，但一定要将现有的代码做好备份，否则回滚之后这些变动都会消失。具体操作如下：

```
$ git log // 查询要回滚的 commit_id
$ git reset --hard commit_id // HEAD 就会指向此次的提交记录
$ git push origin HEAD --force // 强制推送到远端
```

### 误删恢复

如果回滚代码之后发现复制错了 commit_id，或者误删了某次 commit 记录，也可以通过下方代码恢复：

```
$ git relog // 复制要恢复操作的前面的 hash 值
$ git reset --hard hash // 将 hash 换成要恢复的历史记录的 hash 值
```

注意：删除中间某次提交时最好不要用 git reset 回退远程库，因为之后其他人提交代码时用 git pull 也会把自己的本地仓库回退到之前的版本，容易出现差错进而增加不必要的工作量。

git rebase：当两个分支不在一条线上，需要执行 merge 操作时使用该命令。

### 撤销提交

如果中间的某次 commit 需要删除，可以通过 git rebase 命令实现，方法如下：

```
$ git log // 查找要删除的前一次提交的 commit_id
$ git rebase -i commit_id // 将 commit_id 替换成复制的值
$ 进入 Vim 编辑模式，将要删除的 commit 前面的 `pick` 改成 `drop`
$ 保存并退出 Vim
```

这样就完成了。

### 解决冲突

该命令执行时极有可能出现 reabase 冲突，可以通过以下方法解决：

```
$ git diff // 查看冲突内容
$ // 手动解决冲突（冲突位置已在文件中标明）
$ git add <file> 或 git add -A // 添加
$ git rebase --continue // 继续 rebase
$ // 若还在 rebase 状态，则重复 2、3、4，直至 rebase 完成出现 applying 字样
$ git push
```

> git revert：放弃某次提交。
> git revert 之前的提交仍会保留在 git log 中，而此次撤销会做为一次新的提交。
> git revert -m：用于对 merge 节点的操作，-m 指定具体某个提交点。

### 撤销提交

要撤销中间某次提交时，使用 git revert 也是一个很好的选择：

1. git log // 查找需要撤销的 commit_id
2. git revert commit_id  // 撤销这次提交

撤销 merge 节点提交

如果这次提交是 merge 节点的话，则需要加上 -m 指令：

```
$ git revert commit_id -m 1 // 第一个提交点
$ // 手动解决冲突
$ git add -A
$ git commit -m ""
$ git revert commit_id -m 2 // 第二个提交点
$ // 重复 2，3，4
$ git push
```


