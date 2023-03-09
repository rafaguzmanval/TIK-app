import { Router } from "express";
import mongoose from "mongoose";
import { treeDataSheetSchemaModel } from "../models/tree_data_sheets_schema.js";

const treeDataSheetRouter = Router();

treeDataSheetRouter.post("/new",
    async (req, res) => {
        const { project_id } = req.body;

        try{
            
            if (!project_id) return res.status(400).json({ msg: "Error falta el campo de proyecto asociado por recibir"});
            
            const objectProjectId = mongoose.Types.ObjectId(project_id);

            const newTreeDataSheet = new treeDataSheetSchemaModel({project_id: objectProjectId});

            await newTreeDataSheet.save();

            return res.json({ msg: "Ficha de datos creada correctamente"});

        } catch(err){
            return res.status(500).json({error: err.message});
        }
    }
);

treeDataSheetRouter.get("/:id",
    async (req, res) => {
        const { _id } = req.params;

        const treeDataSheet = await treeDataSheetSchemaModel.findById(_id).exec();
        if(!treeDataSheet) return res.status(404).send("La ficha de datos no existe");

        return res.send(treeDataSheet);
    }
);

treeDataSheetRouter.get("/project/:project_id",
    async (req, res) => {
        const { project_id } = req.params;

        const treeDataSheets = await treeDataSheetSchemaModel.find({project_id: project_id}).exec();
        if(!treeDataSheets) return res.status(404).send("El proyecto no tiene fichas de datos");

        return res.send(treeDataSheets);
    }
);



export default treeDataSheetRouter;