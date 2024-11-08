# 初始化项目

mkdir front
cd front
pnpm init
pnpm add react react-dom
## 安装typescript
pnpm i typescript -D    // 安装typescript
pnpm i @types/react @types/react-dom @types/node -D // 安装react类型
## 安装webpack
pnpm i webpack webpack-cli webpack-dev-server -D // 安装webpack
pnpm i html-webpack-plugin -D // 安装html-webpack-plugin
pnpm i style-loader css-loader -D // 安装样式加载器
pnpm i copy-webpack-plugin -D // 安装copy-webpack-plugin
pnpm i ts-loader -D // 安装ts-loader和ts-node

## 配置tsconfig.json

## 配置webpack

### 创建index.html

## 支持导入图片

src/react-app-env.d.ts

```typescript
declare module "*.png";
declare module "*.svg";
declare module "*.jpeg";
declare module "*.jpg";
```

## store

pnpm add react-redux redux redux-thunk @reduxjs/toolkit
pnpm add @types/react-redux -D