import { Router } from "express";
import mongoose from "mongoose";
import { treeDataSheetSchemaModel } from "../models/tree_data_sheets_schema.js";
import {cloudinaryMiddleware} from "../middlewares/cloudinary.js";
const treeDataSheetRouter = Router();

treeDataSheetRouter.post("/new",
    async (req, res, next) => {
        const { project_id, specific_tree_id, tree_specie_id, description, latitude, longitude} = req.body;
        
        try{
            
            if (!project_id || !specific_tree_id) return res.status(400).json({ msg: "Error faltan uno o varios campos obligatorios"});
            
            const objectProjectId = mongoose.Types.ObjectId(project_id);

            const newTreeDataSheet = new treeDataSheetSchemaModel({project_id: objectProjectId, specific_tree_id: specific_tree_id, tree_specie_id: tree_specie_id, description: description, latitude: latitude, longitude: longitude,});
            const savedTreeDataSheet = await newTreeDataSheet.save();
            // Add the _id we need to process the image creation
            req.savedTreeDataSheetId = savedTreeDataSheet._id;
            // Call middleware
            next();
           

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
    },
    //Use cloudinary middleware
    cloudinaryMiddleware,
    async (req, res) => {
        // Add the returned cloudinary url to imageURL field
        await treeDataSheetSchemaModel.findByIdAndUpdate(req.savedTreeDataSheetId, { imageURL: req.cloudinaryUrl })
        return res.json({ msg: "Ficha de datos creada correctamente"});
    }
);

/**
 * Express route handler that updates a tree data sheet by ID with the provided image data,
 * which is uploaded to Cloudinary using the `cloudinaryMiddleware` middleware.
 * 
 * @param {object} req - The Express request object.
 * @param {object} res - The Express response object.
 * @returns {void}
 */
treeDataSheetRouter.put("/update/:id",
    //Use cloudinary middleware
    cloudinaryMiddleware,
    async (req, res) => {

        const { id } = req.params;
        const  { _id, project_id, specific_tree_id, tree_specie_id, description, latitude, longitude} = req.body;

        try {
            // Save the image url that provides cloudinary middleware (could be empty)
            let imageURL = req.cloudinaryUrl || '';
            console.log(imageURL);
            const treeDataSheet = await treeDataSheetSchemaModel.findByIdAndUpdate(id, { project_id, specific_tree_id, tree_specie_id, description, latitude, longitude, imageURL: imageURL}, { new: false });

            if (!treeDataSheet) {
                return res.status(404).json({ error: 'Ficha de datos no encontrada' });
            }

            res.send(treeDataSheet);

        } catch (error) {
            console.error(error);
            return res.status(500).json({error: error.message});
        }

    }
)

/**
 * Express route handler that deletes a tree data sheet by ID.
 * 
 * @param {object} req - The Express request object.
 * @param {object} res - The Express response object.
 * @returns {void}
 */
treeDataSheetRouter.delete("/delete/:id",
    async (req, res) => {

        const { id} = req.params;

        try {
            const treeDataSheet = await treeDataSheetSchemaModel.findByIdAndDelete(id);
            if (!treeDataSheet) {
                return res.status(404).json({ error: 'Ficha de datos no encontrada' });
            }

            res.json({ msg: 'Ficha de datos eliminada correctamente' });

        } catch (error) {
            console.error(error);
            return res.status(500).json({error: error.message});
        }
    }
)

/**
 * Express route handler that retrieves an specific data sheet
 * 
 * @param {object} req - The Express request object.
 * @param {object} res - The Express response object.
 * @returns {void}
 */
treeDataSheetRouter.get("/:id",
    async (req, res) => {
        const { _id } = req.params;

        const treeDataSheet = await treeDataSheetSchemaModel.findById(_id).exec();
        if(!treeDataSheet) return res.status(404).send("La ficha de datos no existe");

        return res.send(treeDataSheet);
    }
);

/**
 * Express route handler that retrieves all tree data sheets associated with a particular project.
 * 
 * @param {object} req - The Express request object.
 * @param {object} res - The Express response object.
 * @returns {void}
 */
treeDataSheetRouter.get("/project/:project_id",
    async (req, res) => {
        const { project_id } = req.params;
        
        const treeDataSheets = await treeDataSheetSchemaModel.find({project_id: project_id}).exec();
        if(!treeDataSheets) return res.status(404).send("El proyecto no tiene fichas de datos");
        return res.send(treeDataSheets);
    }
);



export default treeDataSheetRouter;