# EDA 工具链扩展

本章用于把 skill 从“VCS + Verdi + FSDB”扩展到更贴近企业级芯片验证的完整工具链视角。

## 核心仿真与波形

### Synopsys VCS
用于：
- RTL/UVM 编译与仿真
- 回归主执行引擎

### Synopsys Verdi
用于：
- FSDB 波形查看
- 代码跳转
- debug 辅助
- `fsdbreport` 摘要导出

## 质量前移工具

### Lint
常见工具方向：
- SpyGlass Lint
- Questa Lint

建议接入时机：
- DUT 初版完成后尽早跑
- 在 UVM 平台稳定前就暴露基础编码问题

重点关注：
- 未驱动/多驱动
- 位宽不匹配
- 潜在锁存器
- case 不完整
- reset 不一致

### CDC / RDC
常见工具方向：
- SpyGlass CDC/RDC
- Questa CDC

适用场景：
- 多时钟模块
- 异步复位模块
- 跨域握手或 FIFO

重点关注：
- 同步器是否完整
- 跨域控制信号是否安全
- reset 释放是否跨域风险

## 形式验证方向

### Formal / Property Checking
常见工具方向：
- VC Formal
- JasperGold

适用场景：
- FIFO/full/empty 边界
- 仲裁公平性
- deadlock / livelock
- 协议关键不变量

skill 中的定位：
- 不替代 UVM
- 用于补强随机仿真难以穷尽的边界性质

## 覆盖率与回归管理

### Coverage
建议覆盖：
- code coverage
- functional coverage
- cross coverage

### Regression 管理
可配合：
- make / python 调度脚本
- 统一日志目录
- seed 管理
- fail case 自动收集

## 断言与协议检查

### SVA / Assertions
建议纳入：
- interface 层协议断言
- reset 行为断言
- FIFO / handshake 基础断言

### VIP / 协议模型
当模块协议复杂时，可考虑：
- AXI/APB/AHB/PCIe 等协议 VIP
- 内部简化 BFM 到商用 VIP 的演进路径

## DFT / 低功耗等邻近流程

### DFT 相关验证
对于带 scan / test mode 的模块，可补：
- test mode 切换场景
- scan enable 影响
- test bypass 模式

### Low Power / UPF
若模块受电源域影响，应进一步考虑：
- isolation
- retention
- power state 切换验证

## agent 的使用原则

当用户只给一个新模块时，agent 不应一上来把所有工具都拉进来，而应说明：
- 当前最小闭环要用哪些工具
- 下一阶段该补哪些工具
- 哪些工具取决于模块复杂度、时钟域、协议、低功耗、DFT 要求
