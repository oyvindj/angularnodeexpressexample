clientApp = angular.module('clientApp', [
  "ngRoute",
  'mobile-angular-ui',
  'mobile-angular-ui.touch',
  'mobile-angular-ui.scrollable',
  'utils'
  'model',
  'testdata',
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
  $routeProvider.when('/forms',     {templateUrl: "templates/demo/forms.html"}, controller: 'DemoCtrl')
  $routeProvider.when('/carousel',  {templateUrl: "templates/demo/carousel.html"})
)

clientApp.controller('ClientCtrl', ($rootScope, $scope, $http, $location, model, testdata, utils) ->
    $scope.userAgent =  navigator.userAgent
    $scope.main = {}
    $scope.main.isDemo = false

    $scope.loginPage = () ->
      $location.path('login')

    $scope.logout = () ->
        $http.get('/logout').success((data) ->
            utils.getLoginStatus($scope, $http)
            $location.path('/')
        )

    $rootScope.$on("$routeChangeStart", () ->
        $rootScope.loading = true
    )
    $rootScope.$on("$routeChangeSuccess", () ->
        $rootScope.loading = false
        utils.getLoginStatus($scope, $http)
    )

    utils.getLoginStatus($scope, $http)
)

