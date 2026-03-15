# 面向 Codex 的安装说明

## 方式一：克隆仓库后安装

```bash
git clone git@github.com:biquanha/digic-chip-skill.git
cd digic-chip-skill
bash scripts/install-skills-codex.sh
```

默认会安装到：

```bash
~/.codex/skills/
```

## 方式二：指定安装目录

```bash
bash scripts/install-skills-codex.sh --codex-skills-dir /path/to/skills
```

## 方式三：仅演练不落盘

```bash
bash scripts/install-skills-codex.sh --dry-run
```

## 安装后检查

```bash
ls ~/.codex/skills/
ls ~/.codex/skills/rtl-remote-vcs-wave
```
