列出所有分支
```
$ git branch -a
```

创建分支
```
$ git branch dev
```

切换分支
```
$ git checkout dev
```

合并dev分支到master
```
$ git merge dev
```

删除dev分支
```
$ git branch -d dev
```

初始化git
```
$ git -bare init
```

查看远程origin
```
$ git remote -v
```

删除远程origin
```
$ git remote rm origin
```

添加远程origin
```
$ git remote add origin git@github.com:R1turn0/NoteStudy.git
```
第一次push的时候需要加上u
```
$ git push -u origin master
```

修改命令
```
git remte origin set-url URL
```
