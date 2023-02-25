import mongoose from "mongoose";

const treeSpeciesSchema = mongoose.Schema(
    {
       name: {
        required: true,
        type: String,
        trim: true
       },
       description: {
        required: false,
        type: String,
        trim: true
       },
       image: Buffer
    }
);

export const treeSpeciesModel = mongoose.model(TreeSpecies, treeSpeciesSchema);
export default treeSpeciesModel;