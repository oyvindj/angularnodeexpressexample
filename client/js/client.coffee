clientApp = angular.module('clientApp', [
  "ngRoute",
  'mobile-angular-ui',
  'mobile-angular-ui.touch',
  'mobile-angular-ui.scrollable',
  'utils'
  'model',
  'testdata',
  'tables',
  'formulas'
])

clientApp.config(($routeProvider, $locationProvider) ->
  $routeProvider.when('/',          {templateUrl: "home.html"})
  $routeProvider.when('/login',     {templateUrl: "templates/login.html", controller: 'LoginCtrl'})
  $routeProvider.when('/register',  {templateUrl: "templates/register.html", controller: 'RegisterCtrl'})
  $routeProvider.when('/addtime',   {templateUrl: "templates/addtime.html", controller: 'AddTimeCtrl'})
  $routeProvider.when('/timeslots', {templateUrl: "templates/timeslots.html", controller: 'TimeCtrl'})
  $routeProvider.when('/contactus', {templateUrl: "templates/contactus.html"})
  $routeProvider.when('/aboutus',   {templateUrl: "templates/aboutus.html"})
  $routeProvider.when('/users',     {templateUrl: "templates/users.html", controller: 'UserCtrl'})
  $routeProvider.when('/scroll',    {templateUrl: "templates/demo/scroll.html", controller: 'DemoCtrl'})
  $routeProvider.when('/toggle',    {templateUrl: "templates/demo/toggle.html"})
  $routeProvider.when('/tabs',      {templateUrl: "templates/demo/tabs.html"})
  $routeProvider.when('/accordion', {templateUrl: "templates/demo/accordion.html"})
  $routeProvider.when('/overlay',   {templateUrl: "templates/demo/overlay.html"})
  $routeProvider.when('/forms',     {templateUrl: "templates/demo/forms.html"})
  $routeProvider.when('/carousel',  {templateUrl: "templates/demo/carousel.html"})
  $routeProvider.when('/quiz',      {templateUrl: "templates/quiz/quiz.html"})
  $routeProvider.when('/newquiz',   {templateUrl: "templates/quiz/newgame.html"})
  $routeProvider.when('/blackjack', {templateUrl: "templates/blackjack/poker.html"})
  $routeProvider.when('/game',      {templateUrl: "templates/blackjack/game.html", controller: 'GameCtrl'})
  $routeProvider.when('/pokerstats',{templateUrl: "templates/pokerstats/stats.html", controller: 'PokerStatsCtrl'})
)

clientApp.directive('keyCapture', [() ->

  return {
    link: (scope, element, attrs, controller) ->
      element.bind('keydown', (e) ->
        console.log(e.keyCode)
        console.log(clientApp)
        console.log clientApp.controller
        scope.$apply( ->
          scope.eventInput(e.keyCode)
        )
      )
    controller: 'PokerStatsCtrl'
  }
])

clientApp.controller('ClientCtrl', ($rootScope, $scope, $http, $location, model, testdata, utils) ->

    $scope.userAgent =  navigator.userAgent
    $scope.main = {}
    $scope.main.isDemo = false


    # ========= to be moved to separate controller ===============

    $scope.newquiz = {}
    $scope.newquiz = () ->
      console.log 'creating new quiz with name: ' + $scope.newquiz.name
      $location.path('addquestion')

    # ============================================================

    $scope.loginPage = () ->
      $location.path('login')

    $scope.logout = () ->
        $http.get('/logout').success((data) ->
            utils.getLoginStatus($scope, $http)
            $location.path('/')
        )

    $scope.foo = () ->
      console.log 'in foo()...'
    $scope.invoice = {}
    $scope.invoice.customer = ''

    $rootScope.$on("$routeChangeStart", () ->
        $rootScope.loading = true
    )
    $rootScope.$on("$routeChangeSuccess", () ->
        $rootScope.loading = false
        utils.getLoginStatus($scope, $http)
    )

    utils.getLoginStatus($scope, $http)
)

