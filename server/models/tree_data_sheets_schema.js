import mongoose from "mongoose";
import {deleteCloudinaryImage} from "../middlewares/cloudinary.js";

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
       imageURL: {
        type: String,
        required: false
      },
       
    }
);

treeDataSheetSchema.index({ project_id: 1, specific_tree_id: 1 }, { unique: true });

// Pre hook to delete the cloudinary image associated
treeDataSheetSchema.pre('findOneAndDelete', async function(next) {
  try {
    // Get tree data sheet project id
    let doc = await treeDataSheetSchemaModel.findById(this._conditions._id);
    // Delete the cloudinary image associated
    await deleteCloudinaryImage(doc.project_id + '/' +doc._id);
    next();
  } catch (err) {
      next(err);
  }
});

export const treeDataSheetSchemaModel = mongoose.model("TreeDataSheets", treeDataSheetSchema);
export default treeDataSheetSchemaModel;