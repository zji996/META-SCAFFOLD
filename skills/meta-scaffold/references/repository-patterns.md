# Repository Patterns

仅在初始化、重组、文档治理、多服务或多实例任务中读取。模式是候选，不是默认。

## 结构

用部署边界、所有权、依赖方向和验证成本判断：

- 独立运行/构建/部署 → `apps/` 或 `services/`
- 多单元共享且不依赖具体 app → `packages/` 或 `libs/`
- 单消费者且无稳定复用 → 留在消费者内
- 需原子改动、共享契约、统一验证 → monorepo；独立发布或强隔离 → polyrepo

边界变化须同时说明依赖、构建、测试和发布影响。

## 设计沙盒

设计需要快速试错、生产功能需要真实 auth/API/状态时，可建立独立开发态 app/build：

- 一个 sandbox 包可按产品面提供多个画布（如 `/web/`、`/console/`）；场景使用本地 mock，有限交互只服务设计判断。
- 依赖方向保持单向隔离：sandbox 不 import 生产业务模块，生产 app 不 import sandbox；稳定且真实复用的 token/原子组件才进入既有共享边界，不为少量样式提前造 package。
- 开发生命周期应可脱离后端独立启动，并提供稳定入口或明确直连地址；生产镜像、静态托管、导航和发布任务显式排除 sandbox。
- Sandbox 的 typecheck/build/Playwright 只证明设计稿可运行；产品完成仍由生产 app 的 API、权限、状态与端到端验证证明。
- 评审快照记录 viewport、场景状态、关键交互、mock 假设与源码 revision；用独立入口、页面元数据和快照说明记录 design/mock 身份，默认不在截图画布上叠加工具栏、水印或画布切换器。截图是视觉基线，不是完整行为契约。

## 文档

按需增加，不一次铺齐：

- `AGENTS.md`：项目特有约束、命令、上下文入口（含本仓授权/commit 纪律）
- `docs/current.md`：近期焦点，建议 ≤5 个下一步
- `docs/reference/`：当前架构事实
- `docs/decision/`：需保留理由的方向决策；可加短 INDEX
- `docs/roadmap.md`：未来方向

首次把既有隐含决策写成 ADR：可直接整理并提示 review；引入新方向决策仍按项目确认规则。

## 本地产物

持久但不入库的产物可放 `.local/` 并整体 ignore；子目录沿用项目命名（如 `run/`、`plan/`、`backlog/`）。长目标可在 `.local/plan/plan.md` 顶部维护焦点与 checklist；稳定事实回 current/reference/ADR。

异步委派不稳定 sub-agent 时，可写 `.local/backlog/<slug>.md` 后继续主线；不探活、不等待、不降级自干。

## 多服务编排

常驻多服务时，在已有命令入口封装 build/start/stop/status/logs 并记录 pid；避免裸后台命令。工具与目录服从仓库现状。

## 多实例端口

目的：同一主机并行项目或同项目多实例时不争抢资源，且入口、门禁、隧道与文档读取同一份已解析事实。

**默认优先序**（与 SKILL「本机多项目入口：Caddy 域名优先」一致；远程 + FRP 见下节）：

1. **HTTP UI/API（同机浏览器）**：一台开发机只保留一个系统级反向代理（如 Caddy）+ 每项目独立 site + 稳定 `*.localhost`（或路径命名空间）。人类/agent 日常只记域名；`up/down/pause` 注册或注销 site 并 reload。跨项目防冲靠域名，不靠全仓统一端口偏移。
2. **临时本地服务**：请求内核/Docker 分配宿主端口（如监听 `127.0.0.1:0`、Compose `published: 0`）。应用把 bind 后的真实地址写入 `.local/`，编排器通过 socket 地址或 `compose port` 读取；不要先扫描空闲端口再释放后启动（竞态）。
3. **必须启动前可预测的端口**（SSH 隧道、**FRP**、外部回调、防火墙、人工连接）：才引入 profile 级实例前缀。可用派生：实例前缀 + 默认端口「首位 + 末两位」（如实例 `12`：8080→12880、5432→12532、9000→12900），同时检测碰撞和 65535 上限。有 Caddy 域名的浏览器入口 **不要**退化成「全体服务统一偏移段」作为主叙事。远程 + FRP 时，可预测的是**少数 UI 口**（与隧道 `local_port` 对齐），不是整仓偏移。

反向代理是入口，不负责数据库、Redis 或任意进程的端口分配，也不要每个项目各占一套 80/443。upstream / DB / 缓存端口 **只要本机不冲突即可**（固定默认或 env 覆盖均可）。

所有模式都应满足：

- 只改变宿主暴露端口，容器内端口与服务发现名称稳定。
- 提供 `ports` / `urls` / `status` 自省：区分稳定 Web 域名入口、动态 Backend、数据库、缓存和隧道端点；停干净后勿把域名表展示成「已可访问」。
- 检查脚本、健康检查、文档和 curl 示例：浏览器路径读域名；诊断/设备直连才读最终端口，不把偏移方案写进日常入口文档。
- PID 存活不代表端口规格仍匹配；固定规格或 SSH 隧道变化后重建长连接。
- 动态地址文件属于可重建运行态，不是配置事实来源；异常退出后不得继续展示过期入口。
- 表内端口重复或解析值 >65535 时检查失败；本机已监听只标占用，不当作门禁失败。

## 远程开发与 FRP

适用：进程跑在远程机（GPU 箱、Cursor SSH Remote），浏览器在笔记本或公网；习惯公网 Caddy + FRP。不要拆第二套 skill。

不要把本机 `*.localhost` 当远程日常入口：笔记本解析的是自己的 localhost，不是 GPU 箱。公网那台 Caddy 才是入口。

```text
浏览器 --HTTPS--> 公网 Caddy（真域名、TLS、flush_interval -1）
                      |
                    FRP tcp
                      |
远程进程机  0.0.0.0:<ui-port>  静态 nginx/edge；每口同源 /v1 → 本机 API
```

- 公网只打需要给人打开的 UI 口（常见：用户端 + 运营后台各一口）。每口同源反代 `/v1`（及 healthz）；不要再为公网单独开 CORS。
- 不要 FRP：API 直端口、worker、推理进度口（如 `PORT+10`）、postgres、redis、Vite。
- FRP `local_ip` 用进程机局域网 IP，不要 `127.0.0.1`（对端连不上 loopback）。
- **公网默认静态 edge**：与 `dev-up` **同端口、不同形态**（停 Vite，nginx 占同一套 UI 口），隧道配置不用改。二者互斥。改前端必须经项目命令入口重建并 reload（`manage.sh edge rebuild` / `make edge-rebuild`）；保存源码不会出现在公网包里。回到热改：停 edge，重启 Vite，用 Cursor 端口转发或内网 IP。
- **不要把 Vite 挂上公网 FRP**（HMR、`/src`、sourcemap、`allowedHosts`）。agent 排障「样式没变」时，先问浏览器走的是公网静态包还是转发中的 Vite。
- 远程机不要再装一套系统 Caddy 当日常入口；可生成 site 片段给**公网** Caddy 用（host、body size、SSE flush），不要擅自写 `/etc/caddy`，也不要把公网 TLS 终止放到 GPU 箱。
- `urls` 列公网域名；`ports` 诊断进程机监听。停干净后勿把公网表展示成已可访问。
