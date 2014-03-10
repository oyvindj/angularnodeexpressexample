clientApp = angular.module('clientApp', ['ui.router'])

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

clientApp.controller('ClientCtrl', ($scope, $http) ->
    $scope.phones = [
        {'name': 'Nexus S','snippet': 'Fast just got faster with Nexus S.'},
        {'name': 'Motorola XOOM™ with Wi-Fi','snippet': 'The Next, Next Generation tablet.'},
        {'name': 'MOTOROLA XOOM™','snippet': 'The Next, Next Generation tablet.'}]
    
    $scope.message = null
    $scope.foos = []
    $http.get('https://angularnodeexpressexample-c9-oyvindj_1.c9.io/foos').success((data) ->
        $scope.message = data
        $scope.foos = data
    )
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
)