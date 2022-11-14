import { Router } from "express";
import { userModel } from "../models/user_schema.js"
import bcryptjs from 'bcryptjs';
import {SignJWT, jwtVerify} from "jose";
import auth from "../middlewares/auth.js";

const authUserRouter = Router();
const encoder = new TextEncoder();

//Obtener los detalles de una cuenta a partir del guid
authUserRouter.get("/:email", async (req, res) => {
  const { email } = req.params;

  const user = await userModel.findOne({email: email}).exec();
  if (!user) return res.status(404).send("El usuario no existe");

  return res.send(user);
});

//Obtener los detalles de una cuenta a partir del guid
authUserRouter.get("/:email/:password", async (req, res) => {
  const { email, password } = req.params;

  const user = await userModel.findOne({email: email}).exec();

  if (!user) return res.status(404).send("El usuario no existe");

  user.comparePassword(password, (error, isMatch) => {

    // If passwords do not match, show error
    if(!isMatch || error)
      return res.status(401).send("Contraseña incorrecta");
    else
      return res.send("Usuario logueado correctamente");

  });

});

// Register route
// Crear una nueva cuenta
authUserRouter.post("/register", async (req, res) => {
  const { name, email, password } = req.body;

  try{
    
    if (!email || !password || !name) return res.status(400).json({ msg: "Error faltan campos por recibir"});

    // Se pone exec para convertirlo en promesa aunque si no lo pones
    // Mongoose lo hace en su implementacion
    const user = await userModel.findOne({email: email}).exec();

    if (user) return res.status(409).json({ msg: "El usuario ya se encuentra registrado"});

    // Rellenamos los campos requeridos en el esquema
    const newUser = new userModel({name, email, password});

    // Es una promesa
    await newUser.save();

    return res.json({ msg: "Usuario registrado correctamente"});

  } catch(err){
    return res.status(500).json({error: err.message});
  }

});

// Login route
// Loguearse en cuenta a partir de email y contraseña
authUserRouter.post("/login", async (req, res) => {
  const { email, password } = req.body;

  try{
    
    if (!email || !password) return res.status(400).json({ msg: "Error faltan campos por recibir"});

    // Se pone exec para convertirlo en promesa aunque si no lo pones Mongoose lo hace en su implementacion
    const user = await userModel.findOne({email: email}).exec();

    // I prefer sending this msg instead of "Invalid email" to avoid giving clues to a fraudulent access attempt
    if (!user) return res.status(404).json({msg: "Email y/o contraseña incorrecta"});

    // Comparing passwords with callbacks
    // user.comparePassword(password, (error, isMatch) => {

    //   // If passwords do not match, show error
    //   if(!isMatch || error)
    //     return res.status(401).json({msg: "Email y/o contraseña incorrecta"});
    //   else
    //     return res.json({msg: "Usuario logueado correctamente", name: user.name});

    // });

    // Comparing passwords using bcryptjs method directly
    const isMatch = await bcryptjs.compare(password, user.password);

    if(isMatch)
    {
      // Information that the token will contain
      const _id = user._id;
      const jwtConstructor = new SignJWT({_id});

      const token = await jwtConstructor
      .setProtectedHeader({alg: 'HS256', typ: 'JWT'})
      .setIssuedAt()
      .setExpirationTime('30s').sign(encoder.encode(process.env.JWT_PRIVATE));

      res.json({token, ...user._doc});
      // This return a JSON following the next patter
      // {
      //    'token': 'token_value',
      //    'name': Luis,
      //    'email': luis@gmail.com,
      //    ... with all the fields
      // }
    }
    else{
      return res.status(400).json({msg: "Email y/o contraseña incorrecta"});
    }

  } catch(err){
    return res.status(500).json({error: err.message});
  }

});

authUserRouter.post("/checkToken", async(req, res) => {

  try{

    const token = req.header('auth-token');
    if(token == null) return res.json(false);

    try{
      const jwtData = await jwtVerify(token, encoder.encode(process.env.JWT_PRIVATE));

      if(!jwtData) return res.json(false);
      // If token is valid, get user info
      const user = userModel.findById(jwtData.payload._id)
      // Check if user is valid
      if(!user) return res.json(false);

      // If all its valid, then return true
      return res.json(true);

    } catch(err){
      return res.json(false);
    }

  } catch(err){
    return res.status(500).json({error: err.message})
  }

});

// Get user data
// We use middle "auth" to get user id by confirming his token
authUserRouter.get('/', auth, async (req, res) =>{
  const user = await userModel.findById(req.user);
  res.json({...user._doc, token: req.token});
})

// Delete an account
// authUserRouter.delete("/:email", async (req, res) => {
//   const { email } = req.params;

//   if(!email) return res.sendStatus(400);

//   const user = await userModel.findOne({email: email}).exec();
//   if (!user) return res.status(404).send("El usuario no existe");

//   user.remove();

//   return res.status(200).send("El usuario ha sido eliminado correctamente");
// });

export default authUserRouter;