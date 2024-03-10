const { Router } = require("express");

const { PrismaClient } = require("@prisma/client");
//import bcryptjs from 'bcryptjs';
//import {SignJWT, jwtVerify} from "jose";

let prisma = new PrismaClient()

const authUserRouter = Router();
const encoder = new TextEncoder();




//Obtain user details from email
authUserRouter.get("/:email", async (req, res) => {
  const { email } = req.params;

  await prisma.client.create({
    data: {
      name : "pepe"+email,
      mail : email,
      password : "pass"
    }


  })


  const user = await prisma.client.findFirst({
    where: {
      mail: email
    }
  })

  //const user = await userModel.findOne({email: email}).exec();

  if (!user) return res.status(404).send("El usuario no existe");

  return res.send(user);
});


//Obtain user details from email and password
authUserRouter.get("/:email/:password", async (req, res) => {
  const { email, password } = req.params;

  //const user = await userModel.findOne({email: email}).exec();

  if (!user) return res.status(404).send("El usuario no existe");

  user.comparePassword(password, (error, isMatch) => {

    // If passwords do not match, show error
    if(!isMatch || error)
      return res.status(401).send("Contraseña incorrecta");
    else
      return res.status(200).send("Usuario logueado correctamente");

  });

});

// Register new account route
authUserRouter.post("/register", async (req, res) => {
  const { name, email, password, confirmpassword } = req.body;

  try{
    
    if (!email || !password || !name) return res.status(400).json({ msg: "Error faltan campos por recibir"});
    if (password != confirmpassword) return res.status(400).json({ msg: "Las contraseñas no coinciden"});

    console.log(password);
    console.log(confirmpassword);

    //const user = await userModel.findOne({email: email}).exec();

    if (user) return res.status(409).json({ msg: "El usuario ya se encuentra registrado"});

    //const newUser = new userModel({name, email, password});

    //await newUser.save();

    return res.json({ msg: "Usuario registrado correctamente"});

  } catch(err){
    return res.status(500).json({error: err.message});
  }

});

// Login route
authUserRouter.post("/login", async (req, res) => {
  const { email, password } = req.body;

  try{

    if (!email || !password) return res.status(400).json({ msg: "Error faltan campos por recibir"});

    // Se pone exec para convertirlo en promesa aunque si no lo pones Mongoose lo hace en su implementacion
    //const user = await userModel.findOne({email: email}).exec();

    // I prefer sending this msg instead of "Invalid email" to avoid giving clues to a fraudulent access attempt
    if (!user) return res.status(404).json({msg: "Email y/o contraseña incorrecta"});

    let token = '';
    res.json({token, ...user._doc});

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
      //const user = userModel.findById(jwtData.payload._id)
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
// authUserRouter.get('/', auth, async (req, res) =>{
//   const user = await userModel.findById(req.user);
//   res.json({...user._doc, token: req.token});
// })

// Delete an account
// authUserRouter.delete("/:email", async (req, res) => {
//   const { email } = req.params;

//   if(!email) return res.sendStatus(400);

//   const user = await userModel.findOne({email: email}).exec();
//   if (!user) return res.status(404).send("El usuario no existe");

//   user.remove();

//   return res.status(200).send("El usuario ha sido eliminado correctamente");
// });

// Edit user user info
authUserRouter.put('/editprofile', async (req, res) => {

  const { id, name, email, password, confirmpassword } = req.body;

  try{
    
      if (!id) return res.status(400).json({ msg: "Error falta por recibir el id del usuario"});
      if (password != '' && confirmpassword != '' && password != confirmpassword) return res.status(400).json({ msg: "Las contraseñas no coinciden"});
      //let user = await userModel.findById(id);
      if (user != null) {
          user.name = name;
          user.email = email;
          if(user.password != password && password != '')
          {
            user.password = password;
          }
          await user.save();
      }
      res.json({user: user, msg: 'Perfil de usuario actualizado correctamente' });

    } catch (error) {
      console.error(error);
      return res.status(500).json({msg: error.message});
    }

});

module.exports = authUserRouter