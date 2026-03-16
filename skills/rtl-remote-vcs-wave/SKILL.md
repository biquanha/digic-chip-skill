---
name: rtl-remote-vcs-wave
description: 当用户需要在工作机器或 EDA 节点上，对 RTL 与 testbench 做远端 VCS 编译、仿真、导出 FSDB 波形，并基于 fsdbreport 做波形分析时，使用本技能。进一步扩展到“为新 RTL 模块搭建完整 UVM 验证平台”的场景。
---

# RTL 远程编译仿真与波形分析

本技能用于把下面这条链路标准化：

`RTL/Testbench -> 远端 VCS 编译 -> simv 仿真 -> FSDB 波形 -> fsdbreport 摘要分析 -> UVM 验证平台扩展`

## 适用场景

当用户提出以下需求时，应触发本技能：
- 在远端 EDA 节点上编译一段 RTL
- 自动执行 testbench 仿真
- 导出 FSDB 波形
- 检查波形是否符合预期
- 搭建一个最小可复现的 VCS/Verdi 环境
- 把用户给的 RTL 快速塞进一个远端仿真闭环里
- 为一个新的 RTL 模块构建 UVM 验证平台
- 参考真实项目，抽出可复用的验证骨架和流程

## 技能内容

本技能提供：
- 一套远端 RTL 仿真闭环流程
- 一个最小计数器示例
- 一个远端执行脚本
- 一套环境检查和故障定位要点
- 一套 `fsdbreport` 波形摘要方法
- 一套面向新模块的 UVM 骨架模板
- 一组完整验证流程规划文档
- 一套 testcase/coverage/RAL/reference model 渐进式引导

## 使用原则

### 1. 优先使用独立目录

不要直接把最小验证流程绑死在大工程编译系统里。
应优先创建独立工作目录，避免引入无关依赖。

### 2. 远端环境必须显式设置

不要假设 SSH 非交互 shell 会自动带出以下内容：
- `vcs`
- `verdi`
- `license`
- `VERDI_HOME`

优先显式执行：
- `source /etc/profile`
- `module load synopsys/vcs/...`
- `module load synopsys/verdi/...`
- `module load license`
- `export VERDI_HOME=...`

### 3. 编译时必须带 Verdi PLI

为了生成 FSDB，VCS 编译命令里必须显式带：
- `novas.tab`
- `pli.a`

### 4. 波形分析优先用 fsdbreport

如果目标是快速、稳定、可脚本化地产出波形摘要，优先使用：
- `fsdbreport`

若用户明确要求更底层的接口，再考虑 NPI。

### 5. 搭 UVM 平台时坚持渐进式

不要一开始就把 env、RAL、coverage、assertion、多 agent 全堆满。
推荐按“能跑 -> 能比对 -> 能扩展 -> 能回归 -> 能收敛覆盖率”的顺序推进。

## 标准流程

### 步骤 1：准备工作目录

创建一个独立目录，并放入：
- 用户 RTL
- 用户 testbench
- 或使用 `assets/example-minimal/` 中的最小工程
- 或使用 `assets/uvm-scaffold/` 中的 UVM 骨架

### 步骤 2：检查远端基础条件

确认：
- SSH 批量登录可用
- 远端能访问同一份共享路径
- 远端存在可用的 `vcs/verdi/license`

### 步骤 3：执行远端编译

编译阶段关注点：
- 使用 VCS 全 64 位模式
- 使用 `-sverilog`
- 打开调试访问选项
- 正确挂 Verdi PLI

### 步骤 4：执行仿真并生成 FSDB

testbench 中应使用：
- `$fsdbDumpfile(...)`
- `$fsdbDumpvars(...)`

仿真后要检查：
- `simv.log`
- testbench 输出的 PASS/FAIL
- `*.fsdb` 是否存在

### 步骤 5：执行波形摘要分析

常用分析方式：
- 单信号变化摘要
- 基于时钟边沿的采样摘要

重点提取：
- 复位释放时刻
- 使能窗口
- 状态变化时刻
- 最终稳定值
- 是否与时钟边沿对齐

### 步骤 6：升级为 UVM 验证平台

若目标是新模块验证平台，应继续完成：
- 事务抽象
- driver/monitor 分离
- agent 化封装
- env 连接
- reference model / predictor
- scoreboard 比对
- testcase 分层
- coverage 规划
- RAL 规划

## 需要按需读取的文件

### 基础远端流程
- 执行脚本：`scripts/run_remote_vcs_fsdb.sh`
- 动态验收脚本：`scripts/run_remote_uvm_smoke.sh`
- 最小 Makefile 示例：`assets/example-minimal/Makefile`
- 远端环境说明：`references/remote-env.md`
- 典型命令与输出：`references/示例命令.md`

### 新模块 UVM 场景
- 主模板说明：`assets/uvm-scaffold/README.md`
- 总体验证流程：`references/verification-flow/总体验证流程.md`
- 新模块接入清单：`references/verification-flow/新模块接入清单.md`
- 测试计划分层：`references/verification-flow/测试计划与用例分层.md`
- 覆盖率规划：`references/verification-flow/覆盖率规划模板.md`
- 参考模型与计分板：`references/verification-flow/参考模型与计分板设计.md`
- RAL 接入规划：`references/verification-flow/RAL接入规划.md`
- 真实项目接入示例：`references/verification-flow/真实项目接入示例.md`
- 远端动态验收：`references/verification-flow/远端动态验收.md`
- 企业级验证平台分层：`references/verification-flow/企业级验证平台分层.md`
- EDA 工具链扩展：`references/verification-flow/EDA工具链扩展.md`
- 回归与覆盖率收敛：`references/verification-flow/回归与覆盖率收敛.md`
- 断言检查与协议验证：`references/verification-flow/断言检查与协议验证.md`
- 平台交接与维护指南：`references/verification-flow/平台交接与维护指南.md`
- eda01 工具盘点与扩展建议：`references/verification-flow/eda01工具盘点与扩展建议.md`

## 输出要求

完成任务时，至少给出：
- 使用的远端节点
- 使用的工具版本
- 是否成功生成 `simv`
- 是否成功生成 `FSDB`
- 基于 `fsdbreport` 的关键信号摘要
- 最终行为是否符合预期

若任务是“为新模块搭 UVM 平台”，还应额外给出：
- 验证对象拆分结果
- 推荐的 agent 数量与职责
- 是否需要 reference model
- 是否需要 RAL
- testcase 分层建议
- coverage 规划起点
- 第一版平台最小交付范围

## 面向新模块搭建 UVM 平台

本技能的核心目标，不只是跑已有工程，而是面向一个新的 RTL 待测模块，快速搭起一套最小可运行、可扩展的 UVM 验证平台。

### 推荐的渐进式能力

1. 先打通远端环境、VCS、Verdi、FSDB
2. 再识别已有工程入口，例如 `sim/Makefile`、`rtl.list`、`TESTNAME`
3. 对于全新模块，优先套用最小 UVM 骨架模板
4. 然后按 DUT 特性补齐：
   - interface
   - transaction
   - driver
   - monitor
   - agent
   - env
   - testcase
   - reference model
   - scoreboard
   - coverage
   - RAL
5. 最后把最小平台升级为可回归的平台

### 新模块模板入口

如果用户的目标是“为一个新的 RTL 模块搭建 UVM 平台”，优先读取：
- `assets/uvm-scaffold/README.md`
- `assets/uvm-scaffold/sim/Makefile`
- `assets/uvm-scaffold/tb/tb_top.sv`

### 真实项目接入要点

对于类似 `uvm-mcdf` 的真实项目，优先识别：
- `sim/Makefile`
- `rtl.list`
- testcase 选择方式，例如 `TESTNAME=case0`
- FSDB 输出位置
- PASS/FAIL 判断规则
- scoreboard 比对摘要

### 通过标准示例总结出的验收规则

真实 UVM 项目通常至少检查：
- `UVM_ERROR == 0`
- `UVM_FATAL == 0`
- 日志中出现 `TestCase Passed`
- scoreboard 中 `total error count == 0`
- 波形文件 `*.fsdb` 成功生成

## 常见模板与细节点引导

### 规划与接入文档

如果用户要为新模块做完整验证规划，优先读取：
- `references/verification-flow/总体验证流程.md`
- `references/verification-flow/新模块接入清单.md`
- `references/verification-flow/测试计划与用例分层.md`
- `references/verification-flow/覆盖率规划模板.md`
- `references/verification-flow/参考模型与计分板设计.md`
- `references/verification-flow/RAL接入规划.md`
- `references/verification-flow/真实项目接入示例.md`

### 模板资源

如果用户需要直接套模板，优先使用：
- `assets/uvm-scaffold/tb/interfaces/dut_if.sv`
- `assets/uvm-scaffold/tb/transaction/dut_trans.sv`
- `assets/uvm-scaffold/tb/driver/dut_driver.sv`
- `assets/uvm-scaffold/tb/monitor/dut_monitor.sv`
- `assets/uvm-scaffold/tb/agent/dut_agent.sv`
- `assets/uvm-scaffold/tb/env/dut_env.sv`
- `assets/uvm-scaffold/tb/model/dut_model.sv`
- `assets/uvm-scaffold/tb/scoreboard/dut_scoreboard.sv`
- `assets/uvm-scaffold/tb/coverage/dut_coverage.sv`
- `assets/uvm-scaffold/tb/register/dut_adapter.sv`
- `assets/uvm-scaffold/tb/register/dut_reg_model.sv`
- `assets/uvm-scaffold/tb/sequence/smoke_seq.sv`
- `assets/uvm-scaffold/tb/sequence/basic_seq.sv`
- `assets/uvm-scaffold/tb/sequence/reset_seq.sv`
- `assets/uvm-scaffold/tb/test/base_test.sv`
- `assets/uvm-scaffold/tb/test/smoke_test.sv`
- `assets/uvm-scaffold/tb/test/basic_test.sv`
- `assets/uvm-scaffold/tb/test/reset_test.sv`
- `assets/uvm-scaffold/tb/tb_top.sv`
- `assets/uvm-scaffold/sim/Makefile`

### 面向真实验证场景的功能引导

当面对一个新模块时，agent 应主动引导用户补充以下信息：
- DUT 接口说明
- 是否存在寄存器配置面
- 是否需要多 agent 拆分
- 是否需要参考模型
- 是否需要协议检查
- 是否存在错误场景与异常返回
- 是否需要覆盖率收敛目标
- 是否需要日常回归列表

若用户信息不完整，应先给出“第一版最小平台方案”，再说明后续扩展点。


## 校验机制

当用户要求直接交付模板或平台时，agent 应至少执行：
- `python3 skills/rtl-remote-vcs-wave/scripts/validate_skill.py`
- 如已生成工程，再执行：`python3 skills/rtl-remote-vcs-wave/scripts/validate_skill.py --project <project_dir>`

优先读取：
- `references/verification-flow/校验与验收机制.md`
- `../../docs/skill-validation.md`


## 企业级验证平台导向

本 skill 的最终目标，不是生成一个教学用 demo，而是帮助用户为新模块构建可交接、可回归、可维护的企业级 UVM 验证平台。

agent 在执行时，应主动判断并说明：
- 当前平台处于 L1/L2/L3/L4/L5 哪个成熟度
- 是否需要补 lint / CDC / formal / assertion / VIP
- 是否已经具备交接给其他验证工程师维护的条件
- 当前缺的是“工具流”还是“平台架构”还是“验证内容”


## 工具可用性说明

在不同工作机器或 EDA 节点上，工具可用性可能不同。
对 `eda01`，当前已明确验证可用的是 `VCS`、`Verdi`、`fsdbreport`。
对于 `SpyGlass`、`Formal`、`PrimeTime`、`DC/FM`、`xrun/questa` 等工具，agent 应先做现场探测，再决定是否纳入本次 flow。
