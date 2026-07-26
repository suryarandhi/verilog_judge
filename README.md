# Verilog Judge

A local LeetCode-style practice platform for Verilog and digital electronics. Users select an RTL problem, write Verilog in a Monaco editor, and submit against hidden Icarus Verilog testbenches.

## Features

- Problem library for combinational and sequential circuits
- Browser editor with Verilog syntax highlighting
- Flask API for problem loading and submissions
- Icarus Verilog compile/simulation judging
- Accepted, Wrong Answer, Compilation Error, Runtime Error, Tool Missing, and Time Limit verdicts
- VCD waveform generation and download when the testbench emits a waveform
- Curated problem metadata: category, tags, behavior spec, constraints, examples, and hidden hints
- Curated 100-problem seed bank that hides older width-variant generated problems from the UI
- Unknown `x`/`z` outputs are rejected so empty or undriven modules cannot pass accidentally
- Test visibility with passed/failed hidden test counts and per-case expected vs actual output
- Friendly compile diagnostics with clickable editor line navigation
- Local learning features: topic tracks, progress map, daily DV/interview prep, level-by-level hints, acceptance explanations, gated official solutions, debug starters, expanded SystemVerilog/UVM quiz mode, code review, leaderboard, streaks, and daily challenges

## Project Structure

```text
verilog-judge/
  backend/
    app.py
    judge.py
    utils.py
    requirements.txt
    problems/
      half_adder/
      full_adder/
      multiplexer_2to1/
      d_flipflop/
      register_4bit/
  frontend/
    index.html
    problem.html
    script.js
    editor.js
    style.css
  scripts/
    seed_curated_bank.py
    validate_curated_bank.py
```

## Requirements

- Python 3.7+
- Icarus Verilog with `iverilog` and `vvp` on PATH
- Optional: GTKWave for opening downloaded `.vcd` files

## Run Locally

```powershell
cd "d:\buffer gate\buffer gate\verilog-judge"
python -m pip install -r backend\requirements.txt
python backend\app.py
```

Open `http://127.0.0.1:5000`.

## Generate 100 Curated Problems

The repository includes a curated seeder. It deduplicates the source list, adds missing anchor concepts, hides old width-variant folders, and writes normal judgeable problem folders:

```powershell
python scripts\seed_curated_bank.py
```

Older generated width-variant folders may still exist on disk, but the app only shows the 100 problems marked `"curated": true`.

The seeder also adds timing assumptions to problem metadata. For clocked problems, resets are active-high and synchronous unless a problem explicitly says otherwise, state updates happen on `posedge clk`, and registered logic should use non-blocking assignments.

## Validate Hidden Tests

Run the validation script after editing problems or regenerating the bank:

```powershell
python scripts\validate_curated_bank.py
```

The validator checks that there are exactly 100 curated problems, reference solutions match `expected.txt`, expected output contains no `x`/`z` unknowns, and empty modules are not accepted.

## Add A Problem

Create `backend/problems/<problem_id>/` with:

- `problem.json`: title, difficulty, category, tags, statement, module signature, behavior, constraints, example, hint, template, and `curated`.
- `tb.v`: hidden testbench that instantiates the required module and prints output.
- `expected.txt`: expected stdout lines, one line per test vector.
- `solution.v`: reference solution for local verification.

If you want the new problem to appear in the UI, set:

```json
"curated": true
```

Example `problem.json`:

```json
{
  "title": "My New Problem",
  "difficulty": "Medium",
  "category": "Combinational",
  "tags": ["gates", "arithmetic"],
  "statement": "Design the module...",
  "module_signature": "module my_new_problem(...);",
  "behavior": ["Describe expected behavior."],
  "constraints": ["Must be synthesizable Verilog."],
  "example": "input | output",
  "hint": "Optional hint.",
  "template": "module my_new_problem(...);\n  // Write your code here\nendmodule",
  "curated": true
}
```

The submitted module interface must match the testbench instantiation.
