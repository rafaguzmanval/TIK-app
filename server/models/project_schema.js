import mongoose from "mongoose";
import treeDataSheetSchemaModel from "./tree_data_sheets_schema.js";

const projectSchema = mongoose.Schema(
    {
       name: {
        required: true,
        unique: true,
        type: String,
        trim: true
       },
       description: {
        required: false,
        type: String,
        trim: true
       },
    //    tree_data_sheets_id: [{
    //     type: mongoose.Schema.Types.ObjectId,
    //     ref: "TreeDataSheets"
    //    }]
    }
);

// Delete all the tree data sheets associated
projectSchema.pre('findOneAndDelete', async function(next) {
    try {
        const doc = this;
        await treeDataSheetSchemaModel.deleteMany({ project_id: doc._conditions._id });
        next();
    } catch (err) {
        next(err);
    }
  });

export const projectSchemaModel = mongoose.model("Projects", projectSchema);
export default projectSchemaModel;