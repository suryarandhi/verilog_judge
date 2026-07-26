import re
from functools import wraps

from flask import Blueprint, jsonify, request, session
from werkzeug.security import check_password_hash, generate_password_hash

from db import get_connection

auth_bp = Blueprint('auth', __name__, url_prefix='/api/auth')

USERNAME_RE = re.compile(r'^[a-zA-Z0-9_]{3,24}$')


def login_required(view):
    @wraps(view)
    def wrapped(*args, **kwargs):
        if not session.get('user_id'):
            return jsonify({'error': 'Sign in required.'}), 401
        return view(*args, **kwargs)
    return wrapped


def current_user():
    if not session.get('user_id'):
        return None
    return {'id': session['user_id'], 'username': session['username']}


@auth_bp.route('/register', methods=['POST'])
def register():
    payload = request.get_json(silent=True) or {}
    username = str(payload.get('username', '')).strip()
    password = str(payload.get('password', ''))

    if not USERNAME_RE.match(username):
        return jsonify({'error': 'Username must be 3-24 characters: letters, numbers, underscore.'}), 400
    if len(password) < 6:
        return jsonify({'error': 'Password must be at least 6 characters.'}), 400

    conn = get_connection()
    try:
        existing = conn.execute('SELECT id FROM users WHERE username = ?', (username,)).fetchone()
        if existing:
            return jsonify({'error': 'That username is already taken.'}), 409

        password_hash = generate_password_hash(password)
        cursor = conn.execute(
            'INSERT INTO users (username, password_hash) VALUES (?, ?)',
            (username, password_hash),
        )
        user_id = cursor.lastrowid
        conn.execute(
            'INSERT INTO user_stats (user_id, streak_count, accepted_count, best_streak) VALUES (?, 0, 0, 0)',
            (user_id,),
        )
        conn.commit()
    finally:
        conn.close()

    session.clear()
    session.permanent = True
    session['user_id'] = user_id
    session['username'] = username
    return jsonify({'user': {'id': user_id, 'username': username}}), 201


@auth_bp.route('/login', methods=['POST'])
def login():
    payload = request.get_json(silent=True) or {}
    username = str(payload.get('username', '')).strip()
    password = str(payload.get('password', ''))

    conn = get_connection()
    try:
        row = conn.execute(
            'SELECT id, username, password_hash FROM users WHERE username = ?',
            (username,),
        ).fetchone()
    finally:
        conn.close()

    if not row or not check_password_hash(row['password_hash'], password):
        return jsonify({'error': 'Invalid username or password.'}), 401

    session.clear()
    session.permanent = True
    session['user_id'] = row['id']
    session['username'] = row['username']
    return jsonify({'user': {'id': row['id'], 'username': row['username']}})


@auth_bp.route('/logout', methods=['POST'])
def logout():
    session.clear()
    return jsonify({'ok': True})


@auth_bp.route('/me', methods=['GET'])
def me():
    return jsonify({'user': current_user()})
