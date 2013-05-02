class Momentous
  constructor: (placeholder, options) ->
    @placeholder = $ "#" + placeholder
    @options     = options
    @dateFormat  = @options.dateFormat or 'DD-MM-YYYY'
    @events      = $ this

    @placeholder.html dropdownTemplate

    @placeholder.addClass 'momentous-container'

    @input     = @placeholder.find '.momentous-input'
    @calButton = @placeholder.find '.momentous-cal-button'
    @dropdown  = @placeholder.find '.momentous-dropdown'

    @input.bind 'click', @toggle
    @calButton.bind 'click', @toggle
    @dropdown.find('.dir-button').bind 'click', @directionClickHandler

    @init()

  init: =>
    @curDate   = moment()
    @weekStart = 1 # Monday

    if @options.date then @curDate = moment(@options.date, @dateFormat)
    if @options.weekStart in [0,1] then @weekStart = @options.weekStart

    daysHeader = @dropdown.find '.dow-row'

    weekStart = moment().day(@weekStart)
    for dow in [0..6]
      curDay = moment(weekStart).add('days', dow)
      dayName = curDay.format('ddd').substring(0,2);
      daysHeader.append "<th class='dow'>#{dayName}</th>"

    @update()

  update: =>
    @input.attr 'value', @curDate.format @dateFormat

    @updateNav()
    @updateCal()

  updateNav: =>
    nav = @dropdown.find '.days-nav'

    nav.find('.cur-view').text @curDate.format('MMM YYYY')

  updateCal: =>
    month          = @curDate.month()
    monthStart     = moment(@curDate).date(0)
    monthWeekStart = monthStart.day(@weekStart)

    daysContainer = @dropdown.find('tbody')

    calHTML = ""
    [0..5].map (week) =>
      weekStart = moment(monthWeekStart).add('days', week * 7)
      daysHTML = ""
      [0..6].map (dow) =>
        curDay = moment weekStart.day(@weekStart + dow).format(@dateFormat), @dateFormat
        curDayDate = curDay.format @dateFormat
        classes = 'day'
        if curDay.month() < month then classes += ' lastMonth'
        if curDay.month() > month then classes += ' nextMonth'
        if curDay.format(@dateFormat) == @curDate.format(@dateFormat) then classes += ' active'
        daysHTML += "<td class='#{classes}' data-date='#{curDayDate}'>#{curDay.date()}</td>"
      weekHTML = "<tr>#{daysHTML}</tr>"

      calHTML += weekHTML

    daysContainer.html calHTML
    @dropdown.find('.day').bind 'click', @dayClickHandler

  dayClickHandler: (event) =>
    target = $ event.currentTarget
    @setDate target.data 'date'

    @hide()

  directionClickHandler: (event) =>
    target = $ event.currentTarget
    if target.hasClass 'prev'
      @setDate moment(@curDate).subtract('months', 1)
    if target.hasClass 'next'
      @setDate moment(@curDate).add('months', 1)

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

  moment: => moment @curDate

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
    <div class="days-group">
      <table class="table-condensed">
        <thead>
          <tr class="days-nav">
            <th class="dir-button prev"><i class="icon-chevron-left"></i></th>
            <th colspan="5" class="cur-view"></th>
            <th class="dir-button next"><i class="icon-chevron-right"></i></th>
          </tr>
          <tr class="dow-row"></tr>
        </thead>
        <tbody></tbody>
      </table>
    </div>
  </div>
"""







