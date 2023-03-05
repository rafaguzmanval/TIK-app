import { Router } from "express";
import { readFileSync  } from 'fs';
import { treeSpeciesModel } from "../models/tree_species_schema.js";

const treeSpeciesRouter = Router();

treeSpeciesRouter.get("/getall",
    async (req, res) => {
        const resultados = await treeSpeciesModel.find({})
        if(!resultados) return res.status(404).send("No se han podido recuperar las especies de árboles");

        return res.send(resultados);
    }
);

treeSpeciesRouter.get("/:id",
    async (req, res) => {
        const { id } = req.params;

        const treeSpecie = await treeSpeciesModel.findById(id).exec();
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
        
            if (treeSpecie) return res.status(409).json({ msg: "La especie de árbol ya se encuentra registrada"});
        
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

treeSpeciesRouter.post("/newlist",
    async (req, res) => {

        let speciesAdded = 0;
        const listJSON = req.body;
        for (const specie of listJSON) {
            try{
                const { name, description, image} = specie;

                if (!name) return console.log("Error falta el campo nombre");
            
                // Se pone exec para convertirlo en promesa aunque si no lo pones
                // Mongoose lo hace en su implementacion
                const treeSpecie = await treeSpeciesModel.findOne({name: name}).exec();
            
                if(treeSpecie)
                {
                    console.log("La especie de árbol ya se encuentra registrada: ", name);
                }
                else{
                    // Rellenamos los campos requeridos en el esquema
                    const newTreeSpecie = new treeSpeciesModel({name, description, image});
                    // Es una promesa
                    await newTreeSpecie.save();
                    speciesAdded++;
                }
            
              } catch(err){
                return res.status(500).json({error: err.message});
              }
        }
        return res.json({ msg: `${speciesAdded} nuevas especies de árboles registradas correctamente`});
    }
);

export default treeSpeciesRouter;