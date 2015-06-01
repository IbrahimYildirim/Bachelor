/**
 * MessageController
 *
 * @description :: Server-side logic for managing messages
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	
	create: function(req,res){
		var userId = req.user[0].id;
		var eventId = req.param('eventId');
		var message = req.param('message');
		if(!eventId){
			return res.badRequest('Please provide an event id.');
		}
		if(!message){
			return res.badRequest('I\'m sorry but I can\'t accept an empty message')
		}
		Message.create({user:userId, event:eventId, message:message})
		.exec(function(err,message){
			if(err){
				return res.negotiate(err);
			}
			else{
				return res.json({message:"Your message was successfully sent!"});
			}
		})
	},

	find: function(req, res){
		var eventId = req.param('eventId');
		if(!eventId){
			return res.badRequest('Please provide an event id.');
		}

		Message.find({event:eventId}).populate('user').exec(function(err, messages){
			if(err) return res.negotiate(err);
			return res.json(messages);
		})
	}
};

