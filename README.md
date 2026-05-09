# 云边的小镇 - 像素风个人网站

一个以像素风小镇为主视觉的个人网站项目。首页会把个人档案、作品展示、技术笔记、跑步训练、日志和联系入口组织成一张可探索的小镇地图。

![概念图](./概念图-白天.png)

## 当前阶段

当前仓库处于项目骨架初始化阶段，技术实现保持为原生 HTML + CSS + JavaScript：

- 不引入 React、Vue、Vite 或其他前端框架
- 不引入后端、数据库或依赖包
- 使用 ES modules 拆分数据、状态、页面层和建筑模块
- 首页保留概念图预览能力，方便后续视觉还原

## 首页四层结构

首页由四个主要层组成：

- `TopNavLayer`：头像、等级、经验、HP、体力、金币、宝石、导航入口和当前任务提示
- `BackgroundLayer`：小镇背景图、地图舞台比例、瀑布/草地/树木等动画预留
- `BuildingLayer`：建筑热区、hover、点击接口和后续建筑动画挂载点
- `OverviewLayer`：底部书本、展开/收起、最近动态、本周训练、天气和时钟

## 目录结构

```text
.
├── index.html
├── README.md
├── 概念图-白天.png
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
├── src/
│   ├── main.js
│   ├── state.js
│   ├── data/
│   │   ├── player.js
│   │   ├── buildings.js
│   │   ├── overview.js
│   │   └── navigation.js
│   ├── layers/
│   │   ├── topNavLayer.js
│   │   ├── backgroundLayer.js
│   │   ├── buildingLayer.js
│   │   └── overviewLayer.js
│   ├── modules/
│   │   ├── projectTavern.js
│   │   ├── notesHouse.js
│   │   ├── taskCabin.js
│   │   ├── runningField.js
│   │   ├── logStation.js
│   │   ├── githubHall.js
│   │   ├── mailbox.js
│   │   └── index.js
│   └── styles/
│       ├── base.css
│       ├── layout.css
│       ├── top-nav.css
│       ├── town-stage.css
│       ├── buildings.css
│       ├── overview.css
│       └── modules.css
```

## 文件职责

- `index.html`：网站入口，只负责页面挂载点、CSS 引入和 `src/main.js` 启动
- `src/main.js`：应用启动入口，初始化状态、渲染四大层、绑定基础事件
- `src/state.js`：维护 `currentScene`、`selectedBuilding`、`overviewOpen`
- `src/data/player.js`：顶部状态栏和个人卡片数据
- `src/data/buildings.js`：建筑入口数据，包括 `id`、`name`、`module`、`x`、`y`、`width`、`height`
- `src/data/overview.js`：底部概览数据
- `src/data/navigation.js`：顶部导航配置
- `src/layers/`：按首页层级拆分渲染逻辑
- `src/modules/`：每个建筑对应的内部模块，当前为占位内容
- `src/styles/`：按页面层和模块拆分样式

## 当前建筑入口

- `project-tavern`：项目酒馆
- `notes-house`：想法与笔记
- `task-cabin`：任务小屋
- `running-field`：跑步训练场
- `log-station`：日志站
- `github-hall`：GitHub
- `mailbox`：猫咪邮箱

## 本地预览

按当前仓库约定，只有明确需要预览时才启动本地 HTTP 服务。推荐在项目根目录运行：

```bash
python3 -m http.server 8000 --bind 127.0.0.1
```

然后访问：

```text
http://127.0.0.1:8000/
```

如果当前 shell 找不到 `python3`，先提供可执行文件完整路径，再使用相同的 `http.server` 命令。

## Git 分支约定

当前初始化流程：

- `main`：稳定分支
- `dev`：开发集成分支
- `feature/project-setup`：本次项目骨架初始化分支

本次初始化不会合并到 `main`。后续建议从 `dev` 创建新的功能分支继续推进。

## 后续建议

建议下一个功能分支：

```text
feature/town-stage-layout
```

建议范围：

- 根据 `概念图-白天.png` 调整小镇舞台比例
- 将背景场景从占位 CSS 逐步替换为真实像素图素材
- 精准定位建筑热区
- 补充 hover、点击反馈和基础响应式行为

## 长期方向

项目愿景是把个人网站做成一个长期生长的小世界。代码、文章、项目、跑步和生活状态都能在小镇里留下痕迹，让访问者看到的不只是简历，而是一个持续行动中的开发者。
