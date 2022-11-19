// import {Router} from "express";
// import {SignJWT, jwtVerify} from "jose";
// import authByEmailPwd from "../auth-by-email-pwd.js";

// const authTokenRouter = Router();
// const encoder = new TextEncoder();

// authTokenRouter.post('/login', async(req, res) =>{
//     const { email, password } = req.body;

//     if(!email || !password) return res.sendStatus(401);

//     try{
//         const {guid} = authByEmailPwd(email, password);
//         // GENERAR TOKEN

//         const jwtConstructor = new SignJWT({guid});

//         const jwt = await jwtConstructor
//         .setProtectedHeader({alg: 'HS256', typ: 'JWT'})
//         .setIssuedAt()
//         .setExpirationTime('1h').sign(encoder.encode(process.env.JWT_PRIVATE));

//         // return res.send(`Usuario ${user.name} autenticado`);
//         return res.send(jwt);
//     } catch (err){
//         return res.sendStatus(401);
//     }
// });

// authTokenRouter.get("/profile", async (req, res) => {
//     // En la cabecera authorization es donde se mandan los token
//     const {authorization} = req.headers;

//     if(!authorization) return res.sendStatus(401);

//     try{
//        const jwtData = await jwtVerify(authorization, encoder.encode(process.env.JWT_PRIVATE));

//        const user = USERS_BBDD.find((user) => user.guid === jwtData.payload.guid);

//        if(!user) return res.sendStatus(401);

//        delete user.password;

//        return res.send(user);

//     } catch(err){
//         return res.sendStatus(401);
//     }
    
// });

// export default authTokenRouter;
