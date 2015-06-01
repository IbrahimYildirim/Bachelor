/**
 * Authentication Controller
 *
 * This is merely meant as an example of how your Authentication controller
 * should look. It currently includes the minimum amount of functionality for
 * the basics of Passport.js to work.
 */

var AuthController = {

  login: function(req, res) {
    var email = req.param('email');
    var password = req.param('password');
    User.findOne({
      email: email
    }, function(err, user) {
      if (err || !user) {
        res.forbidden("Email address not found. Are you registered?");
        return;
      }
      Passport.findOne({
        user: user.id
      }, function(err, passport) {
        if (req.facebook) {
          user.access_token = passport.accessToken;
          return res.json(user);
        }
        passport.validatePassword(password, function(err, passwordIsCorrect) {
          if (passwordIsCorrect) {
            user.access_token = passport.accessToken;
            return res.json(user);
          } else {
            return res.forbidden("The password you entered was wrong.");
          }
        });
      });
    });
  },

  register: function(req, res) {
    passport.protocols.local.register(req, res, function(err, user, passport) {
      if (err || !user || !passport) {
        return res.negotiate(err);
      }
      user.access_token = passport.accessToken;
      return res.json(user);
    });
  }

};

module.exports = AuthController;
