var UserController = {
  getProfile: function (req, res) {
    var userId = req.param('userId') || req.user[0].id;
    User.findOne(userId)
      .populate('favoriteSports')
      .populate('eventsAttending')
      .exec(function (err, user) {
        if (err) return res.send('400', err);
        if (!user) return res.badRequest('No such user!');
        else {
          async.map(user.eventsAttending,
            function (event, callback) {
              Event.findOne(event.id)
                .populate('category')
                .exec(function (err, event) {
                  if (err) return callback(err);
                  if (event.endTime < new Date()) {
                    return callback(null, null);
                  } else {
                    event.createdByMe = (event.createdBy == userId)
                    return callback(null, event);
                  }
                });
            },
            function (err, eventsAttending) {
              if (err) return res.serverError(err);
              else {
                user.eventsAttending = eventsAttending;
                return res.json(user);
              }

            });
        }
      });
  },

  updateProfile: function (req, res) {
    var userId = req.user[0].id,
      password = req.param('password'),
      updateObject = new Object();

    if (req.param('name')) {
      updateObject.name = req.param('name');
    }
    if (req.param('address')) {
      updateObject.address = req.param('address');
    }
    if (req.param('email')) {
      updateObject.email = req.param('email');
    }
    if (req.param('lattitude')) {
      updateObject.lattitude = req.param('lattitude');
    }

    if (req.param('longtitude')) {
      updateObject.longtitude = req.param('longtitude');
    }

    if (Object.keys(updateObject).length == 0 && !password) {
      res.serverError('You didn\'t specify anything to change.');
    }

    var updateUser = function () {
      //update if updateObject not empty
      if (Object.keys(updateObject).length > 0) {
        User.update({
          id: userId
        }, updateObject)
          .exec(function (err, user) {
            if (err) res.serverError(err);
            else res.json(user);
          });
      }
    }

    if (password) {
      Passport.update({
        user: userId
      }, {
        password: password
      })
        .exec(function (err, passport) {
          if (err) res.serverError(err);
          else updateUser();
        });
    } else {
      updateUser();
    }
  },

  /*TODO: add file type checking, trading security for dev time now*/
  uploadProfileImage: function (req, res) {
    var userId = req.user[0].id,
      imagesFolderName = 'images',
      fs = require('fs'),
      path = require('path'),
      uuid = require('node-uuid'),
      AWS = require('aws-sdk')

    res.setTimeout(0);
    AWS.config.update({
      accessKeyId: process.env.AWS_KEY,
      secretAccessKey: process.env.AWS_SECRET
    });

    async.waterfall([
        function (callback) {
          req.file('avatar')
            .upload({
              maxBytes: 5 * 1024 * 1024 //5MB
            }, function whenDone(err, uploadedFiles) {
              if (err) return res.serverError(err);
              else {
                if (uploadedFiles.length == 0 || !uploadedFiles[0]) {
                  callback('Looks like you forgot to include an image..');
                }
                var filePath = uploadedFiles[0].fd;
                var fileStream = fs.createReadStream(filePath);
                var newFileName = uuid.v4() + path.extname(filePath);
                var s3 = new AWS.S3({
                  params: {
                    Bucket: 'imagestorageq2e314',
                    Key: newFileName
                  }
                });

                s3.upload({
                  Body: fileStream
                }).
                  send(function (err, data) {
                    if (err) callback(err);
                    if (!data) callback('There was an error sending your file!');
                    callback(null, filePath, '/image/' + newFileName);
                  })
              }
            })
        },
        function (filePath, imageNameToSave, callback) {
          var newFileName = uuid.v4() + path.extname(filePath);
          var s3 = new AWS.S3({
            params: {
              Bucket: 'imagestorageq2e314',
              Key: newFileName
            }
          });

          //let's make a mini version

          require('lwip').open(filePath, function (err, image) {

            // check err...
            // define a batch of manipulations and save to disk as JPEG:
            image.batch()
              .resize(150, 150)
              .writeFile(newFileName, function (err) {
                if (err) callback(err);
                s3.upload({
                  Body: fs.createReadStream(newFileName)
                }).
                  send(function (err, data) {
                    if (err) callback(err);
                    if (!data) callback('There was an error sending your file!');
                    callback(null, imageNameToSave, '/image/' + newFileName);
                  })
              });

          });


        },
        function (imageName, imageNameMini, callback) {
          User.update({
            id: userId
          }, {
            image: imageName,
            image_small: imageNameMini
          })
            .exec(function (err, results) {
              if (err) {
                callback(err);
              } else if (!results) {
                callback('Something went wrong with uploading the picture');
              } else {
                callback(null, results[0]);
              }
            });
        }
      ],
      function (err, user) {
        if (err) return res.serverError(err);
        if (!user) return res.serverError('Something went wrong with uploading the picture');
        return res.json(user);
      });

  },
  findUsersWithinRadius: function (req, res) {
    var radiusKm = req.param('distance') || 10,
      myLat, myLon,
      userId = req.user[0].id;
    User.findOne(userId).exec(function (err, user) {
      if (!user || !user.lattitude || !user.longtitude) {
        return res.badRequest('I don\'t know your location!');
      }
      myLat = user.lattitude;
      myLon = user.longtitude;
      var distance = '111.045*degrees(acos(cos(radians(' + myLat + '))' +
        '* cos(radians(cast(lattitude as float	)))' +
        '* cos(radians(' + myLon + ') - radians(cast(longtitude as float)))' +
        '+ sin(radians(' + myLat + '))' +
        '* sin(radians(cast(lattitude as float)))))';
      var distancequery = 'select *, ' + distance + ' as distance  from \"user\"' +
        'where lattitude IS NOT NULL and longtitude IS NOT NULL ' +
        'and id!=' + userId + '  and ' + distance + ' <=' + radiusKm + ' order by distance;';
      User.query(distancequery, function (err, users) {
        if (err) return res.negotiate(err);
        if (!users || users.length == 0) {
          res.notFound('No users found :(');
        }
        return res.json(users.rows);
      });

    });
  }
}

module.exports = UserController;


