import { Router } from "express";
import mongoose from "mongoose";
import { projectSchemaModel } from "../models/project_schema.js";

const projectRouter = Router();

projectRouter.post("/new", 
    async (req, res) => {
        const { user_id, name, description } = req.body;

        try{
            
            if (!name || !user_id) return res.status(400).json({ msg: "Error faltan campos por recibir"});

            const objectUserId = mongoose.Types.ObjectId(user_id);

            const project = await projectSchemaModel.findOne({name: name, user_id: objectUserId}).exec();

            if (project) return res.status(409).json({ msg: "El proyecto con ese mismo nombre asociado a este usuario ya se encuentra registrado"});

            const newProject = new projectSchemaModel({name, description, user_id: objectUserId});

            await newProject.save();

            return res.json({ msg: "Proyecto creado correctamente"});

        } catch(err){
            return res.status(500).json({error: err.message});
        }
    }
);

projectRouter.get("/getall",
    async (req, res) => {

        const resultados = await projectSchemaModel.find({})
        if(!resultados) return res.status(404).send("No se han podido proyectos");

        return res.send(resultados);
    }
);

projectRouter.get("/getall/:user_id",
    async (req, res) => {

        const { user_id } = req.params;
        
        const resultados = await projectSchemaModel.find({user_id: user_id});
        if(!resultados) return res.status(404).send("No se han podido proyectos");

        return res.send(resultados);
    }
);

projectRouter.get("/:id",
    async (req, res) => {
        const { id } = req.params;
        const project = await projectSchemaModel.findById(id).exec();
        if(!project) return res.status(404).send("El proyecto no existe");

        return res.send(project);
    }
);

projectRouter.delete("/delete/:id",
    async (req, res) => {

        const { id } = req.params;

        try {
            const project = await projectSchemaModel.findByIdAndDelete(id);
            if (!project) {
                return res.status(404).json({ error: 'Proyecto no encontrado' });
            }

            res.json({ mensaje: 'Proyectos eliminado correctamente' });

        } catch (error) {
            console.error(error);
            return res.status(500).json({error: err.message});
        }
    }
)



export default projectRouter;