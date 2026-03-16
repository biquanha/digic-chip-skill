# EDA 工具矩阵

本文汇总当前标准库面向企业级验证平台的工具矩阵。

## 已验证可直接使用
- `VCS`
- `Verdi`
- `fsdbreport`
- `UVM`

## 推荐纳入但需现场确认
- `urg`
- `vlogan` / `vhdlan`
- `SpyGlass lint/cdc/rdc`
- `VC Formal` / `JasperGold`
- `dc_shell` / `fm_shell` / `pt_shell`
- `xrun` / `irun`
- `qverilog` / `vsim`

## 工具与用途映射
- 仿真：`VCS` / `xrun` / `qverilog`
- 波形：`Verdi` / `fsdbreport`
- 覆盖率：`urg`
- lint/cdc：`SpyGlass`
- 形式：`VC Formal` / `JasperGold`
- 综合/等价/时序协同：`dc_shell` / `fm_shell` / `pt_shell`


## 探测建议

如果目标机器上的 `module avail` 很慢或会阻塞，优先使用轻量探测：

```bash
bash skills/rtl-remote-vcs-wave/scripts/probe_eda_tools.sh --skip-module-avail --output /tmp/eda_probe.txt
```

先用 `command -v` 拿到已安装命令，再按需补做 `module avail`。
