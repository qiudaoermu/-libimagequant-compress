## libimagequant-compress

```
compress png write by c, lodepng,libimagequant
```

## use

```
make
```

## invokes

```
./main_unix
```

## invokes by node.js

```
const path = require("path");
// 获取根目录路径
const rootPath = path.resolve(__dirname);

// 构建完整的文件路径
const filePath = path.join(rootPath, "main.js");

let compress = require(filePath);
compress("./assets/input.png");
```
