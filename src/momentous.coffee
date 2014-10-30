class Momentous
  constructor: (placeholder, options, controller) ->
    @placeholder     = $ placeholder.html dropdownTemplate
    @events          = $ this
    @options         = options
    @timeFormat      = @options.timeFormat # 12 or 24
    @minuteGranularity      = @options.minuteGranularity or 15 # 1, 5, 10, 15, 20, 30
    @dateFormat      = @options.dateFormat or 'MM-DD-YYYY'
    @minutesView       = @placeholder.find '.minutes-view'
    @hoursView       = @placeholder.find '.hours-view'
    @hoursViewPeriod = @placeholder.find '.hours-view-period'
    @daysView        = @placeholder.find '.days-view'
    @monthsView      = @placeholder.find '.months-view'
    @yearsView       = @placeholder.find '.years-view'
    @curView         = @placeholder.find '.days-view'
    @input           = @placeholder.find '.momentous-input'
    @calButton       = @placeholder.find '.momentous-cal-button'
    @dropdown        = @placeholder.find '.momentous-dropdown'
    @viewButton      = @dropdown.find '.view-button'
    @dateRangeMode   = options.dateRangeMode or false

    if @dateRangeMode
      @controller = controller

    @placeholder.addClass 'momentous-container'

    @input.bind 'click', @toggle
    @calButton.bind 'click', @toggle
    @dropdown.find('.dir-button').bind 'click', @directionClickHandler
    @viewButton.bind 'click', @viewClickHandler

  init: =>
    # defaults
    @curDate     = moment(moment().format('MM-DD-YYYY, HH:mm'), 'MM-DD-YYYY, HH:mm')
    @viewDate    = moment(moment().format('MM-DD-YYYY, HH:mm'), 'MM-DD-YYYY, HH:mm')
    @today       = moment(moment().format('MM-DD-YYYY, HH:mm'), 'MM-DD-YYYY, HH:mm')
    @weekStart   = 1 # Monday
    @granularity = 'days' # minutes, hours, days, weeks, months, or years

    if @options.date then @curDate = moment(@options.date, @dateFormat)
    if @options.weekStart in [0,1] then @weekStart = @options.weekStart
    if @options.granularity then @granularity = @options.granularity
    #if @options.language then moment.lang @options.language

    if @dateRangeMode and this is @controller.start
      if @granularity == 'hours' || @granularity == 'minutes'
        @curDate.minutes(0)

    if @dateRangeMode and this is @controller.end
      if @granularity == 'days'
        @curDate.add(1, 'weeks')
      if @granularity == 'hours' || @granularity == 'minutes'
        @curDate.add(3, 'hours').minutes(0)

    @curView.show()

    # days of week header
    daysHeader = @daysView.find '.dow-row'
    weekStart = moment().day(@weekStart)
    for dow in [0..6]
      curDay = moment(weekStart).add(dow, 'days')
      dayName = curDay.format('ddd').substring(0,2)
      daysHeader.append "<th class='dow'>#{dayName}</th>"

    if @granularity == 'minutes' then @showDays()
    if @granularity == 'hours' then @showDays()
    if @granularity == 'days' then @showDays()
    if @granularity == 'weeks'
      @setDate moment(@curDate).day(1)
      @showDays()
      # If @today is sunday and weekstart is monday, make sure we init on the right week.
      if @today.day() is 0 and @weekStart is 1
        @curDate.subtract 1, 'weeks'

    if @granularity == 'months'
      @setDate moment(@curDate).date(1)
      @showMonths()

    if @granularity == 'years'
      @showYears()

    @update()

  update: =>
    @input.attr 'value', @curDate.format @dateFormat
    nav = @dropdown.find '.momentous-nav'
    #adding hours option in update -Ryan
    if @curView == @minutesView
      navFormat = 'MMM YYYY, h:mm a'
      @showMinutes()
    if @curView == @hoursViewPeriod
      navFormat = 'MMM YYYY, h:mm a'
      @showHours()
    if @curView == @hoursView
      navFormat = 'MMM YYYY, HH:mm'
      @showHours() 
    if @curView == @daysView
      navFormat = 'MMM YYYY'
      @showDays()
    if @curView == @monthsView
      navFormat = 'YYYY'
      @showMonths()
    if @curView == @yearsView
      @showYears()

#########################################################################

  showMinutes: =>
    @curView.hide()
    if @timeFormat == 12
      @dateFormat = @options.dateFormat or 'MM-DD-YYYY, h:mm a'
      @viewButton.text @viewDate.format 'MMM Do, h:00 a'
    else
      @dateFormat = @options.dateFormat or 'MM-DD-YYYY, HH:mm'
      @viewButton.text @viewDate.format 'MMM Do, HH:00'
    @minutesView.show()
    @curView = @minutesView

    # minutes buttons
    minutesContainer = @minutesView.find 'ul'
    minutesHTML = ''
    curMinute = moment(@viewDate).minute(0)

    for minute in [0..59]
      if @timeFormat == 12
        selectedHour = moment(@viewDate).format 'h'
      else
        selectedHour = moment(@viewDate).format 'HH'
      minutesContainer = @minutesView.find 'ul'
      minuteNum = curMinute.format ':mm'
      # trueMinute = parseInt @today.format 'mm'
      curMinuteDate = curMinute.format @dateFormat
      classes = ''
      disabled = false

      minuteGran = [1, 5, 10, 15, 20, 30]

      for i of minuteGran
        if minuteGran[i] == @minuteGranularity
          if minute % @minuteGranularity == 0

            if @dateRangeMode
              startDate = @controller.start.date().format('MM-DD-YYYY, HH:mm')
              endDate = @controller.end.date().format('MM-DD-YYYY, HH:mm')
              calendarDate = moment curMinute
              calendarDate = calendarDate.format 'MM-DD-YYYY, HH:mm'
              # Apply class to start date
              if startDate == calendarDate
                classes += ' startDate'
              # Apply class to end date
              if endDate == calendarDate && endDate > startDate
                classes += ' endDate'
              # Apply class to days within date range
              if calendarDate > startDate and calendarDate < endDate
                classes += ' inDateRange'
              if calendarDate < startDate && this is @controller.end || calendarDate < @today.format('MM-DD-YYYY, HH:00')
                classes += ' disabled'
                disabled = true

            if minute is 0
              if !@dateRangeMode
                classes += ' active'
              minutesHTML += "<li class='#{classes}' data-date='#{curMinuteDate}' data-isdisabled='#{disabled}'>#{selectedHour}#{minuteNum}</li>"
            else
              minutesHTML += "<li class='#{classes}' data-date='#{curMinuteDate}' data-isdisabled='#{disabled}'>#{selectedHour}#{minuteNum}</li>"

      curMinute.add 1, 'minutes'

    minutesContainer.html minutesHTML

    minutesContainer.find('li').bind 'click', @minuteClickHandler

#########################################################################

  showHours: =>
    @curView.hide()
    # 12 hour view with AM/PM
    if @timeFormat == 12
      @dateFormat = @options.dateFormat or 'MM-DD-YYYY, h:mm a'
      @hoursViewPeriod.show()
      @curView = @hoursViewPeriod

      @viewButton.text @viewDate.format 'MMM Do'

      # hours buttons
      hoursContainer = @hoursViewPeriod.find 'ul'
      hoursHTML = ''
      curHour = moment(@viewDate).hour(0).minute(0)

      for hour in [0..23]
        hourNum = curHour.format 'h a'
        trueHour = parseInt @today.format 'H'
        curHourDate = curHour.format @dateFormat
        classes = ''
        disabled = false

        if @dateRangeMode
          startDate = @controller.start.date().format('MM-DD-YYYY, HH:00')
          endDate = @controller.end.date().format('MM-DD-YYYY, HH:00')
          calendarDate = moment curHour
          calendarDate = calendarDate.format 'MM-DD-YYYY, HH:00'
          # Apply class to start date
          if startDate == calendarDate
            classes += ' startDate'
          # Apply class to end date
          if endDate == calendarDate && endDate > startDate
            classes += ' endDate'
          # Apply class to days within date range
          if calendarDate > startDate and calendarDate < endDate
            classes += ' inDateRange'
          if calendarDate < startDate && this is @controller.end || calendarDate < @today.format('MM-DD-YYYY, HH:00')
            classes += ' disabled'
            disabled = true

        if hour is trueHour
          if !@dateRangeMode
            classes += ' active'
          hoursHTML += "<li class='#{classes}' data-date='#{curHourDate}' data-isdisabled='#{disabled}'><span>#{hourNum}</span></li>"
        else
          hoursHTML += "<li class='#{classes}' data-date='#{curHourDate}' data-isdisabled='#{disabled}'><span>#{hourNum}</span></li>"

        curHour.add 1, 'hours'

      hoursContainer.html hoursHTML

      hoursContainer.find('li').bind 'click', @hourClickHandler

    # 24 hour view
    else 
      @dateFormat = @options.dateFormat or 'MM-DD-YYYY, HH:00'
      @hoursView.show()
      @curView = @hoursView

      @viewButton.text @viewDate.format 'MMM Do'

      # hours buttons
      hoursContainer = @hoursView.find 'ul'
      hoursHTML = ''
      curHour = moment(@viewDate).hour(0).minute(0)

      for hour in [0..23]
        hourNum = curHour.format 'HH'
        trueHour = parseInt @today.format 'H'
        curHourDate = curHour.format @dateFormat
        classes = ''
        disabled = false

        if @dateRangeMode
          startDate = @controller.start.date().format('MM-DD-YYYY, HH:00')
          endDate = @controller.end.date().format('MM-DD-YYYY, HH:00')
          calendarDate = moment curHour
          calendarDate = calendarDate.format 'MM-DD-YYYY, HH:00'
          # Apply class to start date
          if startDate == calendarDate
            classes += ' startDate'
          # Apply class to end date
          if endDate == calendarDate && endDate > startDate
            classes += ' endDate'
          # Apply class to days within date range
          if calendarDate > startDate and calendarDate < endDate
            classes += ' inDateRange'
          if calendarDate < startDate && this is @controller.end || calendarDate < @today.format('MM-DD-YYYY, HH:00')
            classes += ' disabled'
            disabled = true

        if hour is trueHour
          if !@dateRangeMode
            classes += ' active'
          hoursHTML += "<li class='#{classes}' data-date='#{curHourDate}' data-isdisabled='#{disabled}'>#{hourNum}:00</li>"
        else
          hoursHTML += "<li class='#{classes}' data-date='#{curHourDate}' data-isdisabled='#{disabled}'>#{hourNum}:00</li>"

        curHour.add 1, 'hours'

      hoursContainer.html hoursHTML

      hoursContainer.find('li').bind 'click', @hourClickHandler

  showDays: =>
    @curView.hide()
    @daysView.show()
    @curView = @daysView

    @viewButton.text @viewDate.format 'MMM YYYY'

    month          = @viewDate.month()
    monthStart     = moment(@viewDate).date(0)
    monthWeekStart = monthStart.day(@weekStart)

    daysContainer = @daysView.find('tbody')

    calHTML = ""
    [0..5].map (week) =>
      weekStart = moment(monthWeekStart).add(week * 7, 'days')
      daysHTML = ""
      weekClasses = ""
      if @granularity == 'weeks'
        weekClasses = 'week'
      [0..6].map (dow) =>
        curDay = moment weekStart.day(@weekStart + dow).format(@dateFormat), @dateFormat
        curDayDate = curDay.format @dateFormat
        classes = 'day'
        if curDay.month() < month then classes += ' lastMonth'
        if curDay.month() > month then classes += ' nextMonth'
        if curDay.format(@dateFormat) == @curDate.format(@dateFormat) && !@dateRangeMode
          classes += ' active'
          weekClasses += ' active'

        if @dateRangeMode
          startDate = @controller.start.date().format('MM-DD-YYYY')
          endDate = @controller.end.date().format('MM-DD-YYYY')
          calendarDate = moment curDay
          calendarDate = calendarDate.format 'MM-DD-YYYY'
          # Apply class to start date
          if startDate == calendarDate
            classes += ' startDate'
          # Apply class to end date
          if endDate == calendarDate && endDate > startDate
            classes += ' endDate'
          # # Apply class to days within date range
          if calendarDate > startDate and calendarDate < endDate
            classes += ' inDateRange'
          if calendarDate < startDate && this is @controller.end || calendarDate < @today.format('MM-DD-YYYY')
            classes += ' disabled'
            disabled = true

        daysHTML += "<td class='#{classes}' data-date='#{curDayDate}' data-isdisabled='#{disabled}'>#{curDay.date()}</td>"

      weekHTML = "<tr class='#{weekClasses}'>#{daysHTML}</tr>"

      calHTML += weekHTML

    daysContainer.html calHTML

    if @granularity == 'weeks'
      @dropdown.find('.week').bind 'click', @weekClickHandler
    else 
      @dropdown.find('.day').bind 'click', @dayClickHandler

  showMonths: =>
    @curView.hide()
    @monthsView.show()
    @curView = @monthsView

    @viewButton.text @viewDate.format 'YYYY'

    # months buttons
    monthsContainer = @monthsView.find 'ul'
    monthsHTML = ''
    curMonth = moment(@viewDate).dayOfYear(1)
    for month in [0..11]
      monthName = curMonth.format 'MMM'
      monthNum = curMonth.format 'M'
      if curMonth.month() == @curDate.month() and curMonth.year() == @curDate.year()
        monthsHTML += "<li class='active' data-date='#{monthNum}'>#{monthName}</li>"
      else
        monthsHTML += "<li class='' data-date='#{monthNum}'>#{monthName}</li>"

      curMonth.add 1, 'months'

    monthsContainer.html monthsHTML

    monthsContainer.find('li').bind 'click', @monthClickHandler

  showYears: =>
    @curView.hide()
    @yearsView.show()
    @curView = @yearsView

    viewRange = @viewDate.year() + ' - ' + (@viewDate.year() + 11)

    @viewButton.text viewRange

    # years buttons
    yearsContainer = @yearsView.find 'ul'
    yearsHTML = ''
    curYear = moment(@viewDate)

    for year in [0..11]
      yearNum = curYear.format 'YYYY'
      if curYear.year() == @curDate.year()
        yearsHTML += "<li class='active' data-date='#{yearNum}'>#{yearNum}</li>"
      else
        yearsHTML += "<li class='' data-date='#{yearNum}'>#{yearNum}</li>"

      curYear.add 1, 'years'

    yearsContainer.html yearsHTML

    yearsContainer.find('li').bind 'click', @yearClickHandler

  minuteClickHandler: (event) =>
    target = $ event.currentTarget
    newDate = target.data 'date'
    isDisabled = target.data 'isdisabled'
    if isDisabled == true
      console.log("This date is not selectable")
    else
      @setDate target.data 'date'
      @hide()

  hourClickHandler: (event) =>
    target = $ event.currentTarget
    newDate = target.data 'date'
    newDate = target.data 'date'
    isDisabled = target.data 'isdisabled'
    if @granularity == 'hours'
      @setDate moment(newDate, @dateFormat)
      @hide()
    else
      if @dateRangeMode
        if isDisabled == true
          console.log("This date is not selectable")
        else
          @setViewDate moment(newDate, @dateFormat).minutes(0)
          @showMinutes()
      else
        @setViewDate moment(newDate, @dateFormat)
        @showMinutes()

  dayClickHandler: (event) =>
    target = $ event.currentTarget
    newDate = target.data 'date'
    isDisabled = target.data 'isdisabled'
    if @granularity == 'days'
      @setDate moment(newDate, @dateFormat)
      @hide()
    else
      if @dateRangeMode
        if isDisabled == true
          console.log("This date is not selectable")
        else
          @setViewDate moment(newDate, @dateFormat).minutes(0)
          @showHours()
      else
        @setViewDate moment(newDate, @dateFormat)
        @showHours()

  weekClickHandler: (event) =>
    target = $ event.currentTarget
    @setDate target.find('td:first').data 'date'
    @hide()

  monthClickHandler: (event) =>
    target = $ event.currentTarget
    monthNum = target.data 'date'
    newDate = moment(@curDate).month(monthNum - 1).year(@viewDate.year())

    if @granularity == 'months'
      @setDate newDate.date(1)
      @hide()
    else
      @setViewDate newDate.day(1)
      @showDays()

  yearClickHandler: (event) =>
    target = $ event.currentTarget
    yearNum = target.data 'date'
    newDate = moment(@curDate).year(yearNum)

    if @granularity == 'years'
      @setDate newDate.date(1)
      @hide()
    else
      @setViewDate newDate.day(1)
      @showMonths()

  viewClickHandler: (event) =>
    if @curView == @minutesView
      @showHours()
      @update()
    else if @curView == @hoursViewPeriod
      @showDays()
      @update()
    else if @curView == @hoursView
      @showDays()
      @update()
    else if @curView == @daysView
      @showMonths()
      @update()
    else if @curView == @monthsView
      @showYears()
      @update()

  directionClickHandler: (event) =>
    target = $ event.currentTarget

    if @curView == @minutesView
      span = 'hours'
      amount = 1

    if @curView == @hoursViewPeriod
      span = 'days'
      amount = 1

    if @curView == @hoursView
      span = 'days'
      amount = 1

    if @curView == @daysView
      span = 'months'
      amount = 1

    if @curView == @monthsView
      span = 'years'
      amount = 1

    if @curView == @yearsView
      span = 'years'
      amount = 12

    if target.hasClass 'prev'
      @setViewDate moment(@viewDate).subtract(amount, span)

    if target.hasClass 'next'
      @setViewDate moment(@viewDate).add(amount, span)

  setDate: (date) =>
    @curDate = moment date, @dateFormat
    @update()
    @events.trigger 'dateChange'

  setViewDate: (date) =>
    @viewDate = moment date
    @curDate = @viewDate
    @update()

  show: =>
    @events.trigger 'showDropdown'
    @visible = true
    @update()
    @dropdown.stop().css({display: 'block'}).animate({
      opacity: 1
    }, 200)

  hide: =>
    @events.trigger 'hideDropdown'
    @viewDate = @curDate
    @visible = false
    @dropdown.stop().css({
      display: 'none'
      opacity: 0
    })

  toggle: =>
    if @visible then @hide() else @show()

  date: => moment @curDate

  getDate: => moment @curDate

  jsDate: => @curDate.toDate()

class DateRangeController
  constructor: (placeholder, options) ->
    placeholder.html '<div class="momentous-start-date"></div><div class="momentous-end-date"></div>'
    startDatePlaceholder = $ '.momentous-start-date'
    endDatePlaceholder   = $ '.momentous-end-date'

    @start = new Momentous startDatePlaceholder, options, this
    @end = new Momentous endDatePlaceholder, options, this

    @start.init()
    @end.init()

    @start.events.bind 'dateChange', @startDateChangeHandler
    @end.events.bind 'dateChange', @endDateChangeHandler
    @start.events.bind 'showDropdown', @startShowHandler
    @end.events.bind 'showDropdown', @endShowHandler

  startShowHandler: (event) =>
    @end.hide()

  endShowHandler: (event) =>
    @start.hide()

  startDateChangeHandler: (event) =>
    startDate = @start.date()
    endDate   = @end.date()
    diff      = if @granularity == 'days' then endDate.diff startDate, 'days' else endDate.diff startDate, 'hours'

    if diff <= 0
      if @granularity == 'days'
        @end.setDate moment(startDate).add(1, 'weeks')
      if @granularity == 'hours'
        @end.setDate moment(startDate).add(1, 'hours')
      if @granularity == 'minutes'
        @end.setDate moment(startDate).add(1, 'minutes')

    @end.show()

  endDateChangeHandler: (event) =>
    startDate = @start.date()
    endDate   = @end.date()
    diff      = if @granularity == 'days' then endDate.diff startDate, 'days' else endDate.diff startDate, 'hours'

    if diff <= 0
      if @granularity == 'days'
        @start.setDate moment(endDate).subtract(1, 'weeks')
      if @granularity == 'hours'
        @start.setDate moment(endDate).subtract(1, 'hours')
      if @granularity == 'minutes'
        @start.setDate moment(endDate).subtract(1, 'minutes')

window.Momentous = (placeholder, options={}) ->
  if options.dateRangeMode is true
    momentous = new DateRangeController placeholder, options
  else
    momentous = new Momentous placeholder, options
    momentous.init()
  return momentous

dropdownTemplate =  """
  <div class="input-append">
    <input class='momentous-input' type='text' value='' readonly>
    <button class="btn momentous-cal-button" type="button"><i class="icon-calendar"></i></button>
  </div>
  <div class='momentous-dropdown popover bottom'>
    <div class="arrow"></div>
    <div class="momentous-nav">
      <span class="dir-button prev"><i class="icon-chevron-left"></i></span>
      <span class="view-button"></span>
      <span class="dir-button next"><i class="icon-chevron-right"></i></span>
    </div>
    <div class="days-view" style="display: none;">
      <table class="table-condensed">
        <thead>
          <tr class="dow-row"></tr>
        </thead>
        <tbody></tbody>
      </table>
    </div>
    <div class="minutes-view" style="display: none;"><ul></ul></div>
    <div class="hours-view-period" style="display: none;"><ul></ul></div>
    <div class="hours-view" style="display: none;"><ul></ul></div>
    <div class="months-view" style="display: none;"><ul></ul></div>
    <div class="years-view" style="display: none;"><ul></ul></div>
  </div>
"""

log = (s) ->
  console.log s
