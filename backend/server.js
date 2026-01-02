const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const mysql = require('mysql2');
const dotenv = require('dotenv');
dotenv.config();
const app = express();
app.use(cors());
app.use(bodyParser.json());

const ssl =
  process.env.DB_ENABLE_SSL === "true"
    ? {
        minVersion: "TLSv1.2",
        // For TiDB Cloud Starter, you usually DON'T need a CA file
        // because Node trusts the public CA by default. :contentReference[oaicite:2]{index=2}
        ca: process.env.DB_CA_PATH
          ? fs.readFileSync(process.env.DB_CA_PATH)
          : undefined,
      }
    : null;

const db = mysql.createPool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT || 4000),
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  ssl,
});

db.getConnection((err) => {
  if (err) {
    console.error("Database connection failed:", err);
  } else {
    console.log("Connected to MySQL database");
  }
});

app.get('/', (_req, res) => {
  res.json({ status: 'Kids Colors Game API is running' });
});

app.post('/api/users', (req, res) => {
  const { name } = req.body;
  if (!name || !name.trim()) {
    return res.status(400).json({ message: 'Name is required' });
  }

  const sql = 'INSERT INTO users (name) VALUES (?)';
  db.query(sql, [name.trim()], (err, result) => {
    if (err) {
      console.error('POST /api/users error:', err);
      return res.status(500).json({ message: 'Failed to create user' });
    }
    res.status(201).json({ id: result.insertId, name: name.trim() });
  });
});

app.get('/api/users', (_req, res) => {
  db.query('SELECT id, name FROM users ORDER BY id DESC', (err, rows) => {
    if (err) {
      console.error('GET /api/users error:', err);
      return res.status(500).json({ message: 'Failed to fetch users' });
    }
    res.json(rows);
  });
});

app.post('/api/quiz_results', (req, res) => {
  const { user_id, score } = req.body;
  if (!user_id || score === undefined) {
    return res.status(400).json({ message: 'user_id and score are required' });
  }

  const checkUserSql = 'SELECT id FROM users WHERE id = ?';
  db.query(checkUserSql, [user_id], (userErr, users) => {
    if (userErr) {
      console.error('POST /api/quiz_results user check error:', userErr);
      return res.status(500).json({ message: 'Failed to validate user' });
    }
    if (users.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    const insertSql = 'INSERT INTO quiz_results (user_id, score) VALUES (?, ?)';
    db.query(insertSql, [user_id, score], (err, result) => {
      if (err) {
        console.error('POST /api/quiz_results error:', err);
        return res.status(500).json({ message: 'Failed to save quiz result' });
      }
      res.status(201).json({ id: result.insertId, user_id, score });
    });
  });
});

app.get('/api/quiz_results', (_req, res) => {
  const sql = `
    SELECT qr.id, qr.user_id, u.name AS user_name, qr.score, qr.taken_at
    FROM quiz_results qr
    LEFT JOIN users u ON u.id = qr.user_id
    ORDER BY qr.taken_at DESC`;

  db.query(sql, (err, rows) => {
    if (err) {
      console.error('GET /api/quiz_results error:', err);
      return res.status(500).json({ message: 'Failed to fetch quiz results' });
    }
    res.json(rows);
  });
});

app.get('/api/quiz_results/:user_id', (req, res) => {
  const sql = `
    SELECT qr.id, qr.user_id, u.name AS user_name, qr.score, qr.taken_at
    FROM quiz_results qr
    LEFT JOIN users u ON u.id = qr.user_id
    WHERE qr.user_id = ?
    ORDER BY qr.taken_at DESC`;

  db.query(sql, [req.params.user_id], (err, rows) => {
    if (err) {
      console.error('GET /api/quiz_results/:user_id error:', err);
      return res.status(500).json({ message: 'Failed to fetch user quiz results' });
    }
    res.json(rows);
  });
});

app.get('/api/leaderboard', (_req, res) => {
  const sql = `
    SELECT qr.id, qr.user_id, u.name AS user_name, qr.score, qr.taken_at
    FROM quiz_results qr
    LEFT JOIN users u ON u.id = qr.user_id
    ORDER BY qr.score DESC, qr.taken_at ASC
    LIMIT 10`;

  db.query(sql, (err, rows) => {
    if (err) {
      console.error('GET /api/leaderboard error:', err);
      return res.status(500).json({ message: 'Failed to fetch leaderboard' });
    }
    res.json(rows);
  });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

