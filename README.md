# digic-chip-stdlib

面向数字芯片验证场景的开源标准库，提供新 RTL 模块 UVM 骨架、远端 EDA 仿真流程、FSDB 波形分析、验收校验，以及企业级验证方法沉淀。

## 这是什么

`digic-chip-stdlib` 是一套围绕数字芯片验证工作的标准化资产集合。

它把数字验证中常见的模板、脚本、校验方法和流程文档沉淀下来，帮助使用者更快地启动和维护验证平台。

主入口：`skills/rtl-remote-vcs-wave/SKILL.md`

## 这能做什么

当前仓库主要覆盖以下能力：
- 为新模块搭建最小可运行的 UVM 骨架
- 在远端 EDA 节点执行 VCS/Verdi/FSDB 仿真与波形分析
- 对 skill 本身和生成工程做静态校验
- 对工程执行 smoke 验收与日志摘要检查
- 规划 testcase、coverage、reference model、scoreboard、RAL、断言、回归与交接流程
- 为企业级验证平台提供路线图和工具矩阵

核心能力包括：
- 新模块 UVM 骨架搭建
- 远端 VCS/Verdi/FSDB flow
- FSDB 摘要分析
- smoke 验收与静态校验
- testcase 分层规划
- reference model / scoreboard 设计
- RAL 接入规划
- coverage 与回归思路
- 断言、交接、维护与工具扩展建议

## 这怎么用

### 主入口
- `skills/rtl-remote-vcs-wave/SKILL.md`

### Claude 插件方式加载
```bash
/plugin marketplace add biquanha/digic-chip-skill
/plugin install digic-chip-skill@biquanha
```

具体脚本、模板和执行步骤见主 skill 文档及其配套说明。

## 项目展示页
- GitHub Pages 首页：在 GitHub Pages 中选择 `main` 分支和 `/docs` 目录后即可访问

## 主要文档
- 主 skill：`skills/rtl-remote-vcs-wave/SKILL.md`
- Skill 校验说明：`docs/skill-validation.md`
- 企业级路线图：`docs/enterprise-uvm-roadmap.md`
- EDA 工具矩阵：`docs/eda-tool-matrix.md`
