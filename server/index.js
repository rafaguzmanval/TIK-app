import express from 'express';
import cookieParser from "cookie-parser";
import dotenv from 'dotenv';
import authUserRouter from './routes/auth_users.js';
import treeSpeciesRouter from './routes/tree_species.js';
import treeDataSheetRouter from './routes/tree_data_sheets.js';
import projectRouter from './routes/project.js';
import mongoose from 'mongoose';
import bodyParser from 'body-parser';
import cloudinary from 'cloudinary';

// Load .env values
dotenv.config();

const PORT = process.env.PORT;
const MONGODB_URL = process.env.MONGODB_URL;

const expressApp = express();
// Add body-paser middleware to establish json limit to 10mb
expressApp.use(bodyParser.json({limit: '10mb'}));

// Use .env variables to have access to Cloudinary API
cloudinary.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET
});


console.clear();

expressApp.use(cookieParser());
expressApp.use(express.json());
expressApp.use(express.text());

// expressApp.use("/auth-token", authTokenRouter);
expressApp.use("/accounts", authUserRouter);
expressApp.use("/treespecies", treeSpeciesRouter);
expressApp.use("/treedatasheets", treeDataSheetRouter);
expressApp.use("/projects", projectRouter);

// We need an async function in order to start the app
const bootstrap = async () =>{
    // Conectamos a BBDD
    await mongoose.connect(MONGODB_URL);

    expressApp.listen(PORT, () => {
        console.log(`Bienvenido desde el puerto ${PORT}`);
    });

}

bootstrap();
