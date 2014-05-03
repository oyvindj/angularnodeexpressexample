angular.module('clientApp').controller('GameCtrl', ($rootScope, $scope, $http, $location, model, testdata, utils) ->
  # ========= to be moved to separate controller ===============
  console.log 'in poker game controller...'
  $scope.newgame = {}
  $scope.newgame = () ->
    console.log 'creating new poker game: ' + $scope.newquiz.name
    $location.path('game')

  $scope.pickRandom1to52 = () ->
    return Math.floor((Math.random() * 52) + 1)

  game = {}
  game.result = {}
  game.result.DRAW = 1
  game.result.PLAYER_WON = 2
  game.result.DEALER_WON = 3


  game.isTen = (card) ->
    if((card >= 5) && (card <= 20))
      return true
    else
      return false
  game.isElleven = (card) ->
    if(card <= 4)
      return true
    else
      return false

  game.getCardPoints = (card) ->
    if(game.isElleven(card))
      return 11
    else if(game.isTen(card))
      return 10
    else if (card <= 24)
      return 9
    else if (card <= 28)
      return 8
    else if (card <= 32)
      return 7
    else if (card <= 36)
      return 6
    else if (card <= 40)
      return 5
    else if (card <= 44)
      return 4
    else if (card <= 48)
      return 3
    else if (card <= 52)
      return 2

  $scope.getDealerPoints = () ->
    #return getPoints(game.dealerCards)
    #return getLowestSoftPoints(game.dealerCards)
    return getHighestPoints(game.dealerCards)

  game.ellevens = [1,2,3,4]

  getCard = (cards) ->
    cardFound = false
    newCard = -1
    count = 0
    while(!cardFound)
      newCard = $scope.pickRandom1to52()
      count++
      if(count > 52)
        console.log 'deck is empty, should not happen...'
        #TODO - not correct, rewrite...
        cardFound = true
      else if(game.dealtCards.indexOf(newCard) == -1)
        console.log 'found card: ' + newCard
        cardFound = true
      else
        console.log 'card already drawn: ' + newCard
    cards.push newCard
    game.dealtCards.push newCard

  game.newPlayerCard = () ->
    getCard(game.playerCards)
  game.newDealerCard = () ->
    getCard(game.dealerCards)

  game.dealCardsToDealer = ->
    console.log 'dealing to dealer...'
    while(!game.dealerStopped)
      game.newDealerCard()
      if($scope.getDealerPoints() >= 17)
        game.dealerStopped = true

  game.updateStatus = ->
    console.log 'updating total...'
    if(!game.dealerStopped)
      $scope.status = 'Playing game...'
    else if($scope.isDealerBust())
      game.totalScore = game.totalScore + 1
      $scope.status = 'Dealer busted. Player won. Game over'
    else if($scope.isBust())
      game.totalScore = game.totalScore - 1
      $scope.status = 'Player busted. Dealer Won! Game over'
    else if ($scope.getDealerPoints() > $scope.getPlayerHighestPoints())
      game.totalScore = game.totalScore - 1
      $scope.status = 'Dealer won on points. Game over'
    else if($scope.getDealerPoints() == $scope.getPlayerHighestPoints())
      $scope.status = 'Game was a draw. Game over'
    else
      game.totalScore = game.totalScore + 1
      $scope.status = 'Player won on points. Game over'

  $scope.getStatus = ->
    return $scope.status

  getImages = (cards) ->
    images = []
    for card in cards
      image = card + '.png'
      images.push image
    return images

  $scope.getPlayerImages = () ->
    return getImages(game.playerCards)

  $scope.getDealerImages = () ->
    return getImages(game.dealerCards)

  $scope.isBust = ->
    if(getLowestSoftPoints(game.playerCards) > 21)
      return true
    else
      return false

  $scope.isDealerBust = ->
    if(getLowestSoftPoints(game.dealerCards) > 21)
      return true
    else
      return false

  $scope.stop = ->
    console.log 'player stopping...'
    game.playerStopped = true
    game.dealCardsToDealer()
    game.updateStatus()

  $scope.double = ->
    game.playerDoubled = true

  $scope.split = ->
    game.playerSplit = true

  getNumberOfAces = (cards) ->
    count = 0
    for card in cards
      if(game.isElleven(card))
        count++
    return count

  getNumberOfPlayerAces = ->
    return getNumberOfAces(game.playerCards)

  getNumberOfPlayerAces = ->
    return getNumberOfAces(game.dealerCards)

  getLowestSoftPoints = (cards) ->
    points = 0
    for card in cards
      if(!game.isElleven(card))
        points = points + game.getCardPoints(card)
    points = points + getNumberOfAces(cards)
    return points

  getHighestPoints = (cards) ->
    points = 0
    for card in cards
      if(!game.isElleven(card))
        points = points + game.getCardPoints(card)

    aces = getNumberOfAces(cards)
    if(aces > 0)
      if((points + (aces - 1) + 11) <= 21)
        points = points + 11 + (aces - 1)
      else
        points = points + aces
    return points

  $scope.getPlayerHighestPoints = ->
    return getHighestPoints(game.playerCards)

  $scope.getPlayerLowestSoftPoints = ->
    return getLowestSoftPoints(game.playerCards)

  $scope.getDealerHighestPoints = ->
    return getHighestPoints(game.DealerCards)

  hasDifferentHardPoints = (cards) ->
    if(getLowestSoftPoints(cards) != getHighestPoints(cards))
      return true
    return false

  $scope.playerHasDifferentHardPoints = ->
    return hasDifferentHardPoints(game.playerCards)
  #return true

  $scope.hit = () ->
    console.log 'hit...'
    game.newPlayerCard()
    if($scope.isBust())
      game.dealerStopped = true
    game.updateStatus()

  $scope.showButtons = ->
    if(($scope.isBust()) || (game.playerStopped))
      return false
    return true

  $scope.showNewGameButton = ->
    if((!$scope.showButtons()) || (game.dealerStopped))
      return true
    return false

  $scope.numberOfCardsDealt = ->
    return game.dealtCards.length

  $scope.getTotalScore = ->
    return game.totalScore

  game.totalScore = 0
  game.dealtCards = []
  game.newDeck = ->
    game.dealtCards = []

  $scope.newGame = ->
    game.playerStopped = false
    game.playerDoubled = false
    game.playerSplit = false
    game.dealerStopped = false
    game.dealerCards = []
    game.playerCards = []
    if(game.dealtCards.length > 40)
      game.newDeck()
    game.newPlayerCard()
    game.newPlayerCard()
    game.newDealerCard()
    game.updateStatus()

  $scope.newGame()


  # ============================================================

)
