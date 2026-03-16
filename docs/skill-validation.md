# Skill 校验机制

本文定义 `rtl-remote-vcs-wave` 的最低校验要求，确保该 skill 不只是“有文档”，而是真能用于新模块验证平台搭建。

## 校验目标

至少覆盖三层：
- 结构校验：目录、模板、文档、脚本是否齐全
- 内容校验：模板引用关系是否自洽
- 流程校验：用户是否能按 skill 描述走通“生成 -> 修改 -> 编译 -> 仿真 -> 分析”闭环

## 当前可自动化的校验项

### 1. 文件完整性
- 必需的 reference 文档存在
- 必需的 UVM 骨架文件存在
- 必需的脚本存在且可执行

### 2. 模板一致性
- `tb_top.sv` 中引用的 `include` 文件必须存在
- `sim/rtl.list` 中涉及的目录必须存在
- `Makefile` 中引用的 filelist 与 top 必须存在

### 3. 基础命名替换
- 模板生成后不应残留 `module_name` 这类占位符
- 生成后的工程名称、顶层名、test 名称应可识别

### 4. 仿真结果判据
若用户实际执行仿真，建议至少检查：
- 编译日志无致命错误
- `simv` 生成成功
- `*.fsdb` 存在
- 日志中 `UVM_ERROR` / `UVM_FATAL` 为 0
- scoreboard 输出 error count 为 0

## 推荐执行方式

### 只做静态校验
```bash
python3 skills/rtl-remote-vcs-wave/scripts/validate_skill.py
```

### 生成一个新模板工程
```bash
python3 skills/rtl-remote-vcs-wave/scripts/create_uvm_scaffold.py demo_fifo --module fifo_core --out /tmp/demo_fifo
```

### 对生成结果做静态检查
```bash
python3 skills/rtl-remote-vcs-wave/scripts/validate_skill.py --project /tmp/demo_fifo
```

## agent 行为要求

当用户要求“直接套模板”时，agent 不应只复制文件，而应在交付前至少跑一遍静态校验，并把结果汇总给用户：
- 校验通过项
- 未完成替换项
- 需要用户补充的 DUT 接口/协议信息


## 动态校验

当远端环境可用时，建议继续执行动态校验：

```bash
bash skills/rtl-remote-vcs-wave/scripts/run_remote_uvm_smoke.sh   --remote eda01   --workdir /nfs/home/USER/project/demo_fifo   --testname smoke_test
```

动态校验重点验证：
- 远端环境变量是否带起
- `make comp` / `make sim` 是否成立
- `simv`、`tb.fsdb` 是否生成
- UVM 错误统计与 scoreboard 摘要是否满足通过条件
