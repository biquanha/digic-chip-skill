#!/usr/bin/env python3
import argparse
import re
import shutil
from pathlib import Path


def slugify(name: str) -> str:
    text = name.strip().replace('-', '_')
    text = re.sub(r'\W+', '_', text)
    text = re.sub(r'_+', '_', text)
    return text.strip('_')


def replace_text(path: Path, replacements: dict[str, str]) -> None:
    text = path.read_text(encoding='utf-8')
    for old, new in replacements.items():
        text = text.replace(old, new)
    path.write_text(text, encoding='utf-8')


def main() -> int:
    parser = argparse.ArgumentParser(description='从标准 UVM 骨架生成一个新工程')
    parser.add_argument('project_name', help='工程名，例如 fifo_demo')
    parser.add_argument('--module', required=True, help='DUT 模块名，例如 fifo_core')
    parser.add_argument('--out', required=True, help='输出目录')
    parser.add_argument('--test', default='smoke_test', help='默认 UVM test 名称')
    args = parser.parse_args()

    repo_root = Path(__file__).resolve().parents[3]
    template_dir = repo_root / 'skills' / 'rtl-remote-vcs-wave' / 'assets' / 'uvm-scaffold'
    out_root = Path(args.out).resolve()
    project_dir = out_root / slugify(args.project_name)
    dut_name = slugify(args.module)
    test_name = slugify(args.test)

    if project_dir.exists():
        raise SystemExit(f'输出目录已存在: {project_dir}')

    shutil.copytree(template_dir, project_dir)

    replacements = {
        'module_name': dut_name,
        '+UVM_TESTNAME=base_test': f'+UVM_TESTNAME={test_name}',
        'run_test();': f'run_test("{test_name}");'
    }

    for path in project_dir.rglob('*'):
        if path.is_file() and path.suffix in {'.sv', '.v', '.vh', '.f', '.list', '.md', '.txt', ''}:
            replace_text(path, replacements)

    print(f'已生成工程: {project_dir}')
    print(f'DUT 模块名: {dut_name}')
    print(f'默认测试名: {test_name}')
    print('后续请优先修改:')
    print(f'- {project_dir / "dut/module_name.v"}')
    print(f'- {project_dir / "tb/interfaces/dut_if.sv"}')
    print(f'- {project_dir / "tb/transaction/dut_trans.sv"}')
    print(f'- {project_dir / "tb/tb_top.sv"}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
