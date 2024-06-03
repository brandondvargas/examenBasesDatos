# examenBasesDatos
Examen Unidad 5 - Administración de Bases de Datos

RavenDB - Brandon Vargas

Se intento conectar la base de datos utilizando php y Nodejs. No se pudo conectar a traves del usuario admin,
pero si con root, aunque hay que configurar el puerto. Se dejo de conectar por algun error, por lo que no hay GUI, solamente 
un endpoint que devuelve los 10 registros de film.

Se implemento las transacciones y excepciones en los procedimientos, junto al de update_film. Se anexaron ambos
como SQL, ya que parecen dar conflicto en ocasiones, al igual que los Usuarios.

## Para correr el proyecto:

1 - Instalar Nodejs

2 - En la carpeta del proyecto utilizar el comando: npm init

3 - Instalar las dependencias con el comando: npm install express mysql2 dotenv

4 - Correr app.js con el comando: node app.js
