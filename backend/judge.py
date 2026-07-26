import os
import re
import subprocess
import time
import uuid

from utils import ensure_dir, read_json_file, safe_problem_id, save_json_file


BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PROBLEMS_DIR = os.path.join(BASE_DIR, 'problems')
SUBMISSIONS_DIR = os.path.join(BASE_DIR, 'submissions')

ensure_dir(SUBMISSIONS_DIR)

UNKNOWN_VALUE_RE = re.compile(r'[xz]', re.IGNORECASE)
COMPILE_ERROR_RE = re.compile(r'^(?P<file>.*?):(?P<line>\d+):\s*(?P<message>.*)$')
SIMULATOR_INFO_RE = re.compile(r'^.*\.v:\d+:\s+\$finish called at \d+')


def load_problem_list():
    problems = []
    for problem_id in sorted(os.listdir(PROBLEMS_DIR)):
        problem_path = os.path.join(PROBLEMS_DIR, problem_id)
        metadata_path = os.path.join(problem_path, 'problem.json')
        if not os.path.isdir(problem_path) or not os.path.exists(metadata_path):
            continue

        metadata = read_json_file(metadata_path)
        if metadata.get('curated', True) is False:
            continue
        problems.append({
            'id': problem_id,
            'title': metadata.get('title', problem_id.replace('_', ' ').title()),
            'difficulty': metadata.get('difficulty', 'Medium'),
            'category': metadata.get('category', 'Combinational'),
            'description': metadata.get('statement', metadata.get('description', '')),
            'tags': metadata.get('tags', []),
        })
    return problems


def load_problem(problem_id):
    problem_id = safe_problem_id(problem_id)
    metadata_path = os.path.join(PROBLEMS_DIR, problem_id, 'problem.json')
    if not os.path.exists(metadata_path):
        return None

    metadata = read_json_file(metadata_path)
    if metadata.get('curated', True) is False:
        return None
    metadata['id'] = problem_id
    return metadata


def build_submission_folder():
    submission_id = str(uuid.uuid4())[:10]
    submission_path = os.path.join(SUBMISSIONS_DIR, submission_id)
    ensure_dir(submission_path)
    return submission_id, submission_path


def compile_verilog(source_path, testbench_path, binary_path):
    return subprocess.run(
        ['iverilog', '-g2005', '-o', binary_path, source_path, testbench_path],
        capture_output=True,
        text=True,
        cwd=os.path.dirname(binary_path),
        timeout=8,
    )


def run_simulation(binary_path):
    return subprocess.run(
        ['vvp', binary_path],
        capture_output=True,
        text=True,
        cwd=os.path.dirname(binary_path),
        timeout=8,
    )


def has_unknown_value(lines):
    return any(UNKNOWN_VALUE_RE.search(line) for line in lines)


def build_test_cases(actual_lines, expected_lines):
    cases = []
    total = max(len(actual_lines), len(expected_lines))
    for index in range(total):
        actual = actual_lines[index] if index < len(actual_lines) else ''
        expected = expected_lines[index] if index < len(expected_lines) else ''
        cases.append({
            'index': index + 1,
            'passed': actual == expected and not has_unknown_value([actual, expected]),
            'actual': actual,
            'expected': expected,
        })
    return cases


def compare_output(actual_output, expected_path):
    expected_text = open(expected_path, 'r', encoding='utf-8').read().strip()
    expected_lines = [line.rstrip() for line in expected_text.splitlines() if line.strip()]
    actual_lines = [line.rstrip() for line in actual_output.strip().splitlines() if line.strip()]
    actual_lines = [
        line for line in actual_lines
        if not line.startswith('VCD info:') and not SIMULATOR_INFO_RE.match(line)
    ]
    if has_unknown_value(expected_lines):
        return False, actual_lines, expected_lines, 'expected_unknown'
    if has_unknown_value(actual_lines):
        return False, actual_lines, expected_lines, 'actual_unknown'
    return actual_lines == expected_lines, actual_lines, expected_lines, None


def friendly_compile_message(message):
    lower = message.lower()
    if 'syntax error' in lower:
        return 'Syntax error. Check for a missing semicolon, parenthesis, end, or endmodule near this line.'
    if 'unable to bind' in lower or 'not declared' in lower:
        return 'Signal or module name was not declared, or the name does not match the required interface.'
    if 'reg' in lower and 'continuous assignment' in lower:
        return 'A reg output cannot be driven by assign. Use an always block, or declare the output as wire.'
    if 'port' in lower:
        return 'Module port mismatch. Make sure your module signature exactly matches the required module.'
    if 'operand' in lower:
        return 'Invalid expression or operator usage. Check the operands around this line.'
    return message.strip() or 'Compilation failed near this line.'


def parse_compile_errors(output):
    errors = []
    for raw_line in output.splitlines():
        line = raw_line.strip()
        match = COMPILE_ERROR_RE.match(line)
        if not match:
            continue
        filename = os.path.basename(match.group('file'))
        if filename != 'submission.v':
            continue
        source_line = int(match.group('line'))
        message = match.group('message').strip()
        errors.append({
            'line': source_line,
            'message': message,
            'friendly': friendly_compile_message(message),
            'raw': line,
        })
    return errors


def save_submission_result(submission_path, problem_id, code, verdict):
    save_json_file(os.path.join(submission_path, 'result.json'), {
        'problem_id': problem_id,
        'code': code,
        'verdict': verdict,
        'timestamp': time.strftime('%Y-%m-%d %H:%M:%S'),
    })


def judge_submission(problem_id, code):
    problem_id = safe_problem_id(problem_id)
    problem_path = os.path.join(PROBLEMS_DIR, problem_id)
    testbench_path = os.path.join(problem_path, 'tb.v')
    expected_path = os.path.join(problem_path, 'expected.txt')

    if not os.path.exists(testbench_path) or not os.path.exists(expected_path):
        return {'verdict': 'Internal Error', 'message': 'Problem test files are missing.'}

    submission_id, submission_path = build_submission_folder()
    source_path = os.path.join(submission_path, 'submission.v')
    binary_path = os.path.join(submission_path, 'simulation.out')
    waveform_path = os.path.join(submission_path, 'simulation.vcd')

    with open(source_path, 'w', encoding='utf-8') as handle:
        handle.write(code)

    start_time = time.perf_counter()

    try:
        compile_result = compile_verilog(source_path, testbench_path, binary_path)
    except FileNotFoundError:
        verdict = {
            'verdict': 'Tool Missing',
            'message': 'Icarus Verilog was not found. Install iverilog and vvp, then add them to PATH.',
            'submission_id': submission_id,
            'time_seconds': 0,
        }
        save_submission_result(submission_path, problem_id, code, verdict)
        return verdict
    except subprocess.TimeoutExpired:
        verdict = {
            'verdict': 'Time Limit Exceeded',
            'message': 'Compilation timed out.',
            'submission_id': submission_id,
            'time_seconds': round(time.perf_counter() - start_time, 3),
        }
        save_submission_result(submission_path, problem_id, code, verdict)
        return verdict

    if compile_result.returncode != 0:
        compile_output = (compile_result.stdout + compile_result.stderr).strip()
        verdict = {
            'verdict': 'Compilation Error',
            'message': compile_output or 'Compilation failed.',
            'compile_errors': parse_compile_errors(compile_output),
            'submission_id': submission_id,
            'time_seconds': round(time.perf_counter() - start_time, 3),
        }
        save_submission_result(submission_path, problem_id, code, verdict)
        return verdict

    try:
        run_result = run_simulation(binary_path)
    except subprocess.TimeoutExpired:
        verdict = {
            'verdict': 'Time Limit Exceeded',
            'message': 'Simulation timed out.',
            'submission_id': submission_id,
            'time_seconds': round(time.perf_counter() - start_time, 3),
        }
        save_submission_result(submission_path, problem_id, code, verdict)
        return verdict

    elapsed = round(time.perf_counter() - start_time, 3)

    if run_result.returncode != 0:
        verdict = {
            'verdict': 'Runtime Error',
            'message': run_result.stderr.strip() or run_result.stdout.strip() or 'Simulation failed.',
            'submission_id': submission_id,
            'time_seconds': elapsed,
        }
        save_submission_result(submission_path, problem_id, code, verdict)
        return verdict

    correct, actual_lines, expected_lines, compare_error = compare_output(run_result.stdout, expected_path)
    test_cases = build_test_cases(actual_lines, expected_lines)
    passed_tests = sum(1 for test_case in test_cases if test_case['passed'])
    if compare_error == 'expected_unknown':
        verdict = {
            'verdict': 'Internal Error',
            'message': 'Problem expected output contains unknown x/z values. Regenerate or repair this test before judging submissions.',
            'actual': actual_lines,
            'expected': expected_lines,
            'test_cases': test_cases,
            'passed_tests': passed_tests,
            'total_tests': len(test_cases),
            'hidden_tests': len(expected_lines),
            'raw_output': '\n'.join(actual_lines),
            'submission_id': submission_id,
            'time_seconds': elapsed,
        }
        save_submission_result(submission_path, problem_id, code, verdict)
        return verdict

    wrong_message = (
        'Your design produced unknown x/z output. Drive every output deterministically for all tested cases.'
        if compare_error == 'actual_unknown'
        else 'Output did not match expected results.'
    )
    verdict = {
        'verdict': 'Accepted' if correct else 'Wrong Answer',
        'message': 'Your design passed all hidden tests.' if correct else wrong_message,
        'actual': actual_lines,
        'expected': expected_lines,
        'test_cases': test_cases,
        'passed_tests': passed_tests,
        'total_tests': len(test_cases),
        'hidden_tests': len(expected_lines),
        'raw_output': '\n'.join(actual_lines),
        'submission_id': submission_id,
        'time_seconds': elapsed,
    }

    if os.path.exists(waveform_path):
        verdict['waveform_url'] = f'/api/waveform/{submission_id}'

    save_submission_result(submission_path, problem_id, code, verdict)
    return verdict
