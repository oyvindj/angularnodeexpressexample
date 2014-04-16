# this file has demo related scope attributes that used to be in MainController (examples.js)
angular.module('clientApp').controller('DemoCtrl', ($rootScope, $scope, $http, $location, model, testdata, utils) ->

  scrollItems = [];
  i = 0
  while i < 100
    scrollItems.push("Item " + i)
    i++
  $scope.scrollItems = scrollItems

  $scope.invoice = {}
  $scope.invoice.customer = ''

)
