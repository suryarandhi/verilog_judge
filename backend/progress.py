from datetime import datetime, timedelta

from flask import Blueprint, jsonify, request, session

from auth import login_required
from db import get_connection

progress_bp = Blueprint('progress', __name__, url_prefix='/api')


def _clamp_int(value, default=0):
    try:
        return int(value)
    except (TypeError, ValueError):
        return default


def _clamp_float(value, default=0.0):
    try:
        return float(value)
    except (TypeError, ValueError):
        return default


@progress_bp.route('/me/progress', methods=['GET'])
@login_required
def get_my_progress():
    conn = get_connection()
    try:
        rows = conn.execute(
            'SELECT problem_id, accepted, accepted_at, last_accepted_at '
            'FROM user_progress WHERE user_id = ?',
            (session['user_id'],),
        ).fetchall()
    finally:
        conn.close()

    progress = {
        row['problem_id']: {
            'accepted': bool(row['accepted']),
            'acceptedAt': row['accepted_at'],
            'lastAcceptedAt': row['last_accepted_at'],
        }
        for row in rows
    }
    return jsonify({'progress': progress})


@progress_bp.route('/me/stats', methods=['GET'])
@login_required
def get_my_stats():
    conn = get_connection()
    try:
        row = conn.execute(
            'SELECT streak_count, last_streak_day, accepted_count, best_streak '
            'FROM user_stats WHERE user_id = ?',
            (session['user_id'],),
        ).fetchone()
    finally:
        conn.close()

    if not row:
        return jsonify({'stats': {
            'streak_count': 0, 'last_streak_day': None,
            'accepted_count': 0, 'best_streak': 0,
        }})
    return jsonify({'stats': dict(row)})


@progress_bp.route('/progress/accept', methods=['POST'])
@login_required
def record_accepted():
    payload = request.get_json(silent=True) or {}
    problem_id = str(payload.get('problem_id', '')).strip()
    if not problem_id:
        return jsonify({'error': 'problem_id is required.'}), 400

    title = str(payload.get('title') or problem_id)
    score = _clamp_int(payload.get('score'))
    code_lines = _clamp_int(payload.get('code_lines'))
    solve_seconds = _clamp_int(payload.get('solve_seconds'))
    sim_time = _clamp_float(payload.get('sim_time'))

    user_id = session['user_id']
    now = datetime.utcnow().isoformat()
    today = datetime.utcnow().date().isoformat()
    yesterday = (datetime.utcnow().date() - timedelta(days=1)).isoformat()

    conn = get_connection()
    try:
        existing = conn.execute(
            'SELECT accepted_at FROM user_progress WHERE user_id = ? AND problem_id = ?',
            (user_id, problem_id),
        ).fetchone()
        first_accepted_at = existing['accepted_at'] if existing and existing['accepted_at'] else now

        conn.execute(
            '''INSERT INTO user_progress (user_id, problem_id, accepted, accepted_at, last_accepted_at)
               VALUES (?, ?, 1, ?, ?)
               ON CONFLICT(user_id, problem_id) DO UPDATE SET
                 accepted = 1,
                 last_accepted_at = excluded.last_accepted_at''',
            (user_id, problem_id, first_accepted_at, now),
        )

        # Keep only the best-scoring submission per problem, mirroring the
        # client-side local leaderboard scoring rule.
        best = conn.execute(
            'SELECT score FROM leaderboard_entries WHERE user_id = ? AND problem_id = ?',
            (user_id, problem_id),
        ).fetchone()
        if best is None or score > best['score']:
            conn.execute(
                '''INSERT INTO leaderboard_entries
                     (user_id, problem_id, title, score, code_lines, solve_seconds, sim_time, accepted_at)
                   VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                   ON CONFLICT(user_id, problem_id) DO UPDATE SET
                     title = excluded.title,
                     score = excluded.score,
                     code_lines = excluded.code_lines,
                     solve_seconds = excluded.solve_seconds,
                     sim_time = excluded.sim_time,
                     accepted_at = excluded.accepted_at''',
                (user_id, problem_id, title, score, code_lines, solve_seconds, sim_time, now),
            )

        stats_row = conn.execute(
            'SELECT streak_count, last_streak_day, best_streak FROM user_stats WHERE user_id = ?',
            (user_id,),
        ).fetchone()
        streak_count = stats_row['streak_count'] if stats_row else 0
        last_streak_day = stats_row['last_streak_day'] if stats_row else None
        best_streak = stats_row['best_streak'] if stats_row else 0

        if last_streak_day != today:
            streak_count = streak_count + 1 if last_streak_day == yesterday else 1
            last_streak_day = today
        best_streak = max(best_streak, streak_count)

        accepted_count = conn.execute(
            'SELECT COUNT(*) AS n FROM user_progress WHERE user_id = ? AND accepted = 1',
            (user_id,),
        ).fetchone()['n']

        conn.execute(
            '''INSERT INTO user_stats
                 (user_id, streak_count, last_streak_day, accepted_count, best_streak, updated_at)
               VALUES (?, ?, ?, ?, ?, ?)
               ON CONFLICT(user_id) DO UPDATE SET
                 streak_count = excluded.streak_count,
                 last_streak_day = excluded.last_streak_day,
                 accepted_count = excluded.accepted_count,
                 best_streak = excluded.best_streak,
                 updated_at = excluded.updated_at''',
            (user_id, streak_count, last_streak_day, accepted_count, best_streak, now),
        )
        conn.commit()
    finally:
        conn.close()

    return jsonify({
        'stats': {
            'streak_count': streak_count,
            'last_streak_day': last_streak_day,
            'accepted_count': accepted_count,
            'best_streak': best_streak,
        },
    })


@progress_bp.route('/leaderboard', methods=['GET'])
def leaderboard():
    conn = get_connection()
    try:
        rows = conn.execute(
            '''SELECT u.username AS username,
                      COALESCE(s.accepted_count, 0) AS accepted_count,
                      COALESCE(s.best_streak, 0) AS best_streak,
                      COALESCE(SUM(l.score), 0) AS total_score
               FROM users u
               LEFT JOIN user_stats s ON s.user_id = u.id
               LEFT JOIN leaderboard_entries l ON l.user_id = u.id
               GROUP BY u.id
               ORDER BY total_score DESC, accepted_count DESC
               LIMIT 20''',
        ).fetchall()
    finally:
        conn.close()
    return jsonify({'leaderboard': [dict(row) for row in rows]})
