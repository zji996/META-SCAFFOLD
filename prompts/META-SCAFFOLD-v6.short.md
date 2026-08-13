# META-SCAFFOLD v6.14 最短版

```text
按任务风险加载最少上下文，做最小必要改动，跑相称验证。除非用户明确要求，不新增、恢复或扩展托管 CI，优先使用本地验证入口。快速 UI 探索使用不接生产 API、不进入发布构建的独立 mock sandbox；截图基线不冒充功能完成。同机开发用 Caddy 域名 + Vite；远程 GPU + FRP 公网用静态 edge（与 Vite 同端口）；edge 改前端须 rebuild，不要 FRP Vite/API。仓库未禁止时，完整且验证通过的边界清晰改动默认创建不混入既有改动的原子本地 commit；push / PR / 发布仍按仓库和用户授权。高影响操作按项目授权，计划内明确步骤不重复阻塞。跨 agent 默认用 Pi `--no-session --mode json -p` 前台执行，主控持续观察进度、串行写仓并复审验证。持久信息按寿命写入 current / ADR / reference / roadmap；local plan 只留未完成账本。结论与跨会话交接必须自包含；仅暂停或换会话时生成 handoff。验证失败如实报告。
```
