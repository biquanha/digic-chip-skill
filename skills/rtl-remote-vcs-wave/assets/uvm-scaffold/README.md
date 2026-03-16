# UVM 骨架模板说明

该目录提供“新 RTL 模块待测”场景下的最小 UVM 骨架，目标不是一步到位做成大而全平台，而是帮助用户快速搭出第一版可运行框架，再按真实项目逐步补强。

## 目录结构

- `dut/`：占位 DUT
- `tb/interfaces/`：interface 模板
- `tb/transaction/`：事务模板
- `tb/driver/`：driver 模板
- `tb/monitor/`：monitor 模板
- `tb/agent/`：agent 模板
- `tb/env/`：env 模板
- `tb/model/`：参考模型模板
- `tb/scoreboard/`：计分板模板
- `tb/coverage/`：覆盖率模板
- `tb/register/`：RAL 占位模板
- `tb/sequence/`：sequence 模板
- `tb/test/`：test 模板
- `sim/`：仿真 Makefile 与 filelist

## 推荐使用顺序

### 第 1 步：替换 DUT 端口
先改：
- `dut/module_name.v`
- `tb/interfaces/dut_if.sv`
- `tb/tb_top.sv`

### 第 2 步：定义事务
按 DUT 协议改：
- `tb/transaction/dut_trans.sv`

### 第 3 步：打通激励和采集
最先保证可用：
- `tb/driver/dut_driver.sv`
- `tb/monitor/dut_monitor.sv`
- `tb/agent/dut_agent.sv`

### 第 4 步：建立最小比较闭环
先保证：
- `tb/model/dut_model.sv`
- `tb/scoreboard/dut_scoreboard.sv`

### 第 5 步：补 testcase 与覆盖率
逐步补：
- `tb/sequence/`
- `tb/test/`
- `tb/coverage/`
- `tb/register/`

## 设计原则

- 第一版优先最小可运行
- 第二版补 reference model 与 scoreboard 策略
- 第三版补 RAL、coverage、错误场景、回归分层

## agent 使用要求

当用户给出一个新的 DUT 时，agent 不应直接把模板原样照抄，而应先根据 DUT 特征判断：
- 是数据通路模块还是控制模块
- 是否有寄存器面
- 是否需要多 agent
- 是否需要参考模型
- 是否需要 out-of-order 比较
- 是否需要协议断言和覆盖率
