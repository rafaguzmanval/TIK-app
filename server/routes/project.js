import { Router } from "express";
import { projectSchemaModel } from "../models/project_schema.js";

const projectRouter = Router();


projectRouter.get("/getall",
    async (req, res) => {

        const resultados = await projectSchemaModel.find({})
        if(!resultados) return res.status(404).send("No se han podido recuperar las especies de árboles");

        return res.send(resultados);
    }
);

projectRouter.get("/:id",
    async (req, res) => {
        const { id } = req.params;
        console.log(req.params)
        const project = await projectSchemaModel.findById(id).exec();
        if(!project) return res.status(404).send("El proyecto no existe");

        return res.send(project);
    }
);

projectRouter.post("/new", 
    async (req, res) => {
        const { name, description } = req.body;

        try{
            
            if (!name) return res.status(400).json({ msg: "Error falta el campo nombre por recibir"});

            const project = await projectSchemaModel.findOne({name: name}).exec();

            if (project) return res.status(409).json({ msg: "El proyecto con ese mismo nombre ya se encuentra registrado"});

            // Rellenamos los campos requeridos en el esquema
            const newProject = new projectSchemaModel({name, description});

            // Es una promesa
            await newProject.save();

            return res.json({ msg: "Proyecto creado correctamente"});

        } catch(err){
            return res.status(500).json({error: err.message});
        }
    }
);

export default projectRouter;