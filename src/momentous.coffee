class Momentous
  constructor: (placeholder, options) ->
    @placeholder = $ placeholder.html dropdownTemplate
    @events      = $ this
    @options     = options
    @dateFormat  = @options.dateFormat or 'MM-DD-YYYY'
    @daysView    = @placeholder.find '.days-view'
    @monthsView  = @placeholder.find '.months-view'
    @curView     = @placeholder.find '.days-view'
    @input       = @placeholder.find '.momentous-input'
    @calButton   = @placeholder.find '.momentous-cal-button'
    @dropdown    = @placeholder.find '.momentous-dropdown'
    @viewButton  = @dropdown.find '.view-button'

    @placeholder.addClass 'momentous-container'

    @input.bind 'click', @toggle
    @calButton.bind 'click', @toggle
    @dropdown.find('.dir-button').bind 'click', @directionClickHandler
    @viewButton.bind 'click', @viewClickHandler

    @init()

  init: =>
    # defaults
    @curDate   = moment()
    @weekStart = 1 # Monday
    @granularity = 'days'

    if @options.date then @curDate = moment(@options.date, @dateFormat)
    if @options.weekStart in [0,1] then @weekStart = @options.weekStart
    if @options.granularity then @granularity = @options.granularity
    #if @options.language then moment.lang @options.language

    @curView.show()

    # days of week header
    daysHeader = @daysView.find '.dow-row'
    weekStart = moment().day(@weekStart)
    for dow in [0..6]
      curDay = moment(weekStart).add('days', dow)
      dayName = curDay.format('ddd').substring(0,2)
      daysHeader.append "<th class='dow'>#{dayName}</th>"

    
    if @granularity == 'days' then @showDays()
    if @granularity == 'weeks'
      @setDate moment(@curDate).day(1)
      @showDays()
    if @granularity == 'months'
      @setDate moment(@curDate).date(1)
      @showMonths()

    @update()

  update: =>
    @input.attr 'value', @curDate.format @dateFormat
    nav = @dropdown.find '.momentous-nav'

    if @curView == @daysView
      navFormat = 'MMM YYYY'
      @showDays()
    if @curView == @monthsView
      navFormat = 'YYYY'
      @showMonths()

    nav.find('.view-button').text @curDate.format navFormat

  showDays: =>
    @curView.hide()
    @daysView.show()
    @curView = @daysView

    month          = @curDate.month()
    monthStart     = moment(@curDate).date(0)
    monthWeekStart = monthStart.day(@weekStart)

    daysContainer = @daysView.find('tbody')

    calHTML = ""
    [0..5].map (week) =>
      weekStart = moment(monthWeekStart).add('days', week * 7)
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
        daysHTML += "<td class='#{classes}' data-date='#{curDayDate}'>#{curDay.date()}</td>"

      weekHTML = "<tr class='#{weekClasses}'>#{daysHTML}</tr>"

      calHTML += weekHTML

    daysContainer.html calHTML

    if @granularity == 'days'
      @dropdown.find('.day').bind 'click', @dayClickHandler
    if @granularity == 'weeks'
      @dropdown.find('.week').bind 'click', @weekClickHandler

  showMonths: =>
    @curView.hide()
    @monthsView.show()
    @curView = @monthsView

    # months buttons
    monthsContainer = @monthsView.find 'ul'
    monthsHTML = ''
    curMonth = moment().dayOfYear(1)
    for month in [0..11]
      monthName = curMonth.format 'MMM'
      monthNum = curMonth.format 'M'
      if curMonth.month() == @curDate.month()
        monthsHTML += "<li class='month-button active' data-date='#{monthNum}'>#{monthName}</li>"
      else
        monthsHTML += "<li class='month-button' data-date='#{monthNum}'>#{monthName}</li>"
      
      curMonth.add 'months', 1

    monthsContainer.html monthsHTML

    monthsContainer.find('.month-button').bind 'click', @monthClickHandler

  dayClickHandler: (event) =>
    target = $ event.currentTarget
    @setDate target.data 'date'
    @hide()

  weekClickHandler: (event) =>
    target = $ event.currentTarget
    @setDate target.find('td:first').data 'date'
    @hide()

  monthClickHandler: (event) =>
    target = $ event.currentTarget
    monthNum = target.data 'date'
    newDate = moment(@curDate).month(monthNum - 1)

    if @granularity == 'months'
      @setDate newDate.date(1)
      @hide()
    else if @granularity == 'weeks'
      @setDate newDate.day(1)
      @showDays()
    else
      @showDays()

    @setDate newDate

  viewClickHandler: (event) =>
    if @curView == @daysView
      @showMonths()
      @update()

  directionClickHandler: (event) =>
    target = $ event.currentTarget

    if @curView == @daysView
      span = 'months'

    if @curView == @monthsView
      span = 'years'

    if target.hasClass 'prev'
      @setDate moment(@curDate).subtract(span, 1)
    if target.hasClass 'next'
      @setDate moment(@curDate).add(span, 1)

  setDate: (date) =>
    @curDate = moment(date, @dateFormat)
    @update()
    @events.trigger 'dateChange'

  show: =>
    @visible = true
    @dropdown.stop().css({display: 'block'}).animate({
      opacity: 1
    }, 200)

  hide: =>
    @visible = false
    @dropdown.stop().css({
      display: 'none'
      opacity: 0
    })

  toggle: =>
    if @visible then @hide() else @show()

  date: => moment @curDate

  jsDate: => @curDate.toDate()

window.Momentous = (placeholder, options={}) ->
  new Momentous placeholder, options

dropdownTemplate =  """
  <div class="input-append">
    <input class='momentous-input' type='text' value=''>
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
    <div class="months-view" style="display: none;">
      <ul></ul>
    </div>
  </div>
"""

log = (s) ->
  console.log s







