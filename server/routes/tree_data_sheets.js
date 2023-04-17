import { Router } from "express";
import mongoose from "mongoose";
import { treeDataSheetSchemaModel } from "../models/tree_data_sheets_schema.js";

const treeDataSheetRouter = Router();

treeDataSheetRouter.post("/new",
    async (req, res) => {
        const { project_id, specific_tree_id, tree_specie_id, description, latitude, longitude} = req.body;

        try{
            
            if (!project_id || !specific_tree_id) return res.status(400).json({ msg: "Error faltan uno o varios campos obligatorios"});
            
            const objectProjectId = mongoose.Types.ObjectId(project_id);
            
            const newTreeDataSheet = new treeDataSheetSchemaModel({project_id: objectProjectId, specific_tree_id: specific_tree_id, tree_specie_id: tree_specie_id, description: description, latitude: latitude, longitude: longitude});

            await newTreeDataSheet.save();

            return res.json({ msg: "Ficha de datos creada correctamente"});

        } catch(err){
            // 11000 Error code of duplicated index
            if(err.code == '11000')
            {
                return res.status(500).json({error: "Ya existe una ficha de datos con mismo ID de árbol y especie"}); 
            }
            else
            {
                return res.status(500).json({error: err.message});
            }
        }
    }
);

treeDataSheetRouter.put("/update/:id",
    async (req, res) => {

        const { id } = req.params;
        const  { project_id, specific_tree_id, tree_specie_id, description, latitude, longitude, image } = req.body;
        console.log(image);
        try {
            const treeDataSheet = await treeDataSheetSchemaModel.findByIdAndUpdate(id, { project_id, specific_tree_id, tree_specie_id, description, latitude, longitude, image }, { new: false });

            if (!treeDataSheet) {
                return res.status(404).json({ error: 'Ficha de datos no encontrada' });
            }

            res.send(treeDataSheet);

        } catch (error) {
            console.error(error);
            return res.status(500).json({error: err.message});
        }

    }
)

treeDataSheetRouter.delete("/delete/:id",
    async (req, res) => {

        const { id } = req.params;

        try {
            const treeDataSheet = await treeDataSheetSchemaModel.findByIdAndDelete(id);
            if (!treeDataSheet) {
                return res.status(404).json({ error: 'Ficha de datos no encontrada' });
            }

            res.json({ mensaje: 'Ficha de datos eliminada correctamente' });

        } catch (error) {
            console.error(error);
            return res.status(500).json({error: err.message});
        }
    }
)

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