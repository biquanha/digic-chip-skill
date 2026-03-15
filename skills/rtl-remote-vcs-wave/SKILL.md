---
name: rtl-remote-vcs-wave
description: 当用户需要在工作机器或 EDA 节点上，对 RTL 与 testbench 做远端 VCS 编译、仿真、导出 FSDB 波形，并基于 fsdbreport 做波形分析时，使用本技能。适用于最小化验证、独立问题复现、环境打通、波形摘要检查、以及把用户自带 RTL 套进远端仿真流程。
---

# RTL 远程编译仿真与波形分析

本技能用于把下面这条链路标准化：

`RTL/Testbench -> 远端 VCS 编译 -> simv 仿真 -> FSDB 波形 -> fsdbreport 摘要分析`

## 适用场景

当用户提出以下需求时，应触发本技能：
- 在远端 EDA 节点上编译一段 RTL
- 自动执行 testbench 仿真
- 导出 FSDB 波形
- 检查波形是否符合预期
- 搭建一个最小可复现的 VCS/Verdi 环境
- 把用户给的 RTL 快速塞进一个远端仿真闭环里

## 技能内容

本技能提供：
- 一套远端 RTL 仿真闭环流程
- 一个最小计数器示例
- 一个远端执行脚本
- 一套环境检查和故障定位要点
- 一套 `fsdbreport` 波形摘要方法

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

## 标准流程

### 步骤 1：准备工作目录

创建一个独立目录，并放入：
- 用户 RTL
- 用户 testbench
- 或使用 `assets/example-minimal/` 中的最小工程

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

## 需要按需读取的文件

- 执行脚本：`scripts/run_remote_vcs_fsdb.sh`
- 最小 Makefile 示例：`assets/example-minimal/Makefile`
- 远端环境说明：`references/remote-env.md`
- 典型命令与输出：`references/示例命令.md`

## 输出要求

完成任务时，至少给出：
- 使用的远端节点
- 使用的工具版本
- 是否成功生成 `simv`
- 是否成功生成 `FSDB`
- 基于 `fsdbreport` 的关键信号摘要
- 最终行为是否符合预期
