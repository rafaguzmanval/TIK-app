import { Router } from "express";
import { readFileSync  } from 'fs';
import { treeSpeciesModel } from "../models/tree_species_schema.js";

const treeSpeciesRouter = Router();

treeSpeciesRouter.get("/getall",
    async (req, res) => {
        const { _id } = req.params;

        const resultados = await treeSpeciesModel.find({})
        if(!resultados) return res.status(404).send("No se han podido recuperar las especies de árboles");

        return res.send(resultados);
    }
);

treeSpeciesRouter.get("/:id",
    async (req, res) => {
        const { _id } = req.params;

        const treeSpecie = await treeSpeciesModel.findById(_id).exec();
        if(!treeSpecie) return res.status(404).send("La especie de árbol no existe");

        return res.send(treeSpecie);
    }
);

treeSpeciesRouter.post("/new",
    async (req, res) => {
        const { name, description, image} = req.body;
        try{
    
            if (!name) return res.status(400).json({ msg: "Error falta el campo nombre"});
        
            //WARNING: THIS SHOULD BE IN THE LOGIC OF THE APP NOT NODE SERVER
            // if(!image)
            // {
            //     const ima = readFileSync('default.jpg');
            // }
            // console.log(ima);
            // END OF WARNING

            // Se pone exec para convertirlo en promesa aunque si no lo pones
            // Mongoose lo hace en su implementacion
            const treeSpecie = await treeSpeciesModel.findOne({name: name}).exec();
        
            if (treeSpecie) return res.status(409).json({ msg: "La especia de árbol ya se encuentra registrada"});
        
            // Rellenamos los campos requeridos en el esquema
            const newTreeSpecie = new treeSpeciesModel({name, description, image});
        
            // Es una promesa
            await newTreeSpecie.save();
        
            return res.json({ msg: "Nueva especie de árbol registrada correctamente"});
        
          } catch(err){
            return res.status(500).json({error: err.message});
          }
    }

);

export default treeSpeciesRouter;