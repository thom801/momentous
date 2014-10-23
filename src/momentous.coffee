class Momentous
  constructor: (placeholder, options, controller) ->
    @placeholder   = $ placeholder.html dropdownTemplate
    @events        = $ this
    @options       = options
    # will probably have to add h:mm:ss a --Ryan
    @dateFormat    = @options.dateFormat or 'MM-DD-YYYY, HH:00'
    # adding hoursView --Ryan
    @hoursView     = @placeholder.find '.hours-view'
    @daysView      = @placeholder.find '.days-view'
    @monthsView    = @placeholder.find '.months-view'
    @yearsView     = @placeholder.find '.years-view'
    @curView       = @placeholder.find '.days-view'
    @input         = @placeholder.find '.momentous-input'
    @calButton     = @placeholder.find '.momentous-cal-button'
    @dropdown      = @placeholder.find '.momentous-dropdown'
    @viewButton    = @dropdown.find '.view-button'
    @dateRangeMode = options.dateRangeMode or false

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
    @granularity = 'days' # hours, days, weeks, months, or years

    if @dateRangeMode and this is @controller.end
      @curDate.add(1, 'weeks')

    if @options.date then @curDate = moment(@options.date, @dateFormat)
    if @options.weekStart in [0,1] then @weekStart = @options.weekStart
    if @options.granularity then @granularity = @options.granularity
    #if @options.language then moment.lang @options.language

    @curView.show()

    # days of week header
    daysHeader = @daysView.find '.dow-row'
    weekStart = moment().day(@weekStart)
    for dow in [0..6]
      curDay = moment(weekStart).add(dow, 'days')
      dayName = curDay.format('ddd').substring(0,2)
      daysHeader.append "<th class='dow'>#{dayName}</th>"
    # Adding granularity for hours --Ryan
    if @granularity == 'hours' then @showHours()
    if @granularity == 'days'
      # - added setDate to days to support hours functionality -Ryan
      @setDate moment(@curDate).hour(1)
      @showDays()
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
    if @curView == @hoursView
      navFormat = 'MMM YYYY, h:mm a'
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

# creating showHours function --Ryan
  showHours: =>
    @curView.hide()
    @hoursView.show()
    @curView = @hoursView

    @viewButton.text @viewDate.format 'MMM Do'

    # hours buttons
    hoursContainer = @hoursView.find 'ul'
    hoursHTML = ''
    curHour = moment(@viewDate).hour(0).minute(0)

    for hour in [0..23]
      hourNum = curHour.format 'H'
      trueHour = curHour.format 'HH'
      curHourDate = curHour.format @dateFormat

      if hour is hourNum
        hoursHTML += "<li class='active' data-date='#{curHourDate}'>#{trueHour}:00</li>"
      else
        hoursHTML += "<li class='' data-date='#{curHourDate}'>#{trueHour}:00</li>"

      curHour.add 1, 'hours'

    hoursContainer.html hoursHTML

    hoursContainer.find('li').bind 'click', @hourClickHandler


#########################################################################

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
        if curDay.format(@dateFormat) == @curDate.format(@dateFormat)
          classes += ' active'
          weekClasses += ' active'

        if @dateRangeMode
          startDate = @controller.start.date()
          endDate = @controller.end.date()
          daysFromStart = startDate.diff curDay, 'days'
          daysFromEnd = endDate.diff curDay, 'days'
          # Apply class to start date
          if daysFromStart is 0
            classes += ' startDate'
          # Apply class to end date
          if daysFromEnd is 0
            classes += ' endDate'
          # Apply class to days within date range
          if daysFromStart < 0 and daysFromEnd > 0
            classes += ' inDateRange'

        daysHTML += "<td class='#{classes}' data-date='#{curDayDate}'>#{curDay.date()}</td>"

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
    console.log curMonth
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
  #adding click handler for Hours -Ryan
  hourClickHandler: (event) =>
    target = $ event.currentTarget
    @setDate target.data 'date'
    @hide()

  dayClickHandler: (event) =>
    target = $ event.currentTarget
    newDate = target.data 'date'
    # adding functionality to dayClickHandler to support hours granularity -Ryan
    if @granularity == 'days'
      @setDate moment(newDate, @dateFormat)
      @hide()
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
    # adding hours viewClickHandler -Ryan
    if @curView == @hoursView
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
    # direction arrows change day when in hours view. - Ryan
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
    diff      = endDate.diff startDate, 'days'

    if diff <= 0
      @end.setDate moment(startDate).add(1, 'weeks')

    @end.show()

  endDateChangeHandler: (event) =>
    startDate = @start.date()
    endDate   = @end.date()
    diff      = endDate.diff startDate, 'days'

    if diff <= 0
      @start.setDate moment(endDate).subtract(1, 'weeks')

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
    <div class="hours-view" style="display: none;"><ul></ul></div>
    <div class="months-view" style="display: none;"><ul></ul></div>
    <div class="years-view" style="display: none;"><ul></ul></div>
  </div>
"""

log = (s) ->
  console.log s
