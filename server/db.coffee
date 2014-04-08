_ = require("underscore")
mongodb = require('mongodb')

db = {}

db.hello = ->
    console.log 'hello from db...'
    

db.connect = (callback) ->
    MongoClient = require('mongodb').MongoClient

    MongoClient.connect("mongodb://localhost/exampledb", (err, db) ->
        console.log 'err: ' + err
        console.log 'db: ' + db
        callback(db)
    )

db.insert = (db, collectionName, name, callback) ->
    collection = db.collection(collectionName)
    collection.insert({name: name}, (err, names) ->
        callback(name)
    )
    
db.delete = (db, collectionName, id, callback) ->
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
    
module.exports = db 
