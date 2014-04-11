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

db.insertName = (db, collectionName, req, callback) ->
    name = req.body.name
    userid = req.user.id
    collection = db.collection(collectionName)
    collection.insert({name: name, userid: userid}, (err, names) ->
        callback(name)
    )

db.insert = (db, collectionName, data, req, callback) ->
  userid = req.user.id
  data.userid = userid
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
    item = collection.findOne({_id: id})
    callback(item)

module.exports = db 
