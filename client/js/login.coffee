angular.module('clientApp').controller('LoginCtrl', ($rootScope, $scope, $http, $location, model, testdata, utils) ->
  $scope.login = {}
  $scope.login.username = ''
  $scope.login.password = ''
  $scope.login.rememberme = false
  $scope.login = () ->
      console.log 'login() called...'
      console.log $scope.login.username
      user = {username: $scope.login.username, password: $scope.login.password, rememberme: $scope.rememberme}
      $http.post('/login', user).success((user) ->
          $scope.login.username = ''
          $scope.login.password = ''
          $scope.login.rememberme = false
          utils.getLoginStatus($scope, $http)
          $location.path('addtime')
      ).error((err) ->
          console.log "Failed to login: " + err
      )

)

angular.module('clientApp').controller('RegisterCtrl', ($rootScope, $scope, $http, $location, model, testdata, utils) ->
  $scope.register = {}
  $scope.register.username = ''
  $scope.register.email = ''
  $scope.register.password = ''
  $scope.register.verifyPassword = ''
  $scope.register.rememberme = false

  $scope.register = () ->
    user = {username: $scope.register.username, password: $scope.register.password, email: $scope.register.email}
    $http.post('/users', user).success((user) ->
      #getUsers()
      $scope.register.username = ''
      $scope.register.email = ''
      $scope.register.password = ''
      $scope.register.verifyPassword = ''
      $scope.register.message = 'Registration Successful'
    ).error((err) ->
      console.log "Failed to add user: " + err
    )
)

angular.module('clientApp').controller('UserCtrl', ($rootScope, $scope, $http, $location, model, testdata, utils) ->
  $scope.users = []

  getUsers = ->
    $http.get('/users').success((data) ->
        $scope.message = data
        $scope.users = []
        for item in data
            user = new model.User()
            user.id = item._id
            user.username = item.username
            user.userid = item.userid
            user.email = item.email
            date = new Date(item.timestamp)
            user.time = date.getDate() + '.' + (date.getMonth() + 1) + '.' + date.getFullYear()
            $scope.users.push user
    )

  $scope.deleteUser = (id) ->
      console.log 'deleting user...'
      $http.delete('/users/' + id).success((data) ->
          getUsers()
      ).error((err) ->
          console.log "Failed to delete user: " + err
      )

  if($scope.isLoggedIn)
      getUsers()
)