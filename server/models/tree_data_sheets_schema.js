import mongoose from "mongoose";

const treeDataSheetSchema = mongoose.Schema(
    {
       project_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Projects"
       },
       specific_tree_id: {
        unique: false,
        type: String,
        trim: true
       },
       tree_specie_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "TreeSpecies"
       },
       description: {
        required: false,
        type: String,
        trim: true
       },
       
    }
);

export const treeDataSheetSchemaModel = mongoose.model("TreeDataSheets", treeDataSheetSchema);
export default treeDataSheetSchemaModel;