# vue-run

> 这是一个支持`Vue`和`Element`组件库在线运行的工具

可以利用本工具运行一些小demo, 无需搭环境, 将代码粘贴过来, 即可执行。支持Vue版本和Element版本的切换。

[项目预览](https://run.fzliang.cn) 

## 项目安装
```
yarn install
```

### 项目运行
```
yarn run serve
```

### 项目编译
```
yarn run build
```

### 本地docker运行

```bash
docker build -t vue-run .

docker run -i -t -p 5000:80 vue-run
```

访问`http://localhost:5000`就可以访问了