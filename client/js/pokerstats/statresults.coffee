angular.module('clientApp').controller('PokerStatResultsCtrl', ($rootScope, $scope, $http, $location, model, testdata, utils, tables, formulas) ->
  console.log 'in poker stat results controller...'

  $scope.statresults = {}
  $scope.statresults.position = 1
  $scope.statresults.hand = ''

  $rootScope.$on('stats', (event, stats) ->
    console.log 'statresults received stats: ' + stats.hand
    if(stats.hand != '')
      $scope.statresults.hand = formulas.normalize(stats.hand)
    if(stats.tablecards != '')
      $scope.statresults.tablecards = stats.tablecards.toUpperCase()
    $scope.statresults.position = stats.position
    $scope.statresults.numberOfPlayers = stats.numberOfPlayers
  )

  $rootScope.$on('newHand', (event, stats) ->
    console.log 'statresults received newHand event: ' + stats
    $scope.statresults.hand = ''
    $scope.statresults.tablecards = ''
    $scope.statresults.position = stats.position
    $scope.statresults.numberOfPlayers = stats.numberOfPlayers
  )

  $scope.hasHand = ->
    return ($scope.statresults.hand != '')

  $scope.getWinningChance = () ->
    hand = $scope.statresults.hand
    if(hand != '')
      isSuited = false
      if(hand.length == 3)
        isSuited = true
        hand = hand.substring(0, 2)
      console.log 'hand: "' + hand + '"'
      winningChance = tables.getChance(hand, $scope.statresults.numberOfPlayers)
      if(isSuited)
        winningChance = winningChance + 4
      console.log 'winningChance: ' + winningChance
      return winningChance
    else
      return -1

  $scope.isDealer = ->
    if($scope.statresults.position == $scope.statresults.numberOfPlayers)
      return true
    else
      return false

  $scope.getPositionGroup = () ->
    positionFactor =  $scope.statresults.position / $scope.statresults.numberOfPlayers
    if(positionFactor > 0.66)
      return 'late'
    else if(positionFactor > 0.33)
      return 'middle'
    else
      return 'early'

  $scope.isLate = ->
    if($scope.getPositionGroup() == 'late')
      return true
    return false
  $scope.isMiddle = ->
    if($scope.getPositionGroup() == 'middle')
      return true
    return false
  $scope.isEarly = ->
    if($scope.getPositionGroup() == 'early')
      return true
    return false

  $scope.isFold = ->
    if($scope.statresults.hand == '')
      return false
    else if($scope.isLate() && $scope.getWinningChance() < 25)
      return true
    else if($scope.isMiddle() && $scope.getWinningChance() < 28)
      return true
    else if($scope.isEarly() && $scope.getWinningChance() < 32)
      return true
    return false

  $scope.isCheck = ->
    if($scope.statresults.hand == '')
      return false
    else if($scope.isLate() && ($scope.getWinningChance() >= 25) && ($scope.getWinningChance() <= 28))
      return true
    else if($scope.isMiddle() && ($scope.getWinningChance() >= 28) && ($scope.getWinningChance() <= 31))
      return true
    else if($scope.isEarly() && ($scope.getWinningChance() >= 32) && ($scope.getWinningChance() <= 35))
      return true
    return false

  $scope.isBet = ->
    if($scope.statresults.hand == '')
      return false
    else if($scope.isLate() && ($scope.getWinningChance() >= 29))
      return true
    else if($scope.isMiddle() && ($scope.getWinningChance() >= 32))
      return true
    else if($scope.isEarly() && ($scope.getWinningChance() >= 36))
      return true
    return false

  $scope.calculateMedian = (numberOfPlayers) ->
    chances = []
    keys = Object.keys(tables.chances)
    median = parseInt(keys.length / 2)
    for key in keys
      values = tables.chances[key]
      value = values[numberOfPlayers - 2]
      chances.push value
    #chances = utils.sortAsc2(chances)
    chances = chances.sort(utils.sortAsc)
    console.log 'calculateMedian() returning: ' + chances[median]
    return chances[median]



)
