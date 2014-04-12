clientApp = angular.module('clientApp', ['ui.router', 'model'])

#set up routing
clientApp.config(($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise("/home")
    $stateProvider
      .state('root', {
          url: ''
          views: {
            "menu": {
              templateUrl: 'templates/menu.html'
            },
            "footer": {
              templateUrl: "templates/footer.html"
            },
            "container@": {
              templateUrl: 'templates/home.html'
            }
          }
        })
        .state('root.home', {
            url: '/home'
            views: {
              "container@": {
                templateUrl: 'templates/home.html'
              }
            }
          })
        .state('root.list', {
            url: '/list'
            views: {
              "container@": {
                templateUrl: 'templates/list.html'
                controller: 'ListCtrl'
              }
            }
        })
        .state('root.list.item', {
            url: '/:item'
            templateUrl: 'templates/list.item.html'
            controller: ($scope, $stateParams) ->
                $scope.item = $stateParams.item
        })
        .state('root.profile', {
            url: '/profile'
            views: {
              "container@": {
                templateUrl: 'templates/profile.html'
              }
            }
        })
        .state('root.users', {
            url: '/users'
            views: {
              "container@": {
                templateUrl: 'templates/users.html'
              }
            }
        })
        .state('root.contactus', {
          url: '/contactus'
          views: {
            "container@": {
              templateUrl: 'templates/contactus.html'
            }
          }
        })
        .state('root.login', {
            url: '/login'
            views: {
              "container@": {
                templateUrl: 'templates/login.html'
              }
            }
        })
        .state('root.register', {
            url: '/register'
            views: {
              "container@": {
                templateUrl: 'templates/register.html'
              }
            }
        })
)

clientApp.controller('ClientCtrl', ($scope, $http, $location, model) ->
    console.log 'starting controller...'
    $scope.message = null
    $scope.foos = []
    $scope.users = []
    $scope.newName = ''
    $scope.username = ''
    $scope.email = ''
    $scope.password = ''
    $scope.verifyPassword = ''
    $scope.rememberme = false
    $scope.isLogin = true

    #baseUrl = 'https://angularnodeexpressexample-c9-oyvindj_1.c9.io'
    #baseUrl = 'http://localhost:3000'
    baseUrl = ''

    $scope.isLogin = () ->
        return "" + $scope.isLogin
    $scope.setLogin = (isLogin) ->
        $scope.isLogin = isLogin

    $scope.addFoo = () ->
        postData = {name: $scope.newName}
        $http.post(baseUrl + '/foos', postData).success((data) ->
            $scope.message2 = 'insert succesful...'
            $scope.newName = ''
            getFoos()
        )
        
    getFoos = ->
        $http.get(baseUrl + '/foos').success((data) ->
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

    getUsers = ->
      $http.get(baseUrl + '/users').success((data) ->
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

    $scope.deleteFoo = (id) ->
      $http.delete(baseUrl + '/foos/' + id).success((data) ->
        console.log 'client deleted foo with id ' + id + ', data: ' + data
        #$scope.foos = data
        getFoos()
      )

    $scope.login = () ->
        user = {username: $scope.username, password: $scope.password, rememberme: $scope.rememberme}
        $http.post(baseUrl + '/login', user).success((user) ->
            getLoginStatus()
            window.location = '/'
        ).error((err) ->
            console.log "Failed to login: " + err    
        )

    $scope.logout = () ->
        $http.get(baseUrl + '/logout').success((data) ->
            getLoginStatus()
            $location.path('/')
        )

    getLoginStatus = ->
        $http.get(baseUrl + '/user').success((user) ->
            if(user)
                $scope.loggedInUser = user.username
                $scope.loggedInEmail = user.email
                $scope.isLoggedIn = true
            else
                $scope.loggedInUser = 'Gjest'
                $scope.loggedInEmail = '-'
                $scope.isLoggedIn = false
        )

    $scope.register = () ->
        user = {username: $scope.username, password: $scope.password, email: $scope.email}
        $http.post(baseUrl + '/users', user).success((user) ->
            getUsers()
            $scope.username = ''
            $scope.email = ''
            $scope.password = ''
            $scope.verifyPassword = ''
            $scope.registerMessage = 'Registration Successful'
        ).error((err) ->
          console.log "Failed to add user: " + err
        )

    $scope.deleteUser = (id) ->
      console.log 'deleting user...'
      $http.delete(baseUrl + '/users/' + id).success((data) ->
        #$scope.users = data
        getUsers()
      ).error((err) ->
        console.log "Failed to delete user: " + err
      )

    getFoos()
    if($scope.isLoggedIn)
        getUsers()
    getLoginStatus()
    console.log 'ending controller...'
)

clientApp.controller('ListCtrl', ($scope, $http) ->
    $scope.shoppingList = [
        {name: 'Milk'}
        {name: 'Eggs'}
        {name: 'Bread'}
        {name: 'Cheese'}
        {name: 'Ham'}
    ]
    $scope.selectItem = (selectedItem) ->
        _($scope.shoppingList).each((item) ->
            item.selected = false
            if(selectedItem == item)
                selectedItem.selected = true
        )
    $scope.shoppingList[0].selected = true
    
)