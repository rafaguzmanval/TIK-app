import { Router } from "express";
import { userModel } from "../models/user_schema.js"

const accountRouter = Router();


//Obtener los detalles de una cuenta a partir del guid
accountRouter.get("/:email", async (req, res) => {
  const { email } = req.params;

  const user = await userModel.findOne({email: email}).exec();
  if (!user) return res.status(404).send("El usuario no existe");

  return res.send(user);
});

//Obtener los detalles de una cuenta a partir del guid
accountRouter.get("/:email/:password", async (req, res) => {
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


//Crear una nueva cuenta a partir de guid y name
accountRouter.post("/", async (req, res) => {
  const { name, email, password } = req.body;

  try{
    
    if (!email || !name) return res.status(400).send("Error");

    // Se pone exec para convertirlo en promesa aunque si no lo pones
    // Mongoose lo hace en su implementacion
    const user = await userModel.findOne({email: email}).exec();

    if (user) return res.status(409).send("El usuario ya se encuentra registrado");

    // Rellenamos los campos requeridos en el esquema
    const newUser = new userModel({name, email, password});

    // Es una promesa
    await newUser.save();

    return res.send("Usuario registrado correctamente");

  } catch(err){
    return res.status(500).json({error: err.message});
  }

});

//Actualizar el nombre de una cuenta
// accountRouter.patch("/:guid", (req, res) => {
//   const { guid } = req.params;
//   const { name } = req.body;

//   if (!name) return res.state(400).send();

//   const user = USERS_BBDD.find((user) => user.guid === guid);

//   if (!user) res.status(404).send();

//   user.name = name;

//   return res.send();
// });

//Eliminar una cuenta
accountRouter.delete("/:email", async (req, res) => {
  const { email } = req.params;

  if(!email) return res.sendStatus(400);

  const user = await userModel.findOne({email: email}).exec();
  if (!user) return res.status(404).send("El usuario no existe");

  user.remove();

  return res.status(200).send("El usuario ha sido eliminado correctamente");
});

export default accountRouter;