/**
 * 500 (Server Error) Response
 *
 * Usage:
 * return res.serverError();
 * return res.serverError(err);
 * return res.serverError(err, 'some/specific/error/view');
 *
 * NOTE:
 * If something throws in a policy or controller, or an internal
 * error is encountered, Sails will call `res.serverError()`
 * automatically.
 */

module.exports = function serverError (data, options) {

 // Get access to `req`, `res`, & `sails`
  var res = this.res;
  
  var status = 500;
  res.status(status);
  res.json({
    status: status,
    error: data
  });
};

