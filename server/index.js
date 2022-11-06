import express from 'express';
import cookieParser from "cookie-parser";
import dotenv from 'dotenv';
import authTokenRouter from "./routes/auth_token.js";
import accountRouter from "./routes/accounts.js";
import mongoose from 'mongoose';

// Cargamos valores de .env en process
dotenv.config();

const PORT = process.env.PORT;
const MONGODB_URL = process.env.MONGODB_URL;

const expressApp = express();

console.clear();

expressApp.use(cookieParser());
expressApp.use(express.json());
expressApp.use(express.text());

expressApp.use("/auth-token", authTokenRouter);
expressApp.use("/accounts", accountRouter)

// Esta funcion e spara arrancar la app ya que connect es async
const bootstrap = async () =>{
    // Conectamos a BBDD
    await mongoose.connect(MONGODB_URL);

    expressApp.listen(PORT, () => {
        console.log(`Bienvenido desde el puerto ${PORT}`);
    });

    expressApp.post("/users", (req, res) =>{
        res.send("Has solicitado ver usuarios");
        console.log(req.body);
    });
}

bootstrap();

