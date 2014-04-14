clientApp = angular.module('clientApp', [
  #'ui.router',
  "ngRoute",
  'mobile-angular-ui',
  'mobile-angular-ui.touch',
  'mobile-angular-ui.scrollable'
  'model',
  'testdata',
])

# angular mobile routing
clientApp.config(($routeProvider, $locationProvider) ->
  $routeProvider.when('/',          {templateUrl: "home.html"})
  $routeProvider.when('/login',     {templateUrl: "templates/login.html"})
  $routeProvider.when('/register',  {templateUrl: "templates/register.html"})
  $routeProvider.when('/addtime',   {templateUrl: "templates/addtime.html"})
  $routeProvider.when('/timeslots',   {templateUrl: "templates/timeslots.html"})
  $routeProvider.when('/users',     {templateUrl: "templates/users.html"})
  $routeProvider.when('/scroll',    {templateUrl: "scroll.html"})
  $routeProvider.when('/toggle',    {templateUrl: "toggle.html"})
  $routeProvider.when('/tabs',      {templateUrl: "tabs.html"})
  $routeProvider.when('/accordion', {templateUrl: "accordion.html"})
  $routeProvider.when('/overlay',   {templateUrl: "overlay.html"})
  $routeProvider.when('/forms',     {templateUrl: "forms.html"})
  $routeProvider.when('/carousel',  {templateUrl: "carousel.html"})
)


#set up routing
#clientApp.config(($stateProvider, $urlRouterProvider) ->
#    $urlRouterProvider.otherwise("/home")
#    $stateProvider
#      .state('root', {
#          url: ''
#          views: {
#            "menu": {
#              templateUrl: 'templates/menu.html'
#            },
#            "footer": {
#              templateUrl: "templates/footer.html"
#            },
#            "container@": {
#              templateUrl: 'templates/home.html'
#            }
#          }
#        })
#        .state('root.home', {
#            url: '/home'
#            views: {
#              "container@": {
#                templateUrl: 'templates/home.html'
#              }
#            }
#          })
#        .state('root.list', {
#            url: '/list'
#            views: {
#              "container@": {
#                templateUrl: 'templates/list.html'
#                controller: 'ListCtrl'
#              }
#            }
#        })
#        .state('root.list.item', {
#            url: '/:item'
#            templateUrl: 'templates/list.item.html'
#            controller: ($scope, $stateParams) ->
#                $scope.item = $stateParams.item
#        })
#        .state('root.profile', {
#            url: '/profile'
#            views: {
#              "container@": {
#                templateUrl: 'templates/profile.html'
#              }
#            }
#        })
#        .state('root.users', {
#            url: '/users'
#            views: {
#              "container@": {
#                templateUrl: 'templates/users.html'
#              }
#            }
#        })
#        .state('root.contactus', {
#          url: '/contactus'
#          views: {
#            "container@": {
#              templateUrl: 'templates/contactus.html'
#            }
#          }
#        })
#        .state('root.login', {
#            url: '/login'
#            views: {
#              "container@": {
#                templateUrl: 'templates/login.html'
#              }
#            }
#        })
#        .state('root.register', {
#            url: '/register'
#            views: {
#              "container@": {
#                templateUrl: 'templates/register.html'
#              }
#            }
#        })
#)

clientApp.controller('ClientCtrl', ($rootScope, $scope, $http, $location, model, testdata) ->
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

    $scope.invoice = {}
    $scope.invoice.customer = ''

    $scope.foo = () ->
      console.log 'in foo...'
      console.log 'customer: ' + $scope.invoice.customer

    $scope.deleteFoo = (id) ->
      $http.delete(baseUrl + '/foos/' + id).success((data) ->
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
        $http.post(baseUrl + '/login', user).success((user) ->
            getLoginStatus()
            #window.location = '/'
            getTimeslots()
            $location.path('addtime')
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

    #addtime page
    $scope.addtime = {}
    $scope.colors = [
      {name:'BKK', id:1},
      {name:'Egenopplæring', id:2},
    ]
    toDateInput = (date) ->
      monthString = (date.getMonth() + 1).toString()
      if(monthString.length == 1)
          monthString = '0' + monthString
      dayString = date.getDate().toString()
      if(dayString.length == 1)
        dayString = '0' + dayString
      dateString = date.getFullYear() + '-' + monthString + '-' + dayString
      console.log 'returning ' + dateString
      return dateString

    toTime = (date) ->
      hoursString = date.getHours().toString()
      minutesString = date.getMinutes().toString()
      if(hoursString.length == 1)
          hoursString = '0' + hoursString
      if(minutesString.length == 1)
        minutesString = '0' + minutesString
      return hoursString + '.' + minutesString


    $scope.addtime.project = $scope.colors[0]
    $scope.addtime.date = toDateInput(new Date())
    $scope.addtime.from = '9.00'
    $scope.addtime.to = ''

    appendMinutes = (time) ->
        if(time.indexOf('.') == -1)
            time = time + '.00'
        return time

    $scope.addTime = () ->
      console.log 'in addTime()...'
      date = $scope.addtime.date
      project = $scope.addtime.project.id
      from = $scope.addtime.from
      to = $scope.addtime.to
      from = appendMinutes(from)
      to = appendMinutes(to)
      data = {}
      data.date = new Date(date)
      data.project = project
      console.log 'data.date: ' + data.date
      console.log 'data.project: ' + data.project
      fromHours = parseInt(from.split(".")[0])
      fromMinutes = parseInt(from.split(".")[1])
      toHours = parseInt(to.split(".")[0])
      toMinutes = parseInt(to.split(".")[1])
      fromDate = new Date(data.date.getTime())
      fromDate.setHours(fromHours)
      fromDate.setMinutes(fromMinutes)
      toDate = new Date(data.date.getTime())
      toDate.setHours(toHours)
      toDate.setMinutes(toMinutes)
      console.log 'fromDate: ' + fromDate
      console.log 'toDate: ' + toDate
      data.from = fromDate
      data.to = toDate
      console.log 'data.from: ' + data.from
      console.log 'data.to: ' + data.to
      data.year = fromDate.getFullYear()
      $http.post(baseUrl + '/timeslots', data).success((postData) ->
          getTimeslots()
          $location.path('timeslots')
      )

    getTimeslots = ->
      $http.get(baseUrl + '/timeslots').success((data) ->
          $scope.message = data
          $scope.timeslots = []
          for item in data
              console.log item
              timeslot = new model.Timeslot()
              timeslot.id = item._id
              if(item.date)
                timeslot.date = toDateInput(new Date(item.date))
              timeslot.project = $scope.colors[item.project - 1]
              timeslot.from = toTime(new Date(item.from))
              timeslot.to = toTime(new Date(item.to))
              console.log timeslot
              $scope.timeslots.push timeslot
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