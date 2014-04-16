app = angular.module 'utils', []

app.factory('utils', () ->
    utils = {}

    utils.toDateInput = (date) ->
      monthString = (date.getMonth() + 1).toString()
      if(monthString.length == 1)
        monthString = '0' + monthString
      dayString = date.getDate().toString()
      if(dayString.length == 1)
        dayString = '0' + dayString
      dateString = date.getFullYear() + '-' + monthString + '-' + dayString
      return dateString

    utils.toTime = (date) ->
      hoursString = date.getHours().toString()
      minutesString = date.getMinutes().toString()
      if(hoursString.length == 1)
        hoursString = '0' + hoursString
      if(minutesString.length == 1)
        minutesString = '0' + minutesString
      return hoursString + '.' + minutesString

    return utils
)

