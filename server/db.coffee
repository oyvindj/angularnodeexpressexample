_ = require("underscore")
mongodb = require('mongodb')

db = {}

getUser = (req) ->
    return req.user

db.connect = (callback) ->
    MongoClient = require('mongodb').MongoClient
    MongoClient.connect("mongodb://localhost/exampledb", (err, db) ->
        console.log 'err: ' + err
        console.log 'db: ' + db
        callback(db)
    )

db.insert = (db, collectionName, data, req, callback) ->
  if(req.user)
    userid = req.user._id
    data.user_id = userid
  data.timestamp = (new Date()).getTime()
  collection = db.collection(collectionName)
  collection.insert(data, (err, names) ->
    callback(data)
  )

db.delete = (db, collectionName, id, callback) ->
    console.log 'db delete ' + collectionName + ' ' + id
    collection = db.collection(collectionName)
    collection.remove({_id: new mongodb.ObjectID(id)}, (err, collection) ->
        callback(collection)
    )


db.getAll = (db, collectionName, callback) ->
    collection = db.collection(collectionName)
    collection.count((err, count) ->
        items = []
        collection.find().each((err, item) ->
            if(item != null)
                items.push item
            else
                callback(items)
                db.close()
        )
    )

db.findById = (db, collectionName, id, callback) ->
    collection = db.collection(collectionName)
    collection.findOne({_id: new mongodb.ObjectID(id)}, (err, item) ->
      console.log 'db findById returning ' + collectionName + ' with id ' + id + ': ' + item
      callback(item)
    )

db.findByField = (db, collectionName, fieldName, value, callback) ->
  console.log 'db findByField getting ' + collectionName + ' with ' + fieldName + ": " + value
  collection = db.collection(collectionName)
  query = {}
  query[fieldName] = value
  collection.findOne(query, (err, item) ->
    #console.log 'db findById returning ' + collectionName + ' with id ' + id + ': ' + item
    console.log 'db findByField got back: ' + item
    callback(item)
  )

module.exports = db
