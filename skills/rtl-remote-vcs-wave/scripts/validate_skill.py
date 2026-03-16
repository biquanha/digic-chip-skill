#!/usr/bin/env python3
import argparse
import re
from pathlib import Path

REQUIRED_DOCS = [
    'references/remote-env.md',
    'references/示例命令.md',
    'references/verification-flow/总体验证流程.md',
    'references/verification-flow/新模块接入清单.md',
    'references/verification-flow/测试计划与用例分层.md',
    'references/verification-flow/覆盖率规划模板.md',
    'references/verification-flow/参考模型与计分板设计.md',
    'references/verification-flow/RAL接入规划.md',
    'references/verification-flow/真实项目接入示例.md',
    'references/verification-flow/校验与验收机制.md',
]

REQUIRED_TEMPLATE_FILES = [
    'assets/uvm-scaffold/README.md',
    'assets/uvm-scaffold/sim/Makefile',
    'assets/uvm-scaffold/sim/rtl.list',
    'assets/uvm-scaffold/tb/tb_top.sv',
    'assets/uvm-scaffold/tb/interfaces/dut_if.sv',
    'assets/uvm-scaffold/tb/transaction/dut_trans.sv',
    'assets/uvm-scaffold/tb/driver/dut_driver.sv',
    'assets/uvm-scaffold/tb/monitor/dut_monitor.sv',
    'assets/uvm-scaffold/tb/agent/dut_agent.sv',
    'assets/uvm-scaffold/tb/env/dut_env.sv',
    'assets/uvm-scaffold/tb/model/dut_model.sv',
    'assets/uvm-scaffold/tb/scoreboard/dut_scoreboard.sv',
    'assets/uvm-scaffold/tb/coverage/dut_coverage.sv',
    'assets/uvm-scaffold/tb/register/dut_adapter.sv',
    'assets/uvm-scaffold/tb/register/dut_reg_model.sv',
    'assets/uvm-scaffold/tb/sequence/smoke_seq.sv',
    'assets/uvm-scaffold/tb/sequence/basic_seq.sv',
    'assets/uvm-scaffold/tb/sequence/reset_seq.sv',
    'assets/uvm-scaffold/tb/test/base_test.sv',
    'assets/uvm-scaffold/tb/test/smoke_test.sv',
    'assets/uvm-scaffold/tb/test/basic_test.sv',
    'assets/uvm-scaffold/tb/test/reset_test.sv',
]


def check_exists(base: Path, rels: list[str], errors: list[str]) -> None:
    for rel in rels:
        path = base / rel
        if not path.exists():
            errors.append(f'缺少文件: {path}')


def extract_includes(tb_top: Path) -> list[str]:
    includes = []
    for line in tb_top.read_text(encoding='utf-8').splitlines():
        match = re.match(r'`include\s+"([^"]+)"', line.strip())
        if match:
            includes.append(match.group(1))
    return includes


def validate_template(skill_root: Path, errors: list[str]) -> None:
    tb_top = skill_root / 'assets/uvm-scaffold/tb/tb_top.sv'
    include_map = {path.name: path for path in (skill_root / 'assets/uvm-scaffold/tb').rglob('*.sv')}

    for inc in extract_includes(tb_top):
        if inc == 'uvm_macros.svh':
            continue
        if inc not in include_map:
            errors.append(f'tb_top include 缺失: {inc}')

    sim_root = skill_root / 'assets/uvm-scaffold/sim'
    for raw in (sim_root / 'rtl.list').read_text(encoding='utf-8').splitlines():
        line = raw.strip()
        if not line or line.startswith('//'):
            continue
        if line.startswith('+incdir+'):
            rel = line[len('+incdir+'):]
            target = (sim_root / rel).resolve()
            if not target.exists():
                errors.append(f'rtl.list incdir 不存在: {rel}')
        elif line.startswith('../'):
            target = (sim_root / line).resolve()
            if not target.exists():
                errors.append(f'rtl.list 源文件不存在: {line}')


def validate_project(project_root: Path, errors: list[str], warnings: list[str]) -> None:
    tb_top = project_root / 'tb/tb_top.sv'
    makefile = project_root / 'sim/Makefile'
    if not tb_top.exists():
        errors.append(f'工程缺少 tb_top: {tb_top}')
        return
    if not makefile.exists():
        errors.append(f'工程缺少 Makefile: {makefile}')

    text = '\n'.join(
        path.read_text(encoding='utf-8', errors='ignore')
        for path in project_root.rglob('*')
        if path.is_file()
    )
    if 'module_name' in text:
        warnings.append('仍残留占位符 module_name，说明 DUT 名称还未完全替换')

    include_map = {path.name: path for path in (project_root / 'tb').rglob('*.sv')} if (project_root / 'tb').exists() else {}
    for inc in extract_includes(tb_top):
        if inc == 'uvm_macros.svh':
            continue
        if inc not in include_map:
            errors.append(f'工程 tb_top include 缺失: {inc}')


def main() -> int:
    parser = argparse.ArgumentParser(description='校验 rtl-remote-vcs-wave skill 或生成后的工程')
    parser.add_argument('--project', help='额外校验一个生成后的工程目录')
    args = parser.parse_args()

    repo_root = Path(__file__).resolve().parents[3]
    skill_root = repo_root / 'skills' / 'rtl-remote-vcs-wave'
    errors: list[str] = []
    warnings: list[str] = []

    check_exists(skill_root, REQUIRED_DOCS + REQUIRED_TEMPLATE_FILES, errors)
    validate_template(skill_root, errors)

    if args.project:
        validate_project(Path(args.project).resolve(), errors, warnings)

    if errors:
        print('校验失败:')
        for item in errors:
            print(f'- ERROR: {item}')
    else:
        print('静态校验通过')

    for item in warnings:
        print(f'- WARN: {item}')

    return 1 if errors else 0


if __name__ == '__main__':
    raise SystemExit(main())
