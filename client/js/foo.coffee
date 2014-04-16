angular.module('clientApp').controller('FooCtrl', ($rootScope, $scope, $http, $location, model, testdata, utils) ->
  $scope.message = null
  $scope.foos = []
  $scope.newName = ''

  $scope.foo = () ->
    console.log 'in foo...'
    console.log 'customer: ' + $scope.invoice.customer

  $scope.deleteFoo = (id) ->
    $http.delete('/foos/' + id).success((data) ->
      console.log 'client deleted foo with id ' + id + ', data: ' + data
      #$scope.foos = data
      getFoos()
    )

  $scope.addFoo = () ->
    postData = {name: $scope.newName}
    $http.post('/foos', postData).success((data) ->
      $scope.message2 = 'insert succesful...'
      $scope.newName = ''
      getFoos()
    )

  getFoos = ->
    $http.get('/foos').success((data) ->
      $scope.message = data
      $scope.foos = []
      for item in data
        foo = new model.Foo()
        foo.id = item._id
        foo.name = item.name
        foo.userid = item.userid
        date = new Date(item.timestamp)
        foo.time = date.getDate() + '.' + (date.getMonth() + 1) + '.' + date.getFullYear()
        $scope.foos.push foo
    )

  getFoos()

)