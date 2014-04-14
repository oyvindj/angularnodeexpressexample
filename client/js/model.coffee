app = angular.module 'model', []

app.factory('model', () ->
    model = {}

    model.Foo = class Foo

    model.User = class User

    model.Timeslot = class Timeslot

    return model
)