import mongoose from "mongoose";

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

export const projectSchemaModel = mongoose.model("Projects", projectSchema);
export default projectSchemaModel;