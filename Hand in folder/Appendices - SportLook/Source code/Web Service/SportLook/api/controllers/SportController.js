/**
 * SportController
 *
 * @description :: Server-side logic for managing sports
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	addSportsForLoggedUser: function(req, res) {
		var user = req.user[0];
		var sports = req.param('sports');

		User.findOne(user.id)
			.populate('favoriteSports')
			.exec(function(err, user) {
				//map object array to id array
				var newSports = [];
        var oldSports = [];

        if(sports && sports.length>0) {
          async.map(sports, function (sport, callback) {
            if (typeof sport === 'string') {
              return callback(null, parseInt(sport));
            }
            else if (typeof sport === 'number') {
              return callback(null, sport);
            }
            else {
              callback(new Error('What the fuck did you send me? It\'s neither string nor int. you fuckwit! here goes: ' + sport));
            }
          }, function (err, sports) {
            if (err) throw err;
            else newSports = sports;
          });
        }

        if(user.favoriteSports && user.favoriteSports.length>0) {
          async.map(user.favoriteSports, function (sport, callback) {
            callback(null, sport.id);
          }, function (err, sports) {
            if (err) throw err;
            oldSports = sports;
          });
        }


				var sportsToRemove = _.difference(oldSports, newSports);
				//sports in old not in new
				var sportsToAdd = _.difference(newSports,oldSports); //

				sportsToRemove.forEach(function(sportId){
					user.favoriteSports.remove(sportId);
				})


				sportsToAdd.forEach(function(sportId){
					user.favoriteSports.add(sportId);
				})

				user.save(function(err, user) {
					if (err) {
						res.send('400', err)
					} else {
						res.json({
							message: "Sport preferences successfully set!"
						});
					}
				});
			});
	},

	find: function(req, res) {
		Sport.find({
			sort: 'name'
		}).exec(function(err, sports) {
			if (err) res.send('400', err);
			else res.json({
				sports: sports
			});
		});
	}


};
