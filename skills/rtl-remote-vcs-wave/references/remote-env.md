# 远端环境与常见问题

## 基础要求

远端节点需要具备：
- SSH 批量登录能力
- 与本地一致的共享路径可见性
- Synopsys VCS 工具
- Synopsys Verdi 工具
- 有效 license

## 推荐环境初始化

```bash
source /etc/profile
module load synopsys/vcs/Q-2020.03-SP2
module load synopsys/verdi/R-2020.12-SP1
module load license
export VERDI_HOME=/nfs/tools/synopsys/verdi/R-2020.12-SP1
```

## 常见问题

### 1. 找不到 vcs

原因：
- 非交互 shell 没有自动加载 module 环境

处理：
- 显式 `source /etc/profile`
- 显式 `module load ...`

### 2. 找不到 license

现象：
- `Cannot find license file`

处理：
- 检查 `LM_LICENSE_FILE`
- 检查 `SNPSLMD_LICENSE_FILE`
- 确保远端 SSH 非交互 shell 同样能拿到 license 环境

### 3. 找不到 PLI 表文件

现象：
- `Cannot open pli table file`

处理：
- 检查 `VERDI_HOME`
- 检查 `novas.tab`、`pli.a` 路径

### 4. FSDB 已生成但高级接口分析失败

处理建议：
- 先确认 `fsdbreport` 是否可正常工作
- 再检查工具链版本一致性
