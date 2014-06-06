angular.module('clientApp').directive('focus', ($timeout, $parse) ->
  return {
    restrict: 'A',
    link: (scope, element, attrs) ->
      scope.$watch(attrs.focus, (newValue, oldValue) ->
        if (newValue)
          element[0].focus()
      )
      element.bind("blur", (e) ->
        $timeout(() ->
          scope.$apply(attrs.focus + "=false")
        , 0)
      )
      element.bind("focus", (e) ->
        $timeout(() ->
          scope.$apply(attrs.focus + "=true")
        , 0)
      )
  }
)

angular.module('clientApp').controller('PokerStatsCtrl', ($rootScope, $scope, $http, $location, model, testdata, utils, tables, formulas) ->
  console.log 'in poker stats controller...'
  console.log 'chance: ' + tables.getChance(formulas.normalize('KA'), 2)

  init = ->
    $scope.stats = {}
    $scope.stats.hand = ''
    $scope.stats.tablecards = ''
    $scope.stats.numberOfPlayers = 5
    $scope.stats.position = 2
    $scope.stats.focusHand = true
    $scope.stats.focusTablecards = false
    $scope.stats.focusNewHand = false
    $scope.stats.waitingForResult = false

  init()

  $scope.fold = ->
    $scope.stats.waitingForResult = false
    $rootScope.$broadcast('fold', $scope.stats)
    $scope.newHand()
  $scope.winBeforeFlop = ->
    $scope.stats.waitingForResult = false
    $rootScope.$broadcast('winBeforeFlop', $scope.stats)
    $scope.newHand()
  $scope.winAfterFlop = ->
    $scope.stats.waitingForResult = false
    $rootScope.$broadcast('winAfterFlop', $scope.stats)
    $scope.newHand()
  $scope.looseBeforeFlop = ->
    $scope.stats.waitingForResult = false
    $rootScope.$broadcast('looseBeforeFlop', $scope.stats)
    $scope.newHand()
  $scope.looseAfterFlop = ->
    $scope.stats.waitingForResult = false
    $rootScope.$broadcast('looseAfterFlop', $scope.stats)
    $scope.newHand()

  $scope.eventInput = (code) ->
    console.log 'eventInput, code: ' + code
    if(code == 78)
      $scope.newHand()

  $scope.positionPlus = ->
    $scope.stats.position++
    $scope.stats.focusHand = true
  $scope.positionMinus = ->
    $scope.stats.position--
    $scope.stats.focusHand = true

  $scope.playersPlus = ->
    $scope.stats.numberOfPlayers++
    $scope.stats.focusHand = true
  $scope.playersMinus = ->
    $scope.stats.numberOfPlayers--
    $scope.stats.focusHand = true

  $scope.newSession = ->
    console.log 'new session...'
    init()
    $rootScope.$broadcast('newSession', $scope.stats)

  $scope.addHand = ->
    console.log 'in addHand()...'
    $scope.stats.hand = $scope.stats.hand.toUpperCase()
    if($scope.stats.tablecards != '')
      $scope.stats.tablecards = $scope.stats.tablecards.toUpperCase()
      $scope.stats.focusNewHand = true
    else
      $scope.stats.focusNewHand = true
    $scope.stats.waitingForResult = true
    $rootScope.$broadcast('stats', $scope.stats)
    $scope.stats.hand = ''

  $scope.newHand = () ->
    console.log 'in newHand()...'
    position = parseInt($scope.stats.position.toString())
    numberOfPlayers = parseInt($scope.stats.numberOfPlayers.toString())
    #$scope.focusHand = false
    $scope.stats.hand = ''
    $scope.stats.tablecards = ''
    if(position == 1)
      $scope.stats.position = numberOfPlayers
    else
      $scope.stats.position = position - 1
    $rootScope.$broadcast('newHand', $scope.stats)
    $scope.stats.focusTablecards = false
    $scope.stats.focusHand = true


  $scope.isDealer = ->
    if($scope.stats.position.toString() == $scope.stats.numberOfPlayers.toString())
      return true
    else
      return false

  $scope.addGameInfo = ->
    console.log 'in addGameInfo()...'

)
