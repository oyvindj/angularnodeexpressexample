angular.module('clientApp').controller('PokerStatsCtrl', ($rootScope, $scope, $http, $location, model, testdata, utils) ->
  console.log 'in poker stats controller...'

  $scope.addHand = ->
    console.log 'in addHand()...'

  $scope.addGameInfo = ->
    console.log 'in addGameInfo()...'
)
