import json
import re
import subprocess
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PROBLEMS_DIR = ROOT / "backend" / "problems"
UNKNOWN_RE = re.compile(r"[xz]", re.IGNORECASE)
MODULE_RE = re.compile(r"\bmodule\s+([A-Za-z_][A-Za-z0-9_]*)")
SIMULATOR_INFO_RE = re.compile(r"^.*\.v:\d+:\s+\$finish called at \d+")


def clean_output(text):
    lines = []
    for line in text.splitlines():
        line = line.rstrip()
        if line and not line.startswith("VCD info:") and not SIMULATOR_INFO_RE.match(line):
            lines.append(line)
    return "\n".join(lines)


def curated_problem_paths():
    for metadata_path in sorted(PROBLEMS_DIR.glob("*/problem.json")):
        metadata = json.loads(metadata_path.read_text(encoding="utf-8"))
        if metadata.get("curated") is True:
            yield metadata_path.parent, metadata


def compile_and_run(problem_path, source_path):
    with tempfile.TemporaryDirectory() as tmp:
        tmp_path = Path(tmp)
        binary = tmp_path / "sim.out"
        compile_result = subprocess.run(
            ["iverilog", "-g2005", "-o", str(binary), str(source_path), str(problem_path / "tb.v")],
            cwd=tmp_path,
            capture_output=True,
            text=True,
            timeout=8,
        )
        if compile_result.returncode != 0:
            return False, clean_output(compile_result.stdout + compile_result.stderr)

        run_result = subprocess.run(
            ["vvp", str(binary)],
            cwd=tmp_path,
            capture_output=True,
            text=True,
            timeout=8,
        )
        return run_result.returncode == 0, clean_output(run_result.stdout + run_result.stderr)


def empty_module_source(signature):
    match = MODULE_RE.search(signature)
    if not match:
        return None
    if "(" not in signature or ")" not in signature:
        return None
    return signature.rstrip(";") + ";\nendmodule\n"


def main():
    failures = []
    curated = list(curated_problem_paths())

    if len(curated) != 100:
        failures.append(f"Expected 100 curated problems, found {len(curated)}")

    for problem_path, metadata in curated:
        expected_path = problem_path / "expected.txt"
        solution_path = problem_path / "solution.v"
        tb_path = problem_path / "tb.v"

        for required in [expected_path, solution_path, tb_path]:
            if not required.exists():
                failures.append(f"{problem_path.name}: missing {required.name}")
                continue

        if not expected_path.exists():
            continue

        expected = clean_output(expected_path.read_text(encoding="utf-8"))
        if UNKNOWN_RE.search(expected):
            failures.append(f"{problem_path.name}: expected.txt contains x/z unknowns")
            continue

        ok, actual = compile_and_run(problem_path, solution_path)
        if not ok:
            failures.append(f"{problem_path.name}: reference solution failed:\n{actual}")
        elif actual != expected:
            failures.append(f"{problem_path.name}: reference solution output does not match expected.txt")

        empty_source = empty_module_source(metadata.get("module_signature", ""))
        if empty_source:
            with tempfile.TemporaryDirectory() as tmp:
                source_path = Path(tmp) / "empty_submission.v"
                source_path.write_text(empty_source, encoding="utf-8")
                ok, empty_output = compile_and_run(problem_path, source_path)
                if ok and empty_output == expected:
                    failures.append(f"{problem_path.name}: empty module is accepted")

    if failures:
        print("Curated bank validation failed:")
        for failure in failures:
            print(f"- {failure}")
        raise SystemExit(1)

    print(f"Curated bank validation passed for {len(curated)} problems.")


if __name__ == "__main__":
    main()
