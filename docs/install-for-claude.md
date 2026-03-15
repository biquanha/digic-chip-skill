# 面向 Claude 的安装说明

## 克隆仓库后安装

```bash
git clone git@github.com:biquanha/digic-chip-skill.git
cd digic-chip-skill
bash scripts/install-skills-claude.sh
```

默认会安装到：

```bash
~/.claude/skills/
```

## 指定安装目录

```bash
bash scripts/install-skills-claude.sh --claude-skills-dir /path/to/skills
```

## 演练模式

```bash
bash scripts/install-skills-claude.sh --dry-run
```
