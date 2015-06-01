/**
 * Message.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */

module.exports = {

	attributes: {
		message: "string",
		user: {
			model: 'User',
			required: true
		},
		event: {
			model: 'Event',
			required: true
		}

	}
};