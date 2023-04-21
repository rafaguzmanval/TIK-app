import mongoose from "mongoose";
import treeDataSheetSchemaModel from "./tree_data_sheets_schema.js";
import {deleteCloudinaryFolder} from "../middlewares/cloudinary.js";

const projectSchema = mongoose.Schema(
    {
       name: {
        required: true,
        unique: false,
        type: String,
        trim: true
       },
       description: {
        required: false,
        type: String,
        trim: true
       },

       user_id: {
        required: true,
        type: mongoose.Types.ObjectId,
        ref: "Users"
       }
    //    tree_data_sheets_id: [{
    //     type: mongoose.Schema.Types.ObjectId,
    //     ref: "TreeDataSheets"
    //    }]
    }
);

// Dont allow duplicated projects with same name and user id
projectSchema.index({ user_id: 1, name: 1 }, { unique: true });


// Delete all the tree data sheets associated
projectSchema.pre('findOneAndDelete', async function(next) {
    try {
        const doc = this;
        await treeDataSheetSchemaModel.deleteMany({ project_id: doc._conditions._id });

        // Delete cloudinary folder that contains all the images of the project datasheets
        await deleteCloudinaryFolder(doc._conditions._id);
        next();
    } catch (err) {
        next(err);
    }
});
  

export const projectSchemaModel = mongoose.model("Projects", projectSchema);
export default projectSchemaModel;