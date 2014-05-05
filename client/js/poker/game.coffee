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
        cardFound = true
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
      if(game.dealerCards.length == 1)
        if($scope.isPlayerBlackjack())
          if(!((game.isElleven(game.dealerCards[0])) || (game.isTen(game.dealerCards[0]))))
            game.dealerStopped = true
            game.playerWinsOnBlackjack = true
      else if(game.dealerCards.length == 2)
        if($scope.isPlayerBlackjack())
          if(!$scope.isDealerBlackjack())
            game.dealerStopped = true
            game.playerWinsOnBlackjack = true
        else if(game.isElleven(game.dealerCards[0]))
          if(game.hasInsurance)
            if(game.isTen(game.dealerCards[1]))
              game.insurancePaysOff = true
      if($scope.getDealerPoints() >= 17)
        game.dealerStopped = true

  game.payWin = ->
    game.totalScore = game.totalScore + $scope.game.bet
    game.reset()
  game.payWinBlackjack = ->
    game.totalScore = game.totalScore + (1.5 * $scope.game.bet)
    game.reset()
  game.payLoss = ->
    game.totalScore = game.totalScore - $scope.game.bet
    game.reset()
  game.reset = ->
    $scope.game.bet = 1

  game.updateStatus = ->
    console.log 'updating total...'
    if(!game.dealerStopped)
      $scope.status = 'Spiller Blackjack...'
    else if(game.playerWinsOnBlackjack)
      game.payWinBlackjack()
      $scope.status = 'Spiller vinner på Blackjack! Game over'
    else if($scope.isDealerBust())
      game.payWin()
      $scope.status = 'Dealer er bust. Spiller vinner. Game over'
    else if($scope.isBust())
      game.payLoss()
      $scope.status = 'Spiller er bust. Dealer vinner! Game over'
    else if ($scope.getDealerPoints() > $scope.getPlayerHighestPoints())
      game.payLoss()
      $scope.status = 'Dealer vinner på poeng. Game over'
    else if($scope.getDealerPoints() == $scope.getPlayerHighestPoints())
      $scope.status = 'Likt. Delt pott. Game over'
    else
      game.payWin()
      $scope.status = 'Spiller vinner på poeng. Game over'

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

  $scope.hit = () ->
    console.log 'hit...'
    game.newPlayerCard()
    if($scope.isBust())
      game.dealerStopped = true
    game.updateStatus()

  $scope.insurance = ->
    console.log 'insurance...'
    game.hasInsurance = true

  $scope.double = ->
    game.playerDoubled = true
    $scope.game.bet = $scope.game.bet * 2

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

  isBlackjack = (cards) ->
    if(cards.length == 2)
      firstCard = cards[0]
      secondCard = cards[1]
      if(game.isTen(firstCard))
        if(game.isElleven(secondCard))
          return true
      if(game.isElleven(firstCard))
        if(game.isTen(secondCard))
          return true
    return false

  $scope.isPlayerBlackjack = ->
    return isBlackjack(game.playerCards)
  $scope.isDealerBlackjack = ->
    return isBlackjack(game.dealerCards)


  $scope.playerHasDifferentHardPoints = ->
    return hasDifferentHardPoints(game.playerCards)
  #return true

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

  $scope.isInsurancePossible = ->
    if(game.hasInsurance)
      return false
    else if(game.dealerCards.length == 1)
      if(game.isElleven(game.dealerCards[0]))
        return true
    return false

  $scope.isDoublePossible = ->
    if((game.playerCards.length == 2) && (!game.playerDoubled))
      return true
    return false

  $scope.hasInsurance = ->
    return game.hasInsurance
  $scope.insurancePaysOff = ->
    return game.insurancePaysOff

  game.totalScore = 0
  game.dealtCards = []
  game.newDeck = ->
  game.dealtCards = []
  $scope.game = {}
  $scope.game.bet = 1

  $scope.newGame = ->
    console.log 'starting game wit bet: ' + $scope.game.bet
    game.playerStopped = false
    game.playerDoubled = false
    game.playerSplit = false
    game.dealerStopped = false
    game.hasInsurance = false
    game.insurancePaysOff = false
    game.playerWinsOnBlackjack = false
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
