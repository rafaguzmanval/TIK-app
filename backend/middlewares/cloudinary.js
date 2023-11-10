import { v2 as cloudinary } from 'cloudinary';

/**
 * Middleware that uploads an image to Cloudinary based on the data received in an HTTP request
 * and sets the URL of the uploaded image in the `req.cloudinaryUrl` property of the `req` object.
 * 
 * @param {object} req - The Express request object.
 * @param {object} res - The Express response object.
 * @param {function} next - The Express next middleware function.
 * @returns {void}
 */  

async function createCoudinaryImage(req, res, next) {
    try {
        const {image, project_id} = req.body;
        // Check if img contains info
        if(image != ''){
            // Get _id from params if it is updating a datasheet or get from req.savedTreeDataSheetId
            // if it is new datasheet
            const _id = req.params.id || req.savedTreeDataSheetId;
            // Add the base64 image and the options, public_id is the desired cloudinary image name, in this case _id of the treeDataSheet.
            const result = await cloudinary.uploader.upload("data:image/png;base64,"  + image, {public_id: project_id + '/' + _id, overwrite: true, resource_type: 'image'});
            console.log(result);
            req.cloudinaryUrl = result.secure_url; // URL into  req.cloudinaryUrl
        }
        next();
        
    }catch (err) {
        console.log(err);
        res.status(500).send('Error al cargar la imagen en Cloudinary');
    }
}

async function createCloudinaryFolder(folderName){
     
  await cloudinary.api.create_folder(folderName, (error, result) => {
      if (error) {
        console.log(error);
      } else {
        console.log(result);
      }
    });
}

async function deleteCloudinaryFolder(folderName){

  // Delete all folder field in order to delete folder (must be empty)
  await cloudinary.api.delete_resources_by_prefix(folderName + '/', (error, result) => {
    if (error) {
      console.log(error);
    } else {
      console.log(result);
    }
  });

  //Delete folder
  await cloudinary.api.delete_folder(folderName, (error, result) => {
    if (error) {
      console.log(error);
    } else {
      console.log(result);
    }
  });

}

async function deleteCloudinaryImage(imageName){
     
    await cloudinary.uploader.destroy(imageName, (error, result) => {
        if (error) {
          console.log(error);
        } else {
          console.log(result);
        }
      });
}

  
export { createCoudinaryImage, deleteCloudinaryFolder, deleteCloudinaryImage, createCloudinaryFolder};


