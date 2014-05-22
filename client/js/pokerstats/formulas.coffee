app = angular.module 'formulas', []

app.factory('formulas', (tables) ->
  formulas = {}

  formulas.normalize = (cards) ->
    ucCards = cards.toUpperCase().trim()
    card1 = ucCards.charAt(0)
    card2 = ucCards.charAt(1)
    suitedChar = ''
    if(ucCards.length == 3)
      suitedChar = ucCards.charAt(2)
    suited = false
    if(suitedChar == 'S')
      suited = true
    normal = card1 + card2
    opposite = card2 + card1
    if(suited)
      normal = normal + suitedChar
      opposite = opposite + suitedChar
    if(tables.getValue(card1) >= tables.getValue(card2))
      return normal
    else
      return opposite


  return formulas
)

