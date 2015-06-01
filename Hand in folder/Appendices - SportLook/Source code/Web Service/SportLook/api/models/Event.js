/**
 * Event.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */

module.exports = {

  autoCreatedAt: true,
  autoUpdateAt: true,

  attributes: {

    name: {
      type: 'string'
    },
    image: {
      type: 'string'
    },
    startTime: {
      type: 'datetime'
    },
    endTime: {
      type: 'datetime'
    },
    address: {
      type: 'string'
    },
    lattitude: {
      type: 'float'
    },
    longtitude: {
      type: 'float'
    },
    description: {
      type: 'text'
    },
    category: {
      model: 'sport'
    },
    createdBy: {
      model: 'user'
    },
    attending: {
      collection: 'user',
      via: 'eventsAttending',
    },
    messages: {
      collection: 'message',
      via: 'event'
    }
  }

};
