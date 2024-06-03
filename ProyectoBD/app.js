require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');

const app = express();
const port = 3000;

// Crear la conexión a la base de datos
const db = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "ravenvideo",
});

// Conectar a la base de datos
db.connect((err) => {
    if (err) {
        console.error('Error al conectar a la base de datos:', err);
        return;
    }
    console.log('Conectado a la base de datos MySQL');
});

// Ruta de prueba para obtener todos los usuarios
app.get('/usuarios', (req, res) => {
    db.query('SELECT * FROM actor', (err, results) => {
        if (err) {
            return res.status(500).send('Error al obtener los usuarios');
        }
        res.json(results);
    });
});

app.get('/lista-peliculas', (req, res) => {
    db.query('SELECT * FROM film', (err, results) => {
        if (err) {
            return res.status(500).send('Error al obtener las peliculas');
        }
        res.json(results);
    });
});

app.get('/ultimos-films', (req, res) => {
    const query = 'SELECT * FROM film ORDER BY film_id DESC LIMIT 10';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al obtener los registros:', err);
            return res.status(500).send('Error al obtener los registros');
        }
        res.json(results);
    });
});

// Iniciar el servidor
app.listen(port, () => {
    console.log(`Servidor escuchando en http://localhost:${port}`);
});
