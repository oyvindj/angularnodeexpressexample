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
  $routeProvider.when('/quiz',      {templateUrl: "templates/quiz/quiz.html"})
  $routeProvider.when('/newquiz',   {templateUrl: "templates/quiz/newgame.html"})
  $routeProvider.when('/poker',     {templateUrl: "templates/poker/poker.html"})
  $routeProvider.when('/game',      {templateUrl: "templates/poker/game.html"})
)

clientApp.controller('ClientCtrl', ($rootScope, $scope, $http, $location, model, testdata, utils) ->

    $scope.userAgent =  navigator.userAgent
    $scope.main = {}
    $scope.main.isDemo = false

    # ========= to be moved to separate controller ===============
    console.log 'in quiz controller...'
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
      while(!cardFound)
        newCard = $scope.pickRandom1to52()
        if($.inArray(newCard, game.dealtCards))
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
        if($scope.getDealerPoints() >= 17)
          game.dealerStopped = true
          #$location.path('game')

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

    game.totalScore = 0

    $scope.getTotalScore = ->
      return game.totalScore

    $scope.newGame = ->
      game.playerStopped = false
      game.playerDoubled = false
      game.playerSplit = false
      game.dealerStopped = false
      game.dealerCards = []
      game.playerCards = []
      game.dealtCards = []
      game.newPlayerCard()
      game.newPlayerCard()
      game.newDealerCard()
      game.updateStatus()

    $scope.newGame()


  # ============================================================

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

    $rootScope.$on("$routeChangeStart", () ->
        $rootScope.loading = true
    )
    $rootScope.$on("$routeChangeSuccess", () ->
        $rootScope.loading = false
        utils.getLoginStatus($scope, $http)
    )

    utils.getLoginStatus($scope, $http)
)

