import { Router } from "express";
import { treeDataSheetSchemaModel } from "../models/tree_data_sheets_schema.js";

const treeDataSheetRouter = Router();

treeDataSheetRouter.get("/:id",
    async (req, res) => {
        const { _id } = req.params;

        const treeDataSheet = await treeDataSheetSchemaModel.findById(_id).exec();
        if(!treeDataSheet) return res.status(404).send("La ficha de datos no existe");

        return res.send(treeDataSheet);
    }
);

export default treeDataSheetRouter;