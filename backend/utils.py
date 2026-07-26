import json
import os


def ensure_dir(path):
    os.makedirs(path, exist_ok=True)


def read_json_file(path):
    with open(path, 'r', encoding='utf-8') as handle:
        return json.load(handle)


def save_json_file(path, data):
    with open(path, 'w', encoding='utf-8') as handle:
        json.dump(data, handle, indent=2)


def safe_problem_id(problem_id):
    return os.path.basename(str(problem_id))
