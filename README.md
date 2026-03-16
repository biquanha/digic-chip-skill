# digic-chip-stdlib

面向数字芯片验证场景的开源标准库。加载 skill 后，可以直接用于新模块 UVM 验证平台搭建、远端 EDA 仿真、FSDB 波形分析与验证流程规划。

## 你可以直接怎么用

如果你的目标是下面这些场景，可以直接使用本仓库：
- 为一个新的 RTL 模块搭建 UVM 验证平台
- 在远端 EDA 节点上跑 VCS/Verdi/FSDB flow
- 对已有工程做 smoke 验收、日志检查、波形摘要分析
- 为团队沉淀一套可交接、可维护的验证流程

主入口：`skills/rtl-remote-vcs-wave/SKILL.md`

## 最常见的使用方式

### 1. 新模块起步
当你拿到一个新的 DUT，想先搭一个最小可运行的 UVM 平台时，使用主 skill，并按其中的模板入口开始：
- `skills/rtl-remote-vcs-wave/SKILL.md`
- `skills/rtl-remote-vcs-wave/assets/uvm-scaffold/README.md`

### 2. 远端仿真与波形分析
当你已经有 RTL/testbench，想在远端节点上完成编译、仿真、FSDB 导出和波形摘要时，使用：
- `skills/rtl-remote-vcs-wave/SKILL.md`

### 3. 工程校验
当你已经生成了模板工程，或者想确认 skill 当前是否完整可用时，使用：
- `docs/skill-validation.md`

### 4. 企业级流程规划
当你不只是想“跑通”，而是想把平台做成可回归、可交接、可维护的正式验证平台时，使用：
- `docs/enterprise-uvm-roadmap.md`
- `docs/eda-tool-matrix.md`

## 面向使用者的主要入口

### 主 skill
- `skills/rtl-remote-vcs-wave/SKILL.md`

### 主要说明文档
- Skill 校验说明：`docs/skill-validation.md`
- 企业级路线图：`docs/enterprise-uvm-roadmap.md`
- EDA 工具矩阵：`docs/eda-tool-matrix.md`

## 这个仓库里有什么

### 对使用者最重要的
- 主 skill：告诉你遇到什么场景该怎么走
- 模板：让你能快速起一个新模块 UVM 平台
- 文档：告诉你怎么规划 testcase、coverage、RAL、scoreboard、回归、交接

### 对 Agent / 自动化更有帮助的
- 骨架生成脚本
- 静态校验脚本
- 远端 smoke 验收脚本
- EDA 工具探测脚本

这些脚本已经包含在仓库里，但如果你是普通使用者，不需要先理解所有脚本细节，只需要从主 skill 和说明文档进入即可。

## 当前覆盖的核心能力

- 新模块 UVM 骨架搭建
- 远端 VCS/Verdi/FSDB flow
- FSDB 摘要分析
- smoke 验收与静态校验
- testcase 分层规划
- reference model / scoreboard 设计
- RAL 接入规划
- coverage 与回归思路
- 断言、交接、维护与工具扩展建议
