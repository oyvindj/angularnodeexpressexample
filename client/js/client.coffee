clientApp = angular.module('clientApp', ['ui.router'])

#set up routing
clientApp.config(($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise("/home")
    $stateProvider
        .state('index', {
            url: '/'
            templateUrl: 'templates/home.html'
        })
        .state('home', {
            url: '/home'
            templateUrl: 'templates/home.html'
        })
        .state('list', {
            url: '/list'
            templateUrl: 'templates/list.html'
            controller: 'ListCtrl'
        })
        .state('list.item', {
            url: '/:item'
            templateUrl: 'templates/list.item.html'
            controller: ($scope, $stateParams) ->
                $scope.item = $stateParams.item
        })
)

clientApp.controller('ClientCtrl', ($scope, $http, $location) ->
        
    $scope.message = null
    $scope.foos = []
    $scope.newName = ''
    $scope.username = ''
    $scope.password = ''
    $scope.verifyPassword = ''
    $scope.rememberme = false
    $scope.isLogin = true

    #baseUrl = 'https://angularnodeexpressexample-c9-oyvindj_1.c9.io'
    baseUrl = 'http://localhost:3000'

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
            $scope.foos = data
        )

    $scope.deleteFoo = (id) ->
      console.log 'client deleting foo with id ' + id
      $http.delete(baseUrl + '/foos/' + id).success((data) ->
        console.log 'client deleted foo with id ' + id + ', data: ' + data
        $scope.foos = data
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
                $scope.loggedInUser = 'Guest'
                $scope.loggedInEmail = '-'
                $scope.isLoggedIn = false
        )

    getFoos()
    getLoginStatus()
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