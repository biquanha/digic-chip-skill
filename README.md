# digic-chip-stdlib

面向数字芯片验证的开源标准库，提供新 RTL 模块的远端 EDA 流程、UVM 骨架、波形分析、验收校验，以及企业级验证方法沉淀。

## 定位

`digic-chip-stdlib` 不是单纯的 UVM demo，也不是只给 AI 用的 prompt 仓库。

它的目标是把数字芯片验证中最常见、最容易重复劳动的部分沉淀成一套可复用的工程资产：
- 可直接套用的 UVM 骨架模板
- 可直接执行的远端仿真与校验脚本
- 可逐步扩展的企业级验证流程文档
- 可交接、可维护、可回归的标准化方法库

适用对象：
- 数字验证工程师
- 新模块验证平台搭建者
- 需要做团队规范沉淀的验证负责人
- 希望让 Agent/Claude/Codex 辅助落地验证工作的使用者

## 当前能力

### 1. 新模块 UVM 平台快速起步
- 为新 RTL 模块生成最小可运行的 UVM 骨架
- 提供 interface、transaction、driver、monitor、agent、env、scoreboard、coverage、RAL 等模板
- 支持从“先跑通”逐步演进到“可回归、可交接”的平台

### 2. 远端 EDA 仿真闭环
- 支持远端 `VCS` 编译与仿真
- 支持 `Verdi` / `FSDB` / `fsdbreport` 波形分析
- 支持远端 smoke 验收与日志摘要

### 3. 企业级验证方法沉淀
- 测试计划与用例分层
- reference model / scoreboard 设计
- RAL 接入规划
- coverage 规划与收敛
- 断言、回归、交接维护
- EDA 工具链扩展与适配策略

### 4. 工具链适配能力
已沉淀对以下工具流的接入规划：
- `Synopsys VCS`
- `Synopsys Verdi`
- `SpyGlass`
- `Formality`
- `PrimeTime`
- `Xcelium`
- `Questa`
- `Genus`
- `Innovus`

## 典型使用场景

### 场景 1：新模块第一版 UVM 平台
适合：
- 新拿到一个 DUT
- 需要快速搭出最小可运行验证平台
- 希望后续能平滑扩展成正式项目平台

### 场景 2：远端节点仿真与波形分析
适合：
- 本地环境不完整
- 需要在 EDA 节点上编译、仿真、导出 FSDB
- 需要快速看日志和波形摘要

### 场景 3：企业内部验证标准化
适合：
- 团队要统一目录结构、脚本入口、验收口径
- 新人接手项目成本高
- 老平台可维护性差

### 场景 4：Agent 辅助数字验证工作
适合：
- 希望让 Claude/Codex 等工具帮助规划验证流程
- 让 Agent 自动生成骨架、检查日志、组织回归入口
- 但又不希望流程完全依赖高级 AI

## 仓库结构

- `skills/`：面向 Agent 或人类使用者的技能与流程说明
- `docs/`：仓库级说明、路线图、工具矩阵、校验说明
- `scripts/`：仓库级或 skill 内的辅助脚本

当前核心 skill：
- `skills/rtl-remote-vcs-wave`：围绕远端编译仿真、FSDB 波形分析，以及新模块 UVM 平台搭建的主技能

## 快速开始

### 1. 安装插件

```bash
/plugin marketplace add biquanha/digic-chip-skill
/plugin install digic-chip-skill@biquanha
```

如需开发分支：

```bash
/plugin marketplace add biquanha/digic-chip-skill#dev
```

### 2. 读取主 skill

主入口：`skills/rtl-remote-vcs-wave/SKILL.md`

### 3. 生成一个新模块 UVM 骨架

```bash
python3 skills/rtl-remote-vcs-wave/scripts/create_uvm_scaffold.py demo_fifo --module fifo_core --out /tmp/demo_fifo
```

### 4. 校验 skill 本身

```bash
python3 skills/rtl-remote-vcs-wave/scripts/validate_skill.py
```

### 5. 校验生成后的工程

```bash
python3 skills/rtl-remote-vcs-wave/scripts/validate_skill.py --project /tmp/demo_fifo/demo_fifo
```

### 6. 探测当前机器上的 EDA 工具

轻量探测：

```bash
bash skills/rtl-remote-vcs-wave/scripts/probe_eda_tools.sh --skip-module-avail --output /tmp/eda_probe.txt
```

完整探测：

```bash
bash skills/rtl-remote-vcs-wave/scripts/probe_eda_tools.sh --output /tmp/eda_probe.txt
```

## 关键入口

### 主 skill
- `skills/rtl-remote-vcs-wave/SKILL.md`

### 主要脚本
- UVM 骨架生成：`skills/rtl-remote-vcs-wave/scripts/create_uvm_scaffold.py`
- 静态校验：`skills/rtl-remote-vcs-wave/scripts/validate_skill.py`
- 远端基础仿真：`skills/rtl-remote-vcs-wave/scripts/run_remote_vcs_fsdb.sh`
- 远端 UVM smoke 验收：`skills/rtl-remote-vcs-wave/scripts/run_remote_uvm_smoke.sh`
- EDA 工具探测：`skills/rtl-remote-vcs-wave/scripts/probe_eda_tools.sh`

### 核心文档
- Skill 校验说明：`docs/skill-validation.md`
- 企业级路线图：`docs/enterprise-uvm-roadmap.md`
- 工具矩阵：`docs/eda-tool-matrix.md`

## 这个仓库不是什么

为了避免定位误解，这个仓库当前不是：
- 商用 VIP 产品
- 大而全的协议验证平台集合
- 某一个固定项目的私有脚手架
- 只靠 prompt 工作的 AI 仓库

它更像是：
- 数字芯片验证标准库
- UVM 平台脚手架仓库
- 企业级验证流程知识库
- 可供 Agent 和工程师共同使用的方法资产库

## 适合怎样的团队

这个仓库尤其适合：
- 想把验证流程沉淀下来，而不是每次从零开始的团队
- 有远端 EDA 环境，需要统一使用方式的团队
- 需要让新人快速接手模块验证工作的团队
- 希望把“方法、模板、脚本、验收”打包复用的团队

## 后续方向

后续会继续加强：
- 更多模块类型模板，例如 FIFO、仲裁器、CSR block、多通道 datapath
- 更完整的回归/coverage flow
- 更细的工具适配，例如 `urg`、`xrun`、`questa`、`spyglass`
- 更贴近企业交接场景的 checklist 与案例

## License

当前仓库默认按开源仓库方式维护；如需企业内部定制化落地，可基于此标准库继续扩展。
