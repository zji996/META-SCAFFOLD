# AGENTS.md

## META-SCAFFOLD

把本节作为 AI coding agent 的项目治理契约。

默认中文协作和编写项目交接文档，除非用户另有要求，或仓库已经明确使用其他语言。

核心协议：

```text
Inspect -> Frame -> Decide -> Preview -> Apply -> Verify -> Handoff -> Compact
```

当任务涉及仓库结构、项目治理、AI 交接、文档布局、monorepo 边界、上下文压缩或验证流程：

1. 修改文件前先检查真实仓库。
2. 非简单任务先说明目标、假设、成功标准和非目标。
3. 只对高影响歧义提问；低风险歧义使用安全默认值继续。
4. 重大改动前先 Preview。
5. 只修改任务所需文件。
6. 使用已有命令验证，或说明为什么无法验证。
7. 交接时说明变更文件、验证结果、风险和下一轮起点。
8. 保持 `docs/current.md` 简洁，只记录仍会影响未来工作的内容。

仓库结构规则：

- 可以按 monorepo 边界思考，但只创建当前需要的目录。
- `apps/` 放可独立运行、构建或部署的单元。
- `packages/` 或 `libs/` 放共享代码。
- 默认依赖方向：允许 `apps/* -> packages/*`；禁止 `packages/* -> apps/*`；默认禁止 `apps/A -> apps/B`。
- 跨 app 协作应使用 HTTP、RPC、queue、event、schema、protobuf 或 contracts package，而不是直接 import。

文档规则：

- 最小有用文档：`docs/current.md`、`docs/roadmap.md`、`docs/reference/architecture.md`。
- `docs/current.md` 是当前协作上下文，不是聊天记录。
- `docs/reference/` 只写当前事实。
- 未来计划写入 roadmap/current，不得写成已实现事实。

验证规则：

- 优先使用已有命令，例如 `pnpm lint`、`pnpm typecheck`、`pnpm test`、`pnpm build`、`make check`、`just check`、`task check` 或 `./manage.sh check all`。
- README、AGENTS、CI 和 AI 交接应指向同一组命令。
- 不要用 silent fallback 掩盖失败。

避免：

- 为了显得完整而创建空目录；
- 过度拆分文档；
- 把一个请求拆成许多微任务；
- 顺手重构或格式化无关文件；
- 未批准就移动、删除或覆盖未知文件；
- 把共享库放进 `apps/`；
- 让共享包依赖 apps。
