import express from 'express';
import cookieParser from "cookie-parser";
import dotenv from 'dotenv';
import authUserRouter from './routes/auth_users.js';
import treeSpeciesRouter from './routes/tree_species.js';
import treeSpeciesRouter from './routes/tree_data_sheets';
import mongoose from 'mongoose';
import treeDataSheetRouter from './routes/tree_data_sheets';

// Cargamos valores de .env en process
dotenv.config();

const PORT = process.env.PORT;
const MONGODB_URL = process.env.MONGODB_URL;

const expressApp = express();

console.clear();

expressApp.use(cookieParser());
expressApp.use(express.json());
expressApp.use(express.text());

// expressApp.use("/auth-token", authTokenRouter);
expressApp.use("/accounts", authUserRouter);
expressApp.use("/treespecies", treeSpeciesRouter);
expressApp.use("/treedatasheets", treeDataSheetRouter);

// Esta funcion e spara arrancar la app ya que connect es async
const bootstrap = async () =>{
    // Conectamos a BBDD
    await mongoose.connect(MONGODB_URL);

    expressApp.listen(PORT, () => {
        console.log(`Bienvenido desde el puerto ${PORT}`);
    });

}

bootstrap();
