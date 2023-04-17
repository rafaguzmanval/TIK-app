import mongoose from "mongoose";

const treeDataSheetSchema = mongoose.Schema(
    {
       project_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Projects",
        required: true
       },
       specific_tree_id: {
        unique: false,
        type: String,
        trim: true,
        required: true
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
       latitude: {
        type: Number,
        required: false
       },
       longitude: {
        type: Number,
        required: true
       },
       image: {
        type: Buffer,
        required: false
      },
       
    }
);

treeDataSheetSchema.index({ project_id: 1, specific_tree_id: 1 }, { unique: true });


export const treeDataSheetSchemaModel = mongoose.model("TreeDataSheets", treeDataSheetSchema);
export default treeDataSheetSchemaModel;