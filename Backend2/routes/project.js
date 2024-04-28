const { Router } = require("express");

const { PrismaClient } = require("@prisma/client");

let prisma = new PrismaClient()

const projectRouter = Router();

projectRouter.post("/new", 
    async (req, res, next) => {
        const { user_id, name } = req.body;

        try{
            
            if (!name || !user_id) return res.status(400).json({ msg: "Error faltan campos por recibir"});

            console.log(req.body)

            const project = await prisma.project.findFirst({
                where: {
                    AND: [
                        {
                            authorId: user_id
                        }
                        ,
                        {name:name}
                    ]

                },
              })

            if (project) return res.status(409).json({ msg: "El proyecto con ese mismo nombre asociado a este usuario ya se encuentra registrado"});




            const Project = await prisma.Project.create({
                data: {
                    name: name,
                    description : "",
                    authorId : parseInt(user_id)
                },
                include: {client: true}
            })


            //next();
            
            return res.json({ msg: "Proyecto creado correctamente"});

        } catch(error){
            return res.status(500).json({msg: error.message});
        }
    },
    // Create project folder on cloudinary to save images
    async (req, res, next) => {
        createCloudinaryFolder(req.savedProjectId);
        // Back to retrun response
        next();
    },
);

projectRouter.get("/getall/:user_id",
    async (req, res) => {

        const resultados = await prisma.project.findMany({

                    where:{
                        authorId: parseInt(req.params.user_id)
                    }


                }
            )
        if(!resultados) return res.status(404).send("No se han podido recuperar los proyectos");

        return res.send(resultados);
    }
);


projectRouter.delete("/delete/:id",
    async (req, res) => {

        const { id } = req.params;
        try {
            
            // Se borran todos los arboles y elementos relacionados con el proyecto
            await prisma.Tree.deleteMany({
                where:{
                    project_id: parseInt(id)
                }

                }
            )

            // Finalmente se borra el proyecto
            const project = await prisma.project.delete({
                where:{
                    id: parseInt(id)
                }

                }
            )
            if (!project) {
                return res.status(404).json({ error: 'Proyecto no encontrado' });
            }

            res.json({ msg: 'Proyectos eliminado correctamente' });

        } catch (error) {
            console.error(error);
            return res.status(500).json({msg: error.message});
        }
    }
)


/*

projectRouter.get("/getall",
    async (req, res) => {

        const resultados = await prisma.project.findMany({


                }
            )
        if(!resultados) return res.status(404).send("No se han podido recuperar los proyectos");

        return res.send(resultados);
    }
);



projectRouter.get("/getUserProject/:user_id",
    async (req, res) => {

        const { user_id } = req.params;
        const project_name = req.query.project_name;

        console.log(user_id, project_name);
        
        const results = await projectSchemaModel.find({user_id: user_id, name: project_name});
        console.log(results)
        if(!results) return res.status(404).send("No se ha podido recuperar el proyecto");

        return res.send(results);
    }
);



projectRouter.get("/:id",
    async (req, res) => {
        const { id } = req.params;
        const project = await projectSchemaModel.findById(id).exec();
        if(!project) return res.status(404).send("El proyecto no existe");

        return res.send(project);
    }
);



projectRouter.put("/edit",
    async (req, res) => {

        const { _id, name, description, user_id } = req.body;
        try {
            let project = await projectSchemaModel.findById(_id);

            if (project != null) {
                project.name = name;
                project.description = description;
                
                await project.save();
            }
            res.json({ msg: 'Proyecto actualizado correctamente' });

        } catch (error) {
            console.error(error);
            return res.status(500).json({msg: error.message});
        }
    }
)

projectRouter.get("/export/:project_id",
    async (req, res) => {
        const { project_id } = req.params;

        const treeDataSheets = await treeDataSheetSchemaModel.find({project_id})
        .populate('project_id')
        .populate('tree_specie_id')
        .populate({
            path: 'project_id',
            populate: {
              path: 'user_id',
              model: 'Users'
            }
          })
        .lean();

        // Create excel with tree data sheets
        if(treeDataSheets.length != 0)
        {
            createExcel(treeDataSheets, res);
        }else{
            return res.status(500).json({msg: 'No existen datos que exportar'});
        } 
    }
)

async function createExcel(treeDataSheets, res)
{
    // Create a woorkbook variable
    const workbook = new Exceljs.Workbook();

    // Create a first worksheet that contains project information
    createNewProjectWorkSheet(workbook, "Proyecto - "+treeDataSheets[0].project_id.name, treeDataSheets);
    // Create data sheets work sheets
    treeDataSheets.forEach((treeDataSheet) => {
       
        createNewTreeDataSheetWorkSheet(workbook, treeDataSheet);
    });
    console.log(treeDataSheets)

    const buffer = await workbook.xlsx.writeBuffer();
    if(buffer)
    {
        try {
            const filename = treeDataSheets[0].project_id.name+ '.xlsx';
            res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            res.setHeader('Content-Disposition', `attachment; filename=${filename}`);
            res.setHeader('filename', `${filename}`);
            res.setHeader('Content-Transfer-Encoding', 'binary');
            res.status(200).send(buffer);
        } catch (err) {
            console.log(err);
            res.status(500).json({msg: err});
        };
    }
}

function createNewProjectWorkSheet(workbook, workSheetTitle, treeDataSheets){

    const worksheet = workbook.addWorksheet(workSheetTitle);

    // Create project columns
    worksheet.columns = [
        { header: 'Fecha generación informe: ', key: 'reportGeneratedDate',},
        { header: 'Info. Usuario', key: 'userInfo',},
        { header: 'Nombre del proyecto', key: 'projectName',},
        { header: 'Descripcion de proyecto', key: 'projectDescription'},
    ];

    // Adjust column width
    setColumnsWidth(worksheet);
    
    // Generate data
    const data = [{
        reportGeneratedDate: new Date().toLocaleString(),
        userInfo: treeDataSheets[0].project_id.user_id.name + ' - ' + treeDataSheets[0].project_id.user_id.email,
        projectName: treeDataSheets[0].project_id.name,
        projectDescription:treeDataSheets[0].project_id.description,
    }];

    worksheet.addRows(data);

    // Set background and borders to columns headers
    setColumnsStyle(worksheet);
}

async function createNewTreeDataSheetWorkSheet(workbook, treeDataSheet){

    const worksheet = workbook.addWorksheet(treeDataSheet.specific_tree_id);

    // Create project columns
    worksheet.columns = [
        { header: 'Id. Árbol', key: 'treeId',},
        { header: 'Nombre de especie', key: 'specieName'},
        { header: 'Notas árbol', key: 'treeDescription'},
    ];

    // Adjust column width
    setColumnsWidth(worksheet);
    
    // Generate data
    const data = [{
        treeId: treeDataSheet.specific_tree_id,
        treeDescription: treeDataSheet.description,
        specieName: treeDataSheet.tree_specie_id.name
    }];

    worksheet.addRows(data);

    // Set background and borders to columns headers
    setColumnsStyle(worksheet);
    
    // Select the masurement row
    const measurementRow = worksheet.getRow(6)
    measurementRow.getCell(2).value = 'Mediciones';
    // Create measurement table
    worksheet.addTable({
        name: 'Mediciones ' + treeDataSheet.specific_tree_id,
        ref: 'A7',
        headerRow: true,
        style: {
          theme: 'TableStyleMedium4',
          showRowStripes: true,
        },
        columns: [
                { name: 'Distancia (cm)'},
                { name: 'Tiempo (µs)'},
                { name: 'Vel. media (m/s)'},
        ],
        rows: treeDataSheet.measurements.map(measurement => Object.values(measurement)),
    });

    // Select the masurement row
    const coordinatesRow = worksheet.getRow(6)
    coordinatesRow.getCell(5).value = 'Coordenadas';
    // Create coordiantes table
    worksheet.addTable({
        name: 'Coordenadas ' + treeDataSheet.specific_tree_id,
        ref: 'E7',
        headerRow: true,
        style: {
          theme: 'TableStyleMedium4',
          showRowStripes: true,
        },
        columns: [
                { name: 'Latitud'},
                { name: 'Longitud'},
        ],
        rows: [[treeDataSheet.latitude, treeDataSheet.longitude]],
    });

    // Add image if is not empty
    if(treeDataSheet.imageURL)
    {
        const response = await fetch(treeDataSheet.imageURL);
        const blob = await response.blob();
        const arrayBuffer = await blob.arrayBuffer();
        const buffer = Buffer.from(arrayBuffer);
        const base64 = buffer.toString('base64');

        // ExcelJS addImage function does not work
        // if(base64)
        // {
        //     // Add image to workbook by base64
        //     // const imageId = workbook.addImage({
        //     //     base64: 'data:image/jpg;base64,'+base64,
        //     //     extension: 'jpg',
        //     // });

        //     worksheet.addImage(imageId, {
        //         tl: { col: 10, row: 10 },
        //         ext: { width: 500, height: 200 },
        //         hyperlinks: {
        //             hyperlink: treeDataSheet.imageURL,
        //             tooltip: treeDataSheet.imageURL
        //         }
        //     });
    }
}

function setColumnsWidth(worksheet){
    worksheet.columns.forEach((column) =>{
        let maxLength = 0;
        column.eachCell(cell => {
            const length = cell.value ? cell.value.toString().length : 0;
            if (length > maxLength) {
                maxLength = length;
            }
        });
        column.width = maxLength + 5;
    });

}

function setColumnsStyle(worksheet){

    worksheet.columns.forEach((column, index) => {
        const headerCell = worksheet.getCell(1, index+1);
        headerCell.fill = {
          type: 'pattern',
          pattern: 'solid',
          fgColor: { argb: 'FFC0C0C0' } 
        };

        headerCell.font = {
            bold: true
        }

        headerCell.border = {
            top: { style: 'thin' },
            left: { style: 'thin' },
            bottom: { style: 'thin' },
            right: { style: 'thin' }
        };
    });

}

*/

module.exports = projectRouter;