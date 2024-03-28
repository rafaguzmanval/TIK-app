const http = require('http')
const express = require('express')

const authRouter = require("./routes/authRouter.js")

const projectRouter = require("./routes/project.js")




const app = express()

app.use(express.json());


const bootstrap = async () => {


    http.createServer(app).listen(4000,()=>{
        console.log("Servidor en marcha")
    })
    
    app.get("/",(req,res) => {
    
        res.status(200).send("hola mundito")
    })

    app.use("/auth",authRouter)
    
    app.use("/projects",projectRouter)


    app.get("*",(req,res) => {
        res.status(404).send("Error 404: Not Found");
    })
    
}


bootstrap();









