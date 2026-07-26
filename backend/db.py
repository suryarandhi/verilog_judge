import os
import sqlite3

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.environ.get('DATA_DIR', BASE_DIR)
DB_PATH = os.path.join(DATA_DIR, 'verilog_judge.db')


def get_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute('PRAGMA foreign_keys = ON')
    return conn


def init_db():
    conn = get_connection()
    try:
        conn.executescript('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT UNIQUE NOT NULL,
                password_hash TEXT NOT NULL,
                created_at TEXT NOT NULL DEFAULT (datetime('now'))
            );

            CREATE TABLE IF NOT EXISTS user_progress (
                user_id INTEGER NOT NULL,
                problem_id TEXT NOT NULL,
                accepted INTEGER NOT NULL DEFAULT 0,
                accepted_at TEXT,
                last_accepted_at TEXT,
                PRIMARY KEY (user_id, problem_id),
                FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
            );

            CREATE TABLE IF NOT EXISTS user_stats (
                user_id INTEGER PRIMARY KEY,
                streak_count INTEGER NOT NULL DEFAULT 0,
                last_streak_day TEXT,
                accepted_count INTEGER NOT NULL DEFAULT 0,
                best_streak INTEGER NOT NULL DEFAULT 0,
                updated_at TEXT,
                FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
            );

            CREATE TABLE IF NOT EXISTS leaderboard_entries (
                user_id INTEGER NOT NULL,
                problem_id TEXT NOT NULL,
                title TEXT,
                score INTEGER NOT NULL DEFAULT 0,
                code_lines INTEGER NOT NULL DEFAULT 0,
                solve_seconds INTEGER NOT NULL DEFAULT 0,
                sim_time REAL NOT NULL DEFAULT 0,
                accepted_at TEXT,
                PRIMARY KEY (user_id, problem_id),
                FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
            );
        ''')
        conn.commit()
    finally:
        conn.close()
