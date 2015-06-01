/**
 * EventController
 *
 * @description :: Server-side logic for managing events
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {

  create: function (req, res) {
    var userId = req.user[0].id,
      user = req.user[0],
      name = req.param('name'),
      category = req.param('category'),
      startTime = req.param('startTime'),
      endTime = req.param('endTime'),
      address = req.param('address'),
      lattitude = req.param('lattitude'),
      longtitude = req.param('longtitude'),
      description = req.param('description');

    if(!name || !category || !startTime || !lattitude || !longtitude ){
      return res.negotiate(new Error("Can\'t create the event missing some event parameters."));
    }

    Event.create({
      name: name,
      category: category,
      startTime: startTime,
      endTime: endTime,
      address: address,
      lattitude: lattitude,
      longtitude: longtitude,
      description: description,
      createdBy: userId
    }).exec(function (err, event) {
      event.attending.add(userId);
      event.save(function (err) {
        if (err) return res.negotiate(err);
        else {
          res.json(event);
          addScore(user, 11);
        }
      });
    });
  },

  update: function (req, res) {
    var userId = req.user[0].id,
      id = req.param('id')
    if (!id) {
      res.badRequest("Event Id needed to update an event!");
    }

    updateObject = new Object();
    if (req.param('name')) updateObject.name = req.param('name');
    if (req.param('category')) updateObject.category = req.param('category');
    if (req.param('startTime')) updateObject.startTime = req.param('startTime');
    if (req.param('endTime')) updateObject.endTime = req.param('endTime');
    if (req.param('address')) updateObject.address = req.param('address');
    if (req.param('lattitude')) updateObject.lattitude = req.param('lattitude');
    if (req.param('longtitude')) updateObject.longtitude = req.param('longtitude');
    if (req.param('description')) updateObject.description = req.param('description');

    if (Object.keys(updateObject).length == 0) {
      res.badRequest("You didn't specify anything to change.")
    } else(
      Event.update({
        id: id,
        createdBy: userId
      }, updateObject, function (err, events) {
        if (err) {
          res.negotiate(err);
        } else {
          res.json(events[0]);
        }
      })
    )
  },

  uploadImage: function (req, res) {
    var userId = req.user[0].id;
    var eventId = req.param('eventId');
    if (!eventId) {
      return res.badRequest('Please provide an event id!.')
    }
    res.setTimeout(0);
    async.waterfall([
      function (callback) {
        Event.findOne(eventId).exec(function (err, event) {
          if (err) {
            return callback(err);
          }
          if (!event) {
            return callback('This event doesn\'t exist');
          }
          if (!event.createdBy || (event.createdBy != userId)) {
            return callback('You can\'t change this event\'s image');
          }
          return callback(null, event);
        })
      },
      function (event, callback) {
        req.file('image')
          .upload({
            adapter: require('skipper-s3'),
            key: process.env.AWS_KEY,
            secret: process.env.AWS_SECRET,
            bucket: "imagestorageq2e314",
            maxBytes: 5 * 1024 * 1024
          }, function whenDone(err, uploadedFiles) {
            console.log('done with uploading');
            if (err) return callback(err);
            return callback(null, event, '/image/' + uploadedFiles[0].fd);
          });
      },
      function (event, filename, callback) {
        Event.update({
          id: event.id
        }, {
          image: filename
        }).exec(function (err, events) {
          if (err) return callback(err);
          if (!events) return callback('no event found');
          return callback(null, events[0]);
        });
      }
    ], function (err, event) {
      if (err) {
        console.log(err);
        sails.log.error(err);
        return res.serverError(err);
      }
      return res.json(event);
    });
  },

  myEvents: function (req, res) {
    //only accept GET requests
    if (req.method.toUpperCase() != 'GET') {
      return res.forbidden();
    }
    var userId = req.user[0].id;
    User.findOne({
      id: userId
    })
      .populate('eventsAttending')
      .exec(function (err, user) {
        if (err) {
          res.negotiate(err)
        } else if (!user) {
          res.notFound('User not found!');
        } else {

          async.map(user.eventsAttending,
            function (event, callback) {
              Event.findOne(event.id)
                .populate('category')
                .populate('attending')
                .populate('createdBy')
                .exec(function (err, event) {
                  if (err) return callback(err);
                  if (event.endTime < new Date()) {
                    return callback(null, null);
                  } else {
                    if (event.createdBy) {
                      event.createdByMe = (event.createdBy.id == userId);
                    }
                    else {
                      //if event.createdBy is null it was likely caused by deleting an user and improper cascade
                      event.createdByMe = false;
                    }                    //theoretically it's possible you created the event and then left. but the app doesn't let you do that, so fuck that shit
                    event.joinedByMe = true;
                    return callback(null, event);
                  }
                })
            },
            function (errFromResults, events) {
              if (errFromResults) return res.serverError(errFromResults);
              else {
                //get rid of nulls
                async.filter(events, function (event, callback) {
                    if (!event) return callback(false);
                    else return callback(true);
                  },
                  function (events) {
                    return res.json(events);
                  })
              }
            });
        }
      });
  },

  find: function (req, res) {
    var id = req.param('id'),
      userId = req.user[0].id,
      findObj = new Object(),
      requestForSingleEvent = false;
    if (id) {
      findObj.id = id;
      requestForSingleEvent = true;
    }
    findObj.endTime = {
      '>': new Date()
    }
    Event.find()
      .where(findObj)
      .populate('category')
      .populate('attending')
      .populate('createdBy')
      .exec(function (err, events) {
        if (err) return res.negotiate(err);
        if (!events || events.length == 0) return res.notFound('No events found');
        events = events.map(function (event) {
          if (event.createdBy) {
            event.createdByMe = (event.createdBy.id == userId);
          }
          else {
            //if event.createdBy is null it was likely caused by deleting an user and improper cascade
            event.createdByMe = false;
          }
          async.some(event.attending,
            function iterator(attendingUser, callback) {
              callback(attendingUser.id === userId)
            },
            function callback(thisUserIsAttendingThisEvent) {
              event.joinedByMe = thisUserIsAttendingThisEvent;
            }
          );

          return event;
        });
        if (requestForSingleEvent) {
          return res.json(events[0]);
        }
        else {
          return res.json(events);
        }
      });
  },

  join: function (req, res) {
    userId = req.user[0].id;
    eventId = req.param('id');
    if (!eventId) {
      return res.badRequest("Please specify the event you want to join.");
    }
    Event.findOne(eventId).exec(function (err, event) {
      if (err) {
        return res.negotiate(err);
      }
      if (!event) {
        return res.negotiate("Event doesn\'t seem to exist. Have you tried looking under the couch?");
      }
      event.attending.add(userId);
      event.save(function (err) {
        if (err) return res.badRequest('You can\'t join this event. Maybe you already joined?');
        res.json({
          message: 'Congratulations! You\'ve joined.'
        });
        addScore(req.user[0], 3);
      });

    });
  },

  leave: function (req, res) {
    userId = req.user[0].id;
    eventId = req.param('id');
    if (!eventId) {
      return res.badRequest("Please specify the event you want to leave.");
    }
    Event.findOne(eventId).exec(function (err, event) {
      if (err) {
        return res.negotiate(err);
      }
      if (!event) {
        return res.negotiate("Event doesn\'t seem to exist. Have you tried looking under the couch?");
      }
      event.attending.remove(userId);
      event.save(function (err) {
        if (err) return res.negotiate(err);
        res.json({
          message: 'You\'ve left the event. Sad to see you go :('
        });
        addScore(req.user[0], -3);
      });

    });
  },

  destroy: function (req, res) {
    userId = req.user[0].id;
    eventId = req.param('id');
    if (!eventId) {
      return res.badRequest("Please specify the event you want to delete.");
    }
    async.series([
      function (callback) {
        Event.findOne(eventId).exec(function (err, event) {
          if (err) {
            res.serverError(err);
            callback(new Error('not able to delete it'));
          } else if (!event) {
            res.badRequest("Please specify the correct event.");
            callback(new Error('not able to delete it'));
          } else if (!event.createdBy || event.createdBy != userId) {
            res.badRequest("You don't have the permissions to delete this request");
            callback(new Error('not able to delete it'));
          } else {
            callback(null);
          }

        });
      },
      function (callback) {
        Event.destroy(eventId).exec(function (err, event) {
          if (err) {
            return res.negotiate(err);
          }
          else {
            res.json({
              message: "The event was succesfully deleted."
            });
            addScore(req.user[0], -12);
          }
        });
      }
    ]);

  },

  invite: function (req, res) {
    var Parse = require('node-parse-api').Parse;

    var options = {
      app_id: process.env.PARSE_APP,
      api_key: process.env.PARSE_KEY
    }
    var app = new Parse(options);

    var userId = req.user[0].id,
      userIdToInvite = req.param('userId'),
      eventId = req.param('eventId');

    if (!userIdToInvite) {
      return res.badRequest('Please specify a user to invite.');
    }
    if (userIdToInvite === userId) {
      return res.badRequest('You can\'t invite yourself dummy!');
    }
    if (!eventId) {
      return res.badRequest('Please specify the event you want to invite to!');
    }

    Event.findOne(eventId).populate('attending').exec(function (err, event) {
      if (err) return res.serverError(err);
      if (!event) return res.badRequest('This event doesn\'t exist.');
      if (!_.isNumber(userIdToInvite)) {
        userIdToInvite = parseInt(userIdToInvite);
      }
      if (event.attending && _.some(event.attending, {'id': userIdToInvite})) {
        return res.badRequest('This user is already attending the event');
      }

      var notification = {
        channels: [
          "user_" + userIdToInvite
        ],
        data: {
          alert: req.user[0].name + " has invited you to an event!",
          badge: 'Increment',
          title: 'Event invitation',
          eventId: eventId,
          isForInvite: true,
          isForChat: false
        }
      };


      app.sendPush(notification, function (err, resp) {
        if (err) return res.negotiate(err);
        else return res.json({message: 'user successfully invited!'});
      });

    });
  }
};

function addScore(user, scoreToAdd) {
  User.update(user.id, {score: user.score + scoreToAdd}).exec(function (err, users) {
  });
}
