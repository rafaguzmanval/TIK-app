import { Router } from "express";
import { projectSchemaModel } from "../models/project_schema.js";

const projectRouter = Router();

projectRouter.get("/:id",
    async (req, res) => {
        const { _id } = req.params;

        const project = await projectSchemaModel.findById(_id).exec();
        if(!project) return res.status(404).send("La ficha de datos no existe");

        return res.send(project);
    }
);

projectRouter.post("/new", 
    async (req, res) => {
        const { name } = req.body;

        try{
            
            if (!name) return res.status(400).json({ msg: "Error falta el campo nombre por recibir"});

            const project = await projectSchemaModel.findOne({name: name}).exec();

            if (project) return res.status(409).json({ msg: "El proyecto con ese mismo nombre ya se encuentra registrado"});

            // Rellenamos los campos requeridos en el esquema
            const newProject = new projectSchemaModel({name});

            // Es una promesa
            await newProject.save();

            return res.json({ msg: "Proyecto creado correctamente"});

        } catch(err){
            return res.status(500).json({error: err.message});
        }
    }
);

export default projectRouter;