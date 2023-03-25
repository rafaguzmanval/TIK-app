import mongoose from "mongoose";
import bcryptjs from 'bcryptjs';
import projectSchemaModel from "./project_schema.js";

const SALT_ROUNDS = 10;

const userSchema = mongoose.Schema({
    name: {
        required: true,
        type: String,
        trim: true,
    },
    email: {
        required: true,
        type: String,
        trim: true,
        index: { unique: true },
        validate: {
            validator: (value) =>{
                const re = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);
            },
            message: "Por favor introduce un email válido",
        }
    },
    password: {
        required: true,
        type: String
    }
});

userSchema.pre("save", function(next) {
    let user = this;
    // Only hash the password if it has been modified
    if (!user.isModified('password')) return next();

    // Generate a salt
    bcryptjs.genSalt(SALT_ROUNDS, function(err, salt) {
        if (err) return next(err);

        // Hash the password
        bcryptjs.hash(user.password, salt, function(err, hash) {
            if (err) return next(err);

            user.password = hash;
            next();
        });
    });
});

userSchema.methods.comparePassword = function (password, callback){

    // Compare passwords
    bcryptjs.compare(password, this.password, (error, isMatch) => {
        // If there is any error then execute callback function with these params
        if(error)
            return callback(error, false);
        else
            callback(null, isMatch);
    });
}

// Delete all the projects associated
userSchema.pre('findOneAndDelete', async function(next){
    try{
        const user = this;
        await projectSchemaModel.deleteMany({user_id: user._condictions._id});
        next();
    }catch(err){
        next(err);
    }
});


export const userModel = mongoose.model("Users", userSchema);

export default userModel;