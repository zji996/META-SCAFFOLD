# Rust 开发构建策略

当仓库包含 Rust 时，开发构建优先优化反馈延迟，生产构建再优化运行性能；不要把 `cargo run --release` 当作日常开发入口。

## 开发反馈循环

- **快速类型检查与局部验证**：优先使用 `cargo check`、增量编译和仓库已有的局部测试入口（如 `cargo test <module>`）。
- **链接器优化**：Linux 大型工程可评估使用 `mold` 或 `lld`，但不得假设所有开发或构建机已安装。
- **开发 profile 配置**：`profile.dev` 保持业务代码低优化。第三方依赖若在 `opt-level = 0` 下严重拖慢调试运行，可统一设为 `[profile.dev.package."*"] opt-level = 1`，仅对已确认的热点依赖单独提高优化级别。
- **中间 Profile**：可增加 `dev-fast` 等中间 profile（如 `opt-level = 2`），用于需要接近真实运行速度但仍保留调试信息的场景。

## 生产发布与后端真值

- **LLVM 作为真值后端**：LLVM 是 CI、基准测试和生产发布的真值后端；Cranelift 可作为本地 `run` / `test` 的可选快速路径，但不能替代 Stable LLVM 验证，也不得因项目含 `unsafe` 或 FFI 就直接判定不可用，应验证具体 intrinsic、SIMD、ABI 与平台支持。
- **正式 release 优化**：默认从 `opt-level = 3` 与 ThinLTO 开始；FatLTO、`codegen-units = 1`、`panic = "abort"`、`target-cpu = "native"` 等只在真实 benchmark 和部署约束支持时启用。
- **平台与系统依赖**：GPU、CUDA、C/C++、链接脚本或其他原生依赖项目优先保持 `*-unknown-linux-gnu` 等成熟生产目标；musl、UPX 和完全静态分发属于交付选择，不作为高性能服务默认方案。

## 测量优先

- 优化构建前先测量：区分类型检查、宏展开、单态化、codegen、链接、build script (`build.rs`) 与原生编译耗时，避免用盲目调整 profile 参数掩盖真正的依赖膨胀或宏展开瓶颈。
