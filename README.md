# digic-chip-stdlib

面向数字芯片验证场景的开源标准库，提供新 RTL 模块 UVM 骨架、远端 EDA 仿真流程、FSDB 波形分析、验收校验，以及企业级验证方法沉淀。

## 这是什么

`digic-chip-stdlib` 是一套围绕数字芯片验证工作的标准化资产集合。

它不是单一 demo，也不是只靠 prompt 工作的说明仓库，而是把数字验证中常见的模板、脚本、校验方法和流程文档沉淀下来，帮助使用者更快地启动和维护验证平台。

主入口：`skills/rtl-remote-vcs-wave/SKILL.md`

## 这能做什么

当前仓库主要覆盖以下能力：
- 为新模块搭建最小可运行的 UVM 骨架
- 在远端 EDA 节点执行 VCS/Verdi/FSDB 仿真与波形分析
- 对 skill 本身和生成工程做静态校验
- 对工程执行 smoke 验收与日志摘要检查
- 规划 testcase、coverage、reference model、scoreboard、RAL、断言、回归与交接流程
- 为企业级验证平台提供路线图和工具矩阵

核心能力包括：
- 新模块 UVM 骨架搭建
- 远端 VCS/Verdi/FSDB flow
- FSDB 摘要分析
- smoke 验收与静态校验
- testcase 分层规划
- reference model / scoreboard 设计
- RAL 接入规划
- coverage 与回归思路
- 断言、交接、维护与工具扩展建议

## 这怎么用

### 主入口
- `skills/rtl-remote-vcs-wave/SKILL.md`

### Claude 插件方式加载
```bash
/plugin marketplace add biquanha/digic-chip-skill
/plugin install digic-chip-skill@biquanha
```

### Codex / 本地仓库方式使用
直接进入仓库后，从主 skill 开始：
```bash
cd digic-chip-stdlib
```

然后阅读：
```bash
skills/rtl-remote-vcs-wave/SKILL.md
```

### 生成一个新模块 UVM 骨架
```bash
python3 skills/rtl-remote-vcs-wave/scripts/create_uvm_scaffold.py demo_fifo --module fifo_core --out /tmp/demo_fifo
```

### 校验当前 skill
```bash
python3 skills/rtl-remote-vcs-wave/scripts/validate_skill.py
```

### 校验生成后的工程
```bash
python3 skills/rtl-remote-vcs-wave/scripts/validate_skill.py --project /tmp/demo_fifo/demo_fifo
```

### 探测当前机器上的 EDA 工具
轻量探测：
```bash
bash skills/rtl-remote-vcs-wave/scripts/probe_eda_tools.sh --skip-module-avail --output /tmp/eda_probe.txt
```

完整探测：
```bash
bash skills/rtl-remote-vcs-wave/scripts/probe_eda_tools.sh --output /tmp/eda_probe.txt
```

## 主要文档
- 主 skill：`skills/rtl-remote-vcs-wave/SKILL.md`
- Skill 校验说明：`docs/skill-validation.md`
- 企业级路线图：`docs/enterprise-uvm-roadmap.md`
- EDA 工具矩阵：`docs/eda-tool-matrix.md`
