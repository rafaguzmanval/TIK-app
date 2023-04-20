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

async function cloudinaryMiddleware(req, res, next) {
    try {
        const {image, project_id} = req.body;
        // Check if img contains info
        if(image != ''){
            const _id = req.params.id;
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
  
  export default cloudinaryMiddleware;

