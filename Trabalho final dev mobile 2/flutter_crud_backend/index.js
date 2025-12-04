require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
});

db.connect(err => {
  if (err) throw err;
  console.log('Banco de dados conectado!');
});

// ------------------- ROTAS CLIENTES -------------------

// Listar clientes
app.get('/clientes', (req, res) => {
  db.query('SELECT * FROM clientes', (err, results) => {
    if (err) return res.status(500).json(err);
    res.json(results);
  });
});

// Adicionar cliente
app.post('/clientes', (req, res) => {
  const data = req.body;
  db.query('INSERT INTO clientes SET ?', data, (err, results) => {
    if (err) return res.status(500).json(err);
    res.json({ id: results.insertId, ...data });
  });
});

// Atualizar cliente
app.put('/clientes/:id', (req, res) => {
  const id = req.params.id;
  const data = req.body;
  db.query('UPDATE clientes SET ? WHERE id = ?', [data, id], (err) => {
    if (err) return res.status(500).json(err);
    res.json({ message: 'Cliente atualizado!' });
  });
});

// Deletar cliente
app.delete('/clientes/:id', (req, res) => {
  const id = req.params.id;
  db.query('DELETE FROM clientes WHERE id = ?', id, (err) => {
    if (err) return res.status(500).json(err);
    res.json({ message: 'Cliente removido!' });
  });
});

// ------------------- ROTAS PRODUTOS -------------------

// Listar produtos
app.get('/produtos', (req, res) => {
  db.query('SELECT * FROM produtos', (err, results) => {
    if (err) return res.status(500).json(err);
    res.json(results);
  });
});

// Adicionar produto
app.post('/produtos', (req, res) => {
  const data = req.body;
  // Garantir que data_atualizado seja definida
  if (!data.data_atualizado) {
    data.data_atualizado = new Date().toISOString().slice(0, 19).replace('T', ' ');
  }
  db.query('INSERT INTO produtos SET ?', data, (err, results) => {
    if (err) return res.status(500).json(err);
    res.json({ id: results.insertId, ...data });
  });
});

// Atualizar produto
app.put('/produtos/:id', (req, res) => {
  const id = req.params.id;
  const data = req.body;
  // Sempre atualizar data_atualizado quando modificar
  data.data_atualizado = new Date().toISOString().slice(0, 19).replace('T', ' ');
  db.query('UPDATE produtos SET ? WHERE id = ?', [data, id], (err) => {
    if (err) return res.status(500).json(err);
    res.json({ message: 'Produto atualizado!' });
  });
});

// Deletar produto
app.delete('/produtos/:id', (req, res) => {
  const id = req.params.id;
  db.query('DELETE FROM produtos WHERE id = ?', id, (err) => {
    if (err) return res.status(500).json(err);
    res.json({ message: 'Produto removido!' });
  });
});

// ------------------- INICIAR SERVIDOR -------------------
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Servidor rodando na porta ${PORT}`));
