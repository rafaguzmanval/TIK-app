const {connect} = require('mongoose');


const mongoConnect = async () => {
    connect('mongodb://mongo/tik')
    .then(db => { 
        
            console.log("Db is connected to",db.connection.host)
    })
    .catch(err => console.error(err));
}

module.exports = mongoConnect;