app = angular.module 'tables', []

app.factory('tables', () ->
  tables = {}

  tables.values = {
    '2' : {value: 2}
    '3' : {value: 3}
    '4' : {value: 4}
    '5' : {value: 5}
    '6' : {value: 6}
    '7' : {value: 7}
    '8' : {value: 8}
    '9' : {value: 9}
    'T' : {value: 10}
    'J' : {value: 11}
    'Q' : {value: 12}
    'K' : {value: 13}
    'A' : {value: 14}
  }

  tables.getValue = (card) ->
    return tables.values[card].value

  tables.chances = {
    'AA': [85, 73, 64, 56, 49, 43, 39, 31]
    'KK': [82, 69, 58, 50, 43, 38, 33, 29]
    'QQ': [80, 65, 54, 45, 38, 33, 28, 25]
    'JJ': [78, 61, 49, 40, 34, 29, 25, 22]
    'TT': [75, 58, 45, 36, 30, 25, 22, 19]
    '99': [72, 54, 41, 33, 26, 22, 19, 17]
    '88': [69, 50, 38, 29, 24, 20, 18, 16]
    '77': [66, 46, 34, 26, 21, 19, 16, 15]
    '66': [63, 43, 32, 25, 20, 17, 15, 14]
    '55': [60, 40, 29, 22, 19, 16, 14, 13]
    '44': [57, 37, 25, 21, 17, 15, 14, 13]
    '33': [54, 34, 24, 19, 16, 15, 14, 13]
    '22': [50, 31, 22, 18, 16, 14, 13, 13]
    'AK': [65, 48, 39, 32, 28, 24, 22, 19]
    'AQ': [64, 47, 37, 30, 26, 23, 20, 18]
    'AJ': [64, 46, 35, 29, 24, 21, 18, 16]
    'AT': [63, 44, 34, 28, 23, 20, 17, 15]
    'A9': [61, 42, 31, 25, 20, 17, 15, 13]
    'A8': [60, 41, 30, 24, 19, 16, 14, 12]
    'A7': [59, 39, 28, 22, 18, 15, 13, 11]
    'A6': [58, 38, 28, 21, 17, 14, 12, 11]
    'A5': [58, 38, 28, 21, 17, 14, 12, 11]
    'A4': [56, 37, 27, 21, 17, 14, 12, 11]
    'A3': [56, 36, 26, 20, 17, 14, 12, 10]
    'A2': [55, 35, 25, 20, 16, 14, 12, 10]
    'KQ': [61, 44, 35, 29, 25, 21, 19, 17]
    'KJ': [61, 43, 34, 28, 24, 20, 18, 16]
    'KT': [60, 42, 33, 27, 22, 19, 17, 15]
    'K9': [58, 40, 30, 24, 20, 17, 14, 12]
    'K8': [56, 37, 27, 21, 17, 15, 13, 11]
    'K7': [55, 36, 26, 21, 17, 14, 12, 10]
    'K6': [54, 35, 25, 20, 16, 13, 11, 10]
    'K5': [53, 34, 25, 19, 15, 13, 11, 10]
    'K4': [52, 33, 23, 18, 15, 12, 11, 9]
    'K3': [51, 32, 23, 18, 14, 12, 10, 9]
    'K2': [50, 31, 22, 17, 14, 12, 10, 9]
    'QJ': [58, 41, 33, 27, 23, 20, 17, 15]
    'QT': [57, 40, 31, 26, 22, 19, 16, 14]
    'Q9': [56, 38, 29, 23, 19, 16, 14, 12]
    'Q8': [54, 35, 26, 21, 17, 14, 12, 11]
    'Q7': [52, 33, 24, 19, 15, 13, 11, 9]
    'Q6': [51, 32, 23, 18, 14, 12, 10, 9]
    'Q5': [50, 31, 20, 17, 14, 12, 10, 9]
    'Q4': [49, 30, 21, 16, 13, 11, 9, 8]
    'Q3': [48, 29, 21, 16, 13, 11, 9, 8]
    'Q2': [47, 28, 20, 15, 12, 10, 9, 8]
    'JT': [55, 39, 31, 25, 22, 19, 16, 15]
    'J9': [53, 37, 28, 23, 19, 16, 14, 12]
    'J8': [52, 34, 26, 20, 17, 14, 12, 11]
    'J7': [50, 32, 24, 18, 15, 12, 11, 9]
    'J6': [48, 30, 21, 17, 13, 11, 9, 8]
    'J5': [47, 29, 21, 16, 13, 11, 9, 8]
    'J4': [46, 28, 20, 15, 12, 10, 9, 8]
    'J3': [45, 27, 19, 15, 12, 10, 8, 7]
    'J2': [44, 26, 18, 14, 11, 9, 8, 7]
    'T9': [52, 32, 28, 23, 19, 16, 14, 13]
    'T8': [50, 34, 25, 20, 17, 14, 13, 11]
    'T7': [48, 31, 23, 18, 15, 13, 11, 10]
    'T6': [46, 29, 21, 17, 13, 11, 10, 8]
    'T5': [44, 27, 19, 15, 12, 10, 8, 7]
    'T4': [43, 26, 19, 14, 12, 10, 8, 7]
    'T3': [42, 26, 18, 14, 11, 9, 8, 7]
    'T2': [42, 25, 17, 13, 11, 9, 8, 7]
    '98': [48, 33, 25, 20, 17, 14, 12, 11]
    '97': [47, 31, 23, 18, 16, 13, 11, 10]
    '96': [45, 29, 21, 17, 14, 11, 10, 9]
    '95': [43, 27, 19, 15, 12, 10, 9, 7]
    '94': [41, 25, 17, 13, 11, 9, 7, 6]
    '93': [40, 24, 17, 13, 10, 8, 7, 6]
    '92': [39, 23, 16, 12, 10, 8, 7, 6]
    '87': [46, 31, 23, 19, 15, 13, 12, 10]
    '86': [44, 29, 21, 17, 14, 12, 10, 9]
    '85': [42, 27, 19, 15, 12, 11, 9, 8]
    '84': [40, 24, 18, 13, 11, 9, 8, 7]
    '83': [38, 22, 16, 12, 10, 8, 7, 6]
    '82': [37, 22, 15, 11, 9, 8, 6, 6]
    '76': [43, 29, 22, 17, 14, 12, 11, 10]
    '75': [41, 27, 20, 16, 13, 11, 10, 9]
    '74': [38, 25, 18, 14, 11, 10, 9, 8]
    '73': [37, 22, 16, 12, 10, 8, 7, 6]
    '72': [35, 20, 14, 11, 9, 7, 6, 5]
    '65': [40, 27, 20, 16, 13, 12, 10, 9]
    '64': [38, 25, 18, 14, 12, 10, 9, 8]
    '63': [36, 23, 16, 13, 11, 9, 8, 7]
    '62': [34, 21, 15, 11, 9, 8, 7, 6]
    '54': [38, 25, 19, 15, 13, 11, 10, 9]
    '53': [36, 23, 17, 14, 11, 10, 9, 8]
    '52': [34, 21, 15, 12, 10, 9, 8, 7]
    '43': [34, 22, 16, 13, 11, 9, 8, 8]
    '42': [33, 21, 15, 12, 10, 8, 7, 7]
    '32': [31, 20, 14, 11, 9, 8, 7, 6]
  }

  tables.getChance = (cards, numberOfPlayers) ->
    return tables.chances[cards][numberOfPlayers - 2]

  tables.getHandWithValue = (value) ->
    closestHand = ''
    closestDifference = -1
    for key in Object.keys(tables.chances)
      keyValue = tables.chances[key][0]
      difference = Math.abs(keyValue - value)
      if(closestDifference == -1)
        closestDifference = difference
        closestHand = key
      else if(difference < closestDifference)
        closestDifference = difference
        closestHand = key
    return closestHand


  return tables
)

