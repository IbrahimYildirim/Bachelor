/**
 * 400 (Bad Request) Handler
 *
 * Usage:
 * return res.badRequest();
 * return res.badRequest(data);
 * return res.badRequest(data, 'some/specific/badRequest/view');
 *
 * e.g.:
 * ```
 * return res.badRequest(
 *   'Please choose a valid `password` (6-12 characters)',
 *   'trial/signup'
 * );
 * ```
 */

module.exports = function badRequest(data, options) {

  // Get access to `req`, `res`, & `sails`
  var res = this.res;
  
  var status = 400;
  res.status(status);
  res.json({
    status: status,
    error: data
  });
};

