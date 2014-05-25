angular.module('clientApp').controller('PokerStatResultsCtrl', ($rootScope, $scope, $http, $location, model, testdata, utils, tables, formulas) ->
  console.log 'in poker stat results controller...'

  $scope.statresults = {}
  $scope.statresults.position = 1
  $scope.statresults.hand = ''
  cardsDealt = []

  $rootScope.$on('stats', (event, stats) ->
    console.log 'statresults received stats: ' + stats.hand
    if(stats.hand != '')
      $scope.statresults.hand = formulas.normalize(stats.hand)
    if(stats.tablecards != '')
      $scope.statresults.tablecards = stats.tablecards.toUpperCase()
    $scope.statresults.position = stats.position
    $scope.statresults.numberOfPlayers = stats.numberOfPlayers
    cardsDealt.push $scope.statresults.hand
  )

  $rootScope.$on('newHand', (event, stats) ->
    console.log 'statresults received newHand event: ' + stats
    $scope.statresults.hand = ''
    $scope.statresults.tablecards = ''
    $scope.statresults.position = stats.position
    $scope.statresults.numberOfPlayers = stats.numberOfPlayers
  )

  getCardsDealtValues = () ->
    values = []
    for card in cardsDealt
      values.push getCardValueForHand(card)
    return values

  $scope.getCardsDealt = ->
    return cardsDealt

  $scope.getAverageCardDealt = ->
    values = getCardsDealtValues()
    total = 0
    for value in values
      total = total + value
    return total / values.length


  $scope.hasHand = ->
    return ($scope.statresults.hand != '')

  $scope.getWinningChance = () ->
    hand = $scope.statresults.hand
    if(hand != '')
      isSuited = false
      if(hand.length == 3)
        isSuited = true
        hand = hand.substring(0, 2)
      winningChance = tables.getChance(hand, $scope.statresults.numberOfPlayers)
      if(isSuited)
        winningChance = winningChance + 4
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
    chances = getChancesSorted(numberOfPlayers)
    keys = Object.keys(chances)
    median = parseInt(keys.length / 2)
    return chances[median]

  sortChancesAsc = (a,b) ->
    a = parseInt(a[1])
    b = parseInt(b[1])
    if(a > b)
      return 1
    else
      if(a == b)
        return 0
      else
        return -1

  getChancesSorted = (numberOfPlayers) ->
    chances = []
    keys = Object.keys(tables.chances)
    for key in keys
      values = tables.chances[key]
      value = values[numberOfPlayers - 2]
      chances.push value
    chances = chances.sort(utils.sortAsc)
    return chances

  $scope.getCardValue = () ->
    hand = $scope.statresults.hand
    return getCardValueForHand(hand)

  getCardValueForHand = (hand) ->
    if(hand == '')
      return -2
    chances = tables.chances
    keys = Object.keys(tables.chances)
    chancesArray = []
    for key in keys
      item = []
      item.push key
      item.push chances[key][0]
      chancesArray.push item
    chancesArray = chancesArray.sort(sortChancesAsc)
    i = 0
    for chance in chancesArray
      i++
      if(chance[0] == hand)
        return (i / chancesArray.length) * 100
    console.log 'no hand found: ' + $scope.statresults.hand
    return -1

)
