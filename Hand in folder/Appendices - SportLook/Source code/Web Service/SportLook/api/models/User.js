var User = {
  // Enforce model schema in the case of schemaless databases
  schema: true,

  attributes: {
    name: {
      type: 'string',
      required: true
    },
    address: {
      type: 'string',
      required: true
    },
    lattitude: {
      type: 'float'
    },
    longtitude: {
      type: 'float'
    },
    email: {
      type: 'email',
      unique: true,
      required: true
    },
    image: {
      type: 'string',
      defaultsTo: "/image/1e6ef38c-dbb4-4c20-abd6-61f724b5c4d6.jpg"
    },
    image_small: {
      type: 'string',
      defaultsTo: "/image/e6d2b311-f80e-444e-9389-4350e4cf94d2.jpg"
    },
    eventsCreated: {
      collection: 'Event',
      via: 'createdBy'
    },
    score:{
      type: 'integer',
      defaultsTo: 0
    },
    eventsAttending: {
      collection: 'Event',
      via: 'attending',
      dominant: true
    },
    passports: {
      collection: 'Passport',
      via: 'user'
    },
    favoriteSports: {
      collection: 'Sport',
      via: 'users',
      dominant: true
    }
  }
};

module.exports = User;
