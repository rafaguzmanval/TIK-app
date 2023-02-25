import { Router } from "express";
import { treeSpeciesModel } from "../models/tree_species_schema.js";

const treeSpeciesRouter = Router();

treeSpeciesRouter.get("/:id",
    async (req, res) => {
        const { _id } = req.params;

        const treeSpecie = await treeSpeciesModel.findById(_id).exec();
        if(!treeSpecie) return res.status(404).send("La especio de árbol no existe");

        return res.send(treeSpecie);
    }
);

export default treeSpeciesRouter;