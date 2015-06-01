var graph = require('fbgraph');

module.exports = function(req, res, next) {
    if((req.route.path.toUpperCase()!=='/facebook'.toUpperCase()) && (req.route.path.toUpperCase() !== '/facebookLogin'.toUpperCase())){
      next();
    }
    else{
      facebook_token = req.param('facebook_token');
      if(!facebook_token){
      	res.send('401',{error:"Missing facebook token"});
      }
      graph.setAccessToken(facebook_token);
      graph.get("me",function(err,graph_res){
        if(err){
          res.send('401',{error:"Facebook authentication error"});
          return;
        }
        else{
          req.facebook = 'true';
          next();      
        }
      });
    }  
};