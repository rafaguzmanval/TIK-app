import {jwtVerify} from 'jose';

const auth = async (req, res, next) => {

    try{
        const token = req.header("auth-token");

        if(!token) return res.status(401).json({message: "Token inexistente, acceso no permitido"});

        const jwtData = await jwtVerify(token, encoder.encode(process.env.JWT_PRIVATE));
        if(!jwtData) return res.status(401).json({message: "Verificación de token fallida, acesso no permitido"});

        req.user = jwtData.id;
        req.token = token;
        next();
        
    } catch (err){
        return res.status(500).json({error: err.message});
    }

}

export default auth;