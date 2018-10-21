const jwt = require('jsonwebtoken')

module.exports = (req,res,next)=>{
    try{
        const token = req.headers.authorization;
        const decoded = jwt.verify(token,"JWTPASSWORD@262qsddsqds");
        req.userData = decoded;
        console.log(req.userData);
        next();
    }catch(error){
        return res.status(401).json({
            message: "Auth failed"
        })
    } 
}