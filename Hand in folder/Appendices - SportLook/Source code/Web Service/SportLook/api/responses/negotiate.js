/**
 * Generic Error Handler / Classifier
 *
 * Calls the appropriate custom response for a given error,
 * out of the bundled response modules:
 * badRequest, forbidden, notFound, & serverError
 *
 * Defaults to `res.serverError`
 *
 * Usage:
 * ```javascript
 * if (err) return res.negotiate(err);
 * ```
 *
 * @param {*} error(s)
 *
 */

module.exports = function (err) {
  sails.log.error(err);
  // Get access to response object (`res`)
  var res = this.res;

  var statusCode = 500;
  var body;
  if (_.isObject(err)) {
    if (err['code'] === 'E_VALIDATION') {
      var invalidAttributesObject = err['invalidAttributes'];
      //TODO: don't just take the first one, map all of them?
      var invalidAttribute = Object.keys(invalidAttributesObject)[0];
      //TODO: don't just take the first one, map all of them?
      var errorObject = invalidAttributesObject[invalidAttribute][0];
      var message = errorObject['message'];
      var rule = errorObject['rule'];
      switch (rule) {
        case 'minLength':
          body = 'The ' + invalidAttribute + ' is too short!';
          break;
        case 'unique':
          body = 'The ' + invalidAttribute + ' already exists';
          break;
        case 'email':
          body = 'That\'s not a valid email';
        default:
          body = message;
      }

    }
    else if(err.message){
      body = err.message;
    }
  }
  if (!body) {
    body = err;
  }

  try {

    statusCode = err.status || 500;

    // Set the status
    // (should be taken care of by res.* methods, but this sets a default just in case)
    res.status(statusCode);

  } catch (e) {
  }

  // Respond using the appropriate custom response
  if (statusCode === 403) return res.forbidden(body);
  if (statusCode === 404) return res.notFound(body);
  if (statusCode >= 400 && statusCode < 500) return res.badRequest(body);
  return res.serverError(body);
};
