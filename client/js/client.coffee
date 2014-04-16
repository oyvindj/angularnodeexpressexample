clientApp = angular.module('clientApp', [
  #'ui.router',
  "ngRoute",
  'mobile-angular-ui',
  'mobile-angular-ui.touch',
  'mobile-angular-ui.scrollable',
  'utils'
  'model',
  'testdata',
])

#angular.module('clientApp.controllers', [])

# angular mobile routing
clientApp.config(($routeProvider, $locationProvider) ->
  $routeProvider.when('/',          {templateUrl: "home.html"})
  $routeProvider.when('/login',     {templateUrl: "templates/login.html"})
  $routeProvider.when('/register',  {templateUrl: "templates/register.html"})
  $routeProvider.when('/addtime',   {templateUrl: "templates/addtime.html", controller: 'AddTimeCtrl'})
  $routeProvider.when('/timeslots', {templateUrl: "templates/timeslots.html", controller: 'TimeCtrl'})
  $routeProvider.when('/contactus', {templateUrl: "templates/contactus.html"})
  $routeProvider.when('/aboutus',   {templateUrl: "templates/aboutus.html"})
  $routeProvider.when('/users',     {templateUrl: "templates/users.html"})
  $routeProvider.when('/scroll',    {templateUrl: "templates/demo/scroll.html"})
  $routeProvider.when('/toggle',    {templateUrl: "templates/demo/toggle.html"})
  $routeProvider.when('/tabs',      {templateUrl: "templates/demo/tabs.html"})
  $routeProvider.when('/accordion', {templateUrl: "templates/demo/accordion.html"})
  $routeProvider.when('/overlay',   {templateUrl: "templates/demo/overlay.html"})
  $routeProvider.when('/forms',     {templateUrl: "templates/demo/forms.html"})
  $routeProvider.when('/carousel',  {templateUrl: "templates/demo/carousel.html"})
)

clientApp.controller('ClientCtrl', ($rootScope, $scope, $http, $location, model, testdata) ->
    console.log 'starting controller...'
    $scope.main = {}
    $scope.main.isDemo = false
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

    $scope.isLogin = () ->
        return "" + $scope.isLogin
    $scope.setLogin = (isLogin) ->
        $scope.isLogin = isLogin

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

    $scope.invoice = {}
    $scope.invoice.customer = ''

    $scope.foo = () ->
      console.log 'in foo...'
      console.log 'customer: ' + $scope.invoice.customer

    $scope.deleteFoo = (id) ->
      $http.delete('/foos/' + id).success((data) ->
        console.log 'client deleted foo with id ' + id + ', data: ' + data
        #$scope.foos = data
        getFoos()
      )

    $scope.loginPage = () ->
      $location.path('login')

    $scope.login = {}
    $scope.login.username = ''
    $scope.login.password = ''
    $scope.login = () ->
        console.log 'login() called...'
        console.log $scope.login.username
        user = {username: $scope.login.username, password: $scope.login.password, rememberme: $scope.rememberme}
        $http.post('/login', user).success((user) ->
            getLoginStatus()
            #window.location = '/'
            $location.path('addtime')
        ).error((err) ->
            console.log "Failed to login: " + err    
        )

    $scope.logout = () ->
        $http.get('/logout').success((data) ->
            getLoginStatus()
            $location.path('/')
        )

    getLoginStatus = ->
        $http.get('/user').success((user) ->
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
        $http.post('/users', user).success((user) ->
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
        $http.delete('/users/' + id).success((data) ->
            #$scope.users = data
            getUsers()
        ).error((err) ->
            console.log "Failed to delete user: " + err
        )


    # from Angular mobile controller
    $rootScope.$on("$routeChangeStart", () ->
        $rootScope.loading = true
    )
    $rootScope.$on("$routeChangeSuccess", () ->
        $rootScope.loading = false
    )
    scrollItems = [];

    i = 0
    while i < 100
        scrollItems.push("Item " + i)
        i++

    $scope.scrollItems = scrollItems
    $scope.userAgent =  navigator.userAgent
    $scope.chatUsers = testdata.chatUsers


    # setting some default data...
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