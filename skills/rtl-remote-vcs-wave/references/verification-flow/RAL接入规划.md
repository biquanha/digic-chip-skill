# RAL 接入规划

当 DUT 带寄存器配置面时，建议尽早规划 RAL，而不是把寄存器操作写死在 sequence 里。

## 什么时候需要 RAL

以下情况建议使用 UVM RAL：
- 寄存器数量较多
- 存在 reset value / access policy 校验
- 需要前门/后门访问
- 需要寄存器镜像和一致性检查
- 配置操作会显著影响数据路径行为

## 渐进式接入

### 第 1 步：先列寄存器表
- 地址
- 名称
- 位域
- 访问属性
- reset value
- 功能说明

### 第 2 步：建立最小 reg_block
- 搭一个 `uvm_reg_block`
- 创建 default_map
- 定义关键控制寄存器

### 第 3 步：补 adapter / predictor
- 把 bus transaction 映射到 reg op
- 把实际访问结果同步到 mirror

### 第 4 步：加基础检查
- reset 后镜像值检查
- rw/ro/wo 访问属性检查
- 配置后功能行为检查

## 与数据面联合验证

不要把 RAL 验证和数据面验证割裂。
建议至少覆盖：
- 改寄存器前后的行为差异
- 非法配置下 DUT 响应
- 动态切换配置模式
