/**
 * ImageController
 *
 * @description :: Server-side logic for managing Images
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */


module.exports = {
	findOne: function(req, res) {
		var imageName = req.param('id');

		var AWS = require('aws-sdk');
		AWS.config.update({
			accessKeyId: 'AKIAJASKL6L7ROB62IMQ',
			secretAccessKey: '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'
		});
		var s3 = new AWS.S3();
		var params = {
			Bucket: 'imagestorageq2e314',
			Key: imageName
		};

		s3.getObject(params).
		on('httpData', function(chunk) {
			res.write(chunk);
		}).
		on('httpDone', function() {
			res.end();
		}).send();
	}
};