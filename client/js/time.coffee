angular.module('clientApp').controller('TimeCtrl', ($rootScope, $scope, $http, $location, model, testdata, utils) ->

  getTimeslots = ->
    $http.get('/timeslots').success((data) ->
      $scope.message = data
      $scope.timeslots = []
      for item in data
        console.log item
        timeslot = new model.Timeslot()
        timeslot.id = item._id
        if(item.date)
          timeslot.date = utils.toDateInput(new Date(item.date))
        timeslot.project = testdata.colors[item.project - 1]
        timeslot.from = utils.toTime(new Date(item.from))
        timeslot.to = utils.toTime(new Date(item.to))
        console.log timeslot
        $scope.timeslots.push timeslot
    )

  getTimeslot = (id, callback) ->
    $http.get('/timeslots/' + id).success((data) ->
      console.log 'got timeslot with id ' + id + ', data: ' + data
      callback(data)
    )


  $scope.editTimeslot = (id) ->
    console.log 'in edit timeslot, id: ' + id
    getTimeslot(id, (timeslot) ->
      $rootScope.edittime = timeslot
      $location.path('addtime')
    )

  $scope.deleteTimeslot = (id) ->
    console.log 'deleting timeslot, id: ' + id
    $http.delete('/timeslots/' + id).success((data) ->
      console.log 'client deleted timeslot with id ' + id
      getTimeslots()
      $location.path('timeslots')
    )

  getTimeslots()

)

angular.module('clientApp').controller('AddTimeCtrl', ($rootScope, $scope, $http, $location, model, testdata, utils) ->
  console.log 'starting add time controller...'

  $scope.colors = testdata.colors
  $scope.addtime = {}

  if($rootScope.edittime)
      timeslot = $rootScope.edittime
      $scope.addtime.date = utils.toDateInput(new Date(timeslot.date))
      $scope.addtime.project = testdata.colors[timeslot.project - 1]
      $scope.addtime.from = utils.toTime(new Date(timeslot.from))
      $scope.addtime.to = utils.toTime(new Date(timeslot.to))
      $scope.addtime.isEdit = true
      $scope.addtime.id = timeslot._id
      $rootScope.edittime = null
  else
      $scope.addtime.project = testdata.colors[0]
      $scope.addtime.date = utils.toDateInput(new Date())
      $scope.addtime.from = '9.00'
      $scope.addtime.to = ''
      $scope.addtime.isEdit = false


  appendMinutes = (time) ->
    if(time.indexOf('.') == -1)
      time = time + '.00'
    return time

  $scope.addTime = () ->
    console.log 'in addTime()...'
    date = $scope.addtime.date
    project = $scope.addtime.project.id
    from = $scope.addtime.from
    to = $scope.addtime.to
    from = appendMinutes(from)
    to = appendMinutes(to)
    data = {}
    data.date = new Date(date)
    data.project = project
    console.log 'data.date: ' + data.date
    console.log 'data.project: ' + data.project
    fromHours = parseInt(from.split(".")[0])
    fromMinutes = parseInt(from.split(".")[1])
    toHours = parseInt(to.split(".")[0])
    toMinutes = parseInt(to.split(".")[1])
    fromDate = new Date(data.date.getTime())
    fromDate.setHours(fromHours)
    fromDate.setMinutes(fromMinutes)
    toDate = new Date(data.date.getTime())
    toDate.setHours(toHours)
    toDate.setMinutes(toMinutes)
    console.log 'fromDate: ' + fromDate
    console.log 'toDate: ' + toDate
    data.from = fromDate
    data.to = toDate
    console.log 'data.from: ' + data.from
    console.log 'data.to: ' + data.to
    data.year = fromDate.getFullYear()
    $http.post('/timeslots', data).success((postData) ->
      getTimeslots()
      $location.path('timeslots')
    )

)
