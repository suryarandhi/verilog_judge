import os

from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS

from judge import PROBLEMS_DIR, judge_submission, load_problem, load_problem_list
from utils import ensure_dir


BASE_DIR = os.path.dirname(os.path.abspath(__file__))
FRONTEND_DIR = os.path.abspath(os.path.join(BASE_DIR, '..', 'frontend'))
SUBMISSIONS_DIR = os.path.join(BASE_DIR, 'submissions')

ensure_dir(FRONTEND_DIR)
ensure_dir(SUBMISSIONS_DIR)

app = Flask(__name__, static_folder=FRONTEND_DIR, static_url_path='')
CORS(app)


@app.route('/')
def index():
    return app.send_static_file('index.html')


@app.route('/problem.html')
def problem_page():
    return app.send_static_file('problem.html')


@app.route('/api/problems', methods=['GET'])
def api_list_problems():
    return jsonify({'problems': load_problem_list()})


@app.route('/api/problems/<problem_id>', methods=['GET'])
def api_get_problem(problem_id):
    problem = load_problem(problem_id)
    if problem is None:
        return jsonify({'error': 'Problem not found.'}), 404
    return jsonify(problem)


@app.route('/api/submit/<problem_id>', methods=['POST'])
def api_submit(problem_id):
    payload = request.get_json(silent=True) or {}
    code = payload.get('code', '')
    if not isinstance(code, str):
        return jsonify({'error': 'The code field must be a string.'}), 400
    code = code.strip()
    if not code:
        return jsonify({'error': 'No Verilog code submitted.'}), 400

    return jsonify(judge_submission(problem_id, code))


@app.route('/api/solution/<problem_id>', methods=['GET'])
def api_solution(problem_id):
    problem = load_problem(problem_id)
    if problem is None:
        return jsonify({'error': 'Problem not found.'}), 404

    attempts = request.args.get('attempts', type=int, default=0)
    accepted = request.args.get('accepted', '').lower() == 'true'
    if attempts < 3 and not accepted:
        return jsonify({
            'error': 'Official solution unlocks after three attempts or after acceptance.',
            'remaining_attempts': 3 - attempts,
        }), 403

    solution_file = os.path.join(PROBLEMS_DIR, os.path.basename(problem_id), 'solution.v')
    if not os.path.exists(solution_file):
        return jsonify({'error': 'Official solution is not available for this problem.'}), 404

    with open(solution_file, 'r', encoding='utf-8') as handle:
        return jsonify({'problem_id': problem_id, 'solution': handle.read()})


@app.route('/api/waveform/<submission_id>', methods=['GET'])
def api_waveform(submission_id):
    submission_path = os.path.join(SUBMISSIONS_DIR, os.path.basename(submission_id))
    waveform_file = os.path.join(submission_path, 'simulation.vcd')
    if not os.path.exists(waveform_file):
        return jsonify({'error': 'Waveform not found.'}), 404
    return send_from_directory(submission_path, 'simulation.vcd', as_attachment=True)


@app.errorhandler(404)
def not_found(error):
    if request.path.startswith('/api/'):
        return jsonify({'error': 'Resource not found.'}), 404
    return app.send_static_file('index.html')


if __name__ == '__main__':
    app.run(debug=True, port=5000, use_reloader=False)
