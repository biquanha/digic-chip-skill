# 数字芯片开发标准库

**当前版本：0.1.0**

这是一个面向数字芯片研发场景的标准化技能库与流程库。

当前已沉淀章节：
- `skills/rtl-remote-vcs-wave`：在远端 VCS 节点执行 RTL 编译、仿真、FSDB 导出与 `fsdbreport` 波形摘要分析。

建议组织方式：
- `skills/`：面向 agent 的可复用技能
- `commands/`：高频命令模板
- `docs/`：使用说明与环境说明
- `scripts/`：仓库级辅助脚本


## 安装

```bash
# 添加插件市场
/plugin marketplace add biquanha/digic-chip-skill
# 然后安装插件
/plugin install digic-chip-skill@biquanha
```

如果需要开发分支，可使用：

```bash
/plugin marketplace add biquanha/digic-chip-skill#dev
```

当前插件内置章节：
- `skills/rtl-remote-vcs-wave`


## 校验

- Skill 校验说明：`docs/skill-validation.md`
- 静态校验命令：`python3 skills/rtl-remote-vcs-wave/scripts/validate_skill.py`
- UVM 骨架生成命令：`python3 skills/rtl-remote-vcs-wave/scripts/create_uvm_scaffold.py demo_fifo --module fifo_core --out /tmp/demo_fifo`
