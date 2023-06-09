# prettier+eslint 校验+commit 规范 接入方案

## 代码格式化规范配置

[prettier](https://prettier.io/)

1. 安装依赖
   ```sh
     npm install --save-dev --save-exact prettier
     // or
     yarn add --dev --exact prettier
   ```
2. 创建一个空配置文件，让编辑器和其他工具知道你正在使用 Prettier

   ```sh
   echo {}> .prettierrc.json
   ```

3. 创建一个.prettierignore 文件，让 Prettier CLI 和编辑器知道哪些文件不能格式化，example：

   ```sh
     # Ignore artifacts:
     dist
     build
     coverage
   ```

4. IDE 中安装 **Prettier-Code Formater** 插件
5. vscode 设置 "editor.formatOnSave": true,
   Ctrl + S 保存代码时，插件就会帮助我们自动格式化了

## git 阶段检查提交消息、运行测试、检查代码等

1. 安装 husky 和 ​​lint-staged：

- husky 是一个 git hook 工具，可以帮助我们触发 git 提交的各个阶段：pre-commit、commit-msg、pre-push

  ```sh
    npm install --save-dev husky lint-staged
    npx husky install
    npm set-script prepare "husky install"
    npx husky add .husky/pre-commit "npx lint-staged"
    // or
    yarn add --dev husky lint-staged
    npx husky install
    npm set-script prepare "husky install"
    npx husky add .husky/pre-commit "npx lint-staged"

  ```

2. 然后将以下内容添加到 package.json 中

- 这段配置的意思是：当执行 git commit 阶段前，先执行 lint-staged，lint-staged 中的内容就是对暂存区的文件执行格式化的命令。
  ```json
  {
    "lint-staged": {
      "**/*": "prettier --write --ignore-unknown"
    }
  }
  ```

## 代码语法规范配置 JS/TS 规范

1. 安装依赖

```js
  npm install eslint --save-dev
  // or
  yarn add eslint --dev
```

2. 生成配置文件

```js
  npm init @eslint/config
  // or
  yarn create @eslint/config
```

```js
  Need to install the following packages:
  @eslint/create-config@0.4.2
  Ok to proceed? (y) y
  ? How would you like to use ESLint? …
    To check syntax only
  ❯ To check syntax and find problems
    To check syntax, find problems, and enforce code style
```

- To check syntax only
  - 仅检查语法 它可以帮助您更正语法并确保它符合标准
- To check syntax and find problems
  - 检查语法，发现问题和强制风格，强制风格意味着符合特定的编码标准，如 Airbnb，谷歌和其他标准编码风格。
- To check syntax, find problems, and enforce code style
  - 即带有语法的选项，发现问题并强制执行代码风格

```js
    What type of modules does your project use? …
  ❯ JavaScript modules (import/export)
    CommonJS (require/exports)
    None of these
```

- JavaScript modules (import/export)
  - Javascript 模块（导入/导出） 如果你的项目安装了 babel 那么你肯定需要选择这个选项。如果你在做 React、Vue、Angular 等项目，他们都使用 babel，所以你需要选择这个选项。
- CommonJS (require/exports)
  - 此选项适用于与 babel 无关的 commonJS，可能是你的 nodejs 项目和任何其他 javascript 项目

```js
  ? Which framework does your project use? …
❯ React
  Vue.js
  None of these
```

> 注意： 这里如果选用的 Typescript，则会默认使用@typescript-eslint/parser 解析器，官方为了追求更快的解析速度，并不会对.ts 文件中的类型进行检查，只会做语法检测。
> 如果需要对类型也进行检测，需要在.eslintrc.js > extends 中加上 plugin:@typescript-eslint/recommended-requiring-type-checking。 3. git commit 阶段校验，若不通过则取消提交。

```json
    "lint-staged": {
      "**/*": "prettier --write --ignore-unknown", //格式化
      "src/*": "eslint --ext .js,.ts,.tsx"  //进行eslint校验
    }
```

## prettier 与 eslint 冲突解决

- eslint 与 prettier 应该各司其职。eslint 负责我们的代码质量，prettier 负责我们的代码格式。但是在使用的过程中会发现，由于我们开启了自动化的 eslint 修复与自动化的根据 prettier 来格式化代码。所以我们已保存代码，会出现屏幕闪一起后又恢复到了报错的状态。
- 这其中的根本原因就是 eslint 有部分规则与 prettier 冲突了，所以保存的时候显示运行了 eslint 的修复命令，然后再运行 prettier 格式化，所以就会出现屏幕闪一下然后又恢复到报错的现象。这时候你可以检查一下是否存在冲突的规则。
- 查阅资料会发现，社区已经为我们提供了一个非常成熟的方案，即 **eslint-config-prettier** + **eslint-plugin-prettier**。

```sh
  npm i eslint-plugin-prettier eslint-config-prettier -D
```

- 在.eslintrc.js 中 extends 的最后添加一个配置: **plugin:prettier/recommended**

```js
  module.exports = {
  ...
  extends: [
    'standard-with-typescript',
    + // 必须放在最后面
    + 'plugin:prettier/recommended'
  ],
  ...
}
```

## Git commit 规范

> git commit 规范主要可以帮助开发人员在 code review 期间更容易理解提交的内容，现在大部分主流 commit 规范都是基于 Angular 团队的规范而衍生出来的，它的 message 格式如下：

```shell
 <type>(<scope>): <subject>
 <BLANK LINE>
 <body>
 <BLANK LINE>
 <footer>
```

type 主要有以下几种类型：

- feat: 一个新特性
- fix: 修复 bug
- docs: 文档修改
- style: 不影响代码含义的更改（空格、格式、缺少分号等）
- refactor: 代码重构
- perf: 优化性能
- test: 测试用例修改
- chore: 对构建过程或辅助工具和库的更改，例如文档生成

- scope：可以是影响范围的任何内容。
- subject：包含对更改的简洁描述，规则：
  - 使用陈述语句
  - 第一个字母不要大写
  - 末尾没有点 (.)
- body：commit 具体修改内容, 可以分为多行，应该包括改变的动机，并与以前的行为进行对比。
- footer: 一些备注, 通常是修复的 bug 的链接。

1. 安装 commitlint cli 和 conventional config

```js
npm install --save-dev @commitlint/{config-conventional,cli}
```
