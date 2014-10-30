// Generated by CoffeeScript 1.8.0
(function() {
  var DateRangeController, Momentous, dropdownTemplate, log,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Momentous = (function() {
    function Momentous(placeholder, options, controller) {
      this.jsDate = __bind(this.jsDate, this);
      this.getDate = __bind(this.getDate, this);
      this.date = __bind(this.date, this);
      this.toggle = __bind(this.toggle, this);
      this.hide = __bind(this.hide, this);
      this.show = __bind(this.show, this);
      this.setViewDate = __bind(this.setViewDate, this);
      this.setDate = __bind(this.setDate, this);
      this.directionClickHandler = __bind(this.directionClickHandler, this);
      this.viewClickHandler = __bind(this.viewClickHandler, this);
      this.yearClickHandler = __bind(this.yearClickHandler, this);
      this.monthClickHandler = __bind(this.monthClickHandler, this);
      this.weekClickHandler = __bind(this.weekClickHandler, this);
      this.dayClickHandler = __bind(this.dayClickHandler, this);
      this.hourClickHandler = __bind(this.hourClickHandler, this);
      this.minuteClickHandler = __bind(this.minuteClickHandler, this);
      this.showYears = __bind(this.showYears, this);
      this.showMonths = __bind(this.showMonths, this);
      this.showDays = __bind(this.showDays, this);
      this.showHours = __bind(this.showHours, this);
      this.showMinutes = __bind(this.showMinutes, this);
      this.update = __bind(this.update, this);
      this.init = __bind(this.init, this);
      this.placeholder = $(placeholder.html(dropdownTemplate));
      this.events = $(this);
      this.options = options;
      this.timeFormat = this.options.timeFormat;
      this.minuteGranularity = this.options.minuteGranularity || 15;
      this.dateFormat = this.options.dateFormat || 'MM-DD-YYYY';
      this.minutesView = this.placeholder.find('.minutes-view');
      this.hoursView = this.placeholder.find('.hours-view');
      this.hoursViewPeriod = this.placeholder.find('.hours-view-period');
      this.daysView = this.placeholder.find('.days-view');
      this.monthsView = this.placeholder.find('.months-view');
      this.yearsView = this.placeholder.find('.years-view');
      this.curView = this.placeholder.find('.days-view');
      this.input = this.placeholder.find('.momentous-input');
      this.calButton = this.placeholder.find('.momentous-cal-button');
      this.dropdown = this.placeholder.find('.momentous-dropdown');
      this.viewButton = this.dropdown.find('.view-button');
      this.dateRangeMode = options.dateRangeMode || false;
      if (this.dateRangeMode) {
        this.controller = controller;
      }
      this.placeholder.addClass('momentous-container');
      this.input.bind('click', this.toggle);
      this.calButton.bind('click', this.toggle);
      this.dropdown.find('.dir-button').bind('click', this.directionClickHandler);
      this.viewButton.bind('click', this.viewClickHandler);
    }

    Momentous.prototype.init = function() {
      var curDay, dayName, daysHeader, dow, weekStart, _i, _ref;
      this.curDate = moment(moment().format('MM-DD-YYYY, HH:mm'), 'MM-DD-YYYY, HH:mm');
      this.viewDate = moment(moment().format('MM-DD-YYYY, HH:mm'), 'MM-DD-YYYY, HH:mm');
      this.today = moment(moment().format('MM-DD-YYYY, HH:mm'), 'MM-DD-YYYY, HH:mm');
      this.weekStart = 1;
      this.granularity = 'days';
      if (this.options.date) {
        this.curDate = moment(this.options.date, this.dateFormat);
      }
      if ((_ref = this.options.weekStart) === 0 || _ref === 1) {
        this.weekStart = this.options.weekStart;
      }
      if (this.options.granularity) {
        this.granularity = this.options.granularity;
      }
      if (this.dateRangeMode && this === this.controller.start) {
        if (this.granularity === 'hours' || this.granularity === 'minutes') {
          this.curDate.minutes(0);
        }
      }
      if (this.dateRangeMode && this === this.controller.end) {
        if (this.granularity === 'days') {
          this.curDate.add(1, 'weeks');
        }
        if (this.granularity === 'hours' || this.granularity === 'minutes') {
          this.curDate.add(3, 'hours').minutes(0);
        }
      }
      this.curView.show();
      daysHeader = this.daysView.find('.dow-row');
      weekStart = moment().day(this.weekStart);
      for (dow = _i = 0; _i <= 6; dow = ++_i) {
        curDay = moment(weekStart).add(dow, 'days');
        dayName = curDay.format('ddd').substring(0, 2);
        daysHeader.append("<th class='dow'>" + dayName + "</th>");
      }
      if (this.granularity === 'minutes') {
        this.showDays();
      }
      if (this.granularity === 'hours') {
        this.showDays();
      }
      if (this.granularity === 'days') {
        this.showDays();
      }
      if (this.granularity === 'weeks') {
        this.setDate(moment(this.curDate).day(1));
        this.showDays();
        if (this.today.day() === 0 && this.weekStart === 1) {
          this.curDate.subtract(1, 'weeks');
        }
      }
      if (this.granularity === 'months') {
        this.setDate(moment(this.curDate).date(1));
        this.showMonths();
      }
      if (this.granularity === 'years') {
        this.showYears();
      }
      return this.update();
    };

    Momentous.prototype.update = function() {
      var nav, navFormat;
      this.input.attr('value', this.curDate.format(this.dateFormat));
      nav = this.dropdown.find('.momentous-nav');
      if (this.curView === this.minutesView) {
        navFormat = 'MMM YYYY, h:mm a';
        this.showMinutes();
      }
      if (this.curView === this.hoursViewPeriod) {
        navFormat = 'MMM YYYY, h:mm a';
        this.showHours();
      }
      if (this.curView === this.hoursView) {
        navFormat = 'MMM YYYY, HH:mm';
        this.showHours();
      }
      if (this.curView === this.daysView) {
        navFormat = 'MMM YYYY';
        this.showDays();
      }
      if (this.curView === this.monthsView) {
        navFormat = 'YYYY';
        this.showMonths();
      }
      if (this.curView === this.yearsView) {
        return this.showYears();
      }
    };

    Momentous.prototype.showMinutes = function() {
      var calendarDate, classes, curMinute, curMinuteDate, endDate, i, minute, minuteGran, minuteNum, minutesContainer, minutesHTML, selectedHour, startDate, _i;
      this.curView.hide();
      if (this.timeFormat === 12) {
        this.dateFormat = this.options.dateFormat || 'MM-DD-YYYY, h:mm a';
        this.viewButton.text(this.viewDate.format('MMM Do, h:00 a'));
      } else {
        this.dateFormat = this.options.dateFormat || 'MM-DD-YYYY, HH:mm';
        this.viewButton.text(this.viewDate.format('MMM Do, HH:00'));
      }
      this.minutesView.show();
      this.curView = this.minutesView;
      minutesContainer = this.minutesView.find('ul');
      minutesHTML = '';
      curMinute = moment(this.viewDate).minute(0);
      for (minute = _i = 0; _i <= 59; minute = ++_i) {
        if (this.timeFormat === 12) {
          selectedHour = moment(this.viewDate).format('h');
        } else {
          selectedHour = moment(this.viewDate).format('HH');
        }
        minutesContainer = this.minutesView.find('ul');
        minuteNum = curMinute.format(':mm');
        curMinuteDate = curMinute.format(this.dateFormat);
        classes = '';
        minuteGran = [1, 5, 10, 15, 20, 30];
        for (i in minuteGran) {
          if (minuteGran[i] === this.minuteGranularity) {
            if (minute % this.minuteGranularity === 0) {
              if (this.dateRangeMode) {
                startDate = this.controller.start.date().format('MM-DD-YYYY, HH:mm');
                endDate = this.controller.end.date().format('MM-DD-YYYY, HH:mm');
                calendarDate = moment(curMinute);
                calendarDate = calendarDate.format('MM-DD-YYYY, HH:mm');
                if (startDate === calendarDate) {
                  classes += ' startDate';
                }
                if (endDate === calendarDate && endDate > startDate) {
                  classes += ' endDate';
                }
                if (calendarDate > startDate && calendarDate < endDate) {
                  classes += ' inDateRange';
                }
                if (calendarDate < startDate) {
                  classes += ' disabled';
                }
              }
              if (minute === 0) {
                if (!this.dateRangeMode) {
                  classes += ' active';
                }
                minutesHTML += "<li class='" + classes + "' data-date='" + curMinuteDate + "'>" + selectedHour + minuteNum + "</li>";
              } else {
                minutesHTML += "<li class='" + classes + "' data-date='" + curMinuteDate + "'>" + selectedHour + minuteNum + "</li>";
              }
            }
          }
        }
        curMinute.add(1, 'minutes');
      }
      minutesContainer.html(minutesHTML);
      return minutesContainer.find('li').bind('click', this.minuteClickHandler);
    };

    Momentous.prototype.showHours = function() {
      var calendarDate, classes, curHour, curHourDate, endDate, hour, hourNum, hoursContainer, hoursHTML, startDate, trueHour, _i, _j;
      this.curView.hide();
      if (this.timeFormat === 12) {
        this.dateFormat = this.options.dateFormat || 'MM-DD-YYYY, h:mm a';
        this.hoursViewPeriod.show();
        this.curView = this.hoursViewPeriod;
        this.viewButton.text(this.viewDate.format('MMM Do'));
        hoursContainer = this.hoursViewPeriod.find('ul');
        hoursHTML = '';
        curHour = moment(this.viewDate).hour(0).minute(0);
        for (hour = _i = 0; _i <= 23; hour = ++_i) {
          hourNum = curHour.format('h a');
          trueHour = parseInt(this.today.format('H'));
          curHourDate = curHour.format(this.dateFormat);
          classes = '';
          if (this.dateRangeMode) {
            startDate = this.controller.start.date().format('MM-DD-YYYY, HH:00');
            endDate = this.controller.end.date().format('MM-DD-YYYY, HH:00');
            calendarDate = moment(curHour);
            calendarDate = calendarDate.format('MM-DD-YYYY, HH:00');
            if (startDate === calendarDate) {
              classes += ' startDate';
            }
            if (endDate === calendarDate && endDate > startDate) {
              classes += ' endDate';
            }
            if (calendarDate > startDate && calendarDate < endDate) {
              classes += ' inDateRange';
            }
            if (calendarDate < startDate) {
              classes += ' disabled';
            }
          }
          if (hour === trueHour) {
            if (!this.dateRangeMode) {
              classes += ' active';
            }
            hoursHTML += "<li class='" + classes + "' data-date='" + curHourDate + "'><span>" + hourNum + "</span></li>";
          } else {
            hoursHTML += "<li class='" + classes + "' data-date='" + curHourDate + "'><span>" + hourNum + "</span></li>";
          }
          curHour.add(1, 'hours');
        }
        hoursContainer.html(hoursHTML);
        return hoursContainer.find('li').bind('click', this.hourClickHandler);
      } else {
        this.dateFormat = this.options.dateFormat || 'MM-DD-YYYY, HH:00';
        this.hoursView.show();
        this.curView = this.hoursView;
        this.viewButton.text(this.viewDate.format('MMM Do'));
        hoursContainer = this.hoursView.find('ul');
        hoursHTML = '';
        curHour = moment(this.viewDate).hour(0).minute(0);
        for (hour = _j = 0; _j <= 23; hour = ++_j) {
          hourNum = curHour.format('HH');
          trueHour = parseInt(this.today.format('H'));
          curHourDate = curHour.format(this.dateFormat);
          classes = '';
          if (this.dateRangeMode) {
            startDate = this.controller.start.date().format('MM-DD-YYYY, HH:00');
            endDate = this.controller.end.date().format('MM-DD-YYYY, HH:00');
            calendarDate = moment(curHour);
            calendarDate = calendarDate.format('MM-DD-YYYY, HH:00');
            if (startDate === calendarDate) {
              classes += ' startDate';
            }
            if (endDate === calendarDate && endDate > startDate) {
              classes += ' endDate';
            }
            if (calendarDate > startDate && calendarDate < endDate) {
              classes += ' inDateRange';
            }
            if (calendarDate < startDate) {
              classes += ' disabled';
            }
          }
          if (hour === trueHour) {
            if (!this.dateRangeMode) {
              classes += ' active';
            }
            hoursHTML += "<li class='" + classes + "' data-date='" + curHourDate + "'>" + hourNum + ":00</li>";
          } else {
            hoursHTML += "<li class='" + classes + "' data-date='" + curHourDate + "'>" + hourNum + ":00</li>";
          }
          curHour.add(1, 'hours');
        }
        hoursContainer.html(hoursHTML);
        return hoursContainer.find('li').bind('click', this.hourClickHandler);
      }
    };

    Momentous.prototype.showDays = function() {
      var calHTML, daysContainer, month, monthStart, monthWeekStart;
      this.curView.hide();
      this.daysView.show();
      this.curView = this.daysView;
      this.viewButton.text(this.viewDate.format('MMM YYYY'));
      month = this.viewDate.month();
      monthStart = moment(this.viewDate).date(0);
      monthWeekStart = monthStart.day(this.weekStart);
      daysContainer = this.daysView.find('tbody');
      calHTML = "";
      [0, 1, 2, 3, 4, 5].map((function(_this) {
        return function(week) {
          var daysHTML, weekClasses, weekHTML, weekStart;
          weekStart = moment(monthWeekStart).add(week * 7, 'days');
          daysHTML = "";
          weekClasses = "";
          if (_this.granularity === 'weeks') {
            weekClasses = 'week';
          }
          [0, 1, 2, 3, 4, 5, 6].map(function(dow) {
            var calendarDate, classes, curDay, curDayDate, endDate, startDate;
            curDay = moment(weekStart.day(_this.weekStart + dow).format(_this.dateFormat), _this.dateFormat);
            curDayDate = curDay.format(_this.dateFormat);
            classes = 'day';
            if (curDay.month() < month) {
              classes += ' lastMonth';
            }
            if (curDay.month() > month) {
              classes += ' nextMonth';
            }
            if (curDay.format(_this.dateFormat) === _this.curDate.format(_this.dateFormat) && !_this.dateRangeMode) {
              classes += ' active';
              weekClasses += ' active';
            }
            if (_this.dateRangeMode) {
              startDate = _this.controller.start.date().format('MM-DD-YYYY');
              endDate = _this.controller.end.date().format('MM-DD-YYYY');
              calendarDate = moment(curDay);
              calendarDate = calendarDate.format('MM-DD-YYYY');
              if (startDate === calendarDate) {
                classes += ' startDate';
              }
              if (endDate === calendarDate && endDate > startDate) {
                classes += ' endDate';
              }
              if (calendarDate > startDate && calendarDate < endDate) {
                classes += ' inDateRange';
              }
              if (calendarDate < startDate) {
                classes += ' disabled';
              }
            }
            return daysHTML += "<td class='" + classes + "' data-date='" + curDayDate + "'>" + (curDay.date()) + "</td>";
          });
          weekHTML = "<tr class='" + weekClasses + "'>" + daysHTML + "</tr>";
          return calHTML += weekHTML;
        };
      })(this));
      daysContainer.html(calHTML);
      if (this.granularity === 'weeks') {
        return this.dropdown.find('.week').bind('click', this.weekClickHandler);
      } else {
        return this.dropdown.find('.day').bind('click', this.dayClickHandler);
      }
    };

    Momentous.prototype.showMonths = function() {
      var curMonth, month, monthName, monthNum, monthsContainer, monthsHTML, _i;
      this.curView.hide();
      this.monthsView.show();
      this.curView = this.monthsView;
      this.viewButton.text(this.viewDate.format('YYYY'));
      monthsContainer = this.monthsView.find('ul');
      monthsHTML = '';
      curMonth = moment(this.viewDate).dayOfYear(1);
      for (month = _i = 0; _i <= 11; month = ++_i) {
        monthName = curMonth.format('MMM');
        monthNum = curMonth.format('M');
        if (curMonth.month() === this.curDate.month() && curMonth.year() === this.curDate.year()) {
          monthsHTML += "<li class='active' data-date='" + monthNum + "'>" + monthName + "</li>";
        } else {
          monthsHTML += "<li class='' data-date='" + monthNum + "'>" + monthName + "</li>";
        }
        curMonth.add(1, 'months');
      }
      monthsContainer.html(monthsHTML);
      return monthsContainer.find('li').bind('click', this.monthClickHandler);
    };

    Momentous.prototype.showYears = function() {
      var curYear, viewRange, year, yearNum, yearsContainer, yearsHTML, _i;
      this.curView.hide();
      this.yearsView.show();
      this.curView = this.yearsView;
      viewRange = this.viewDate.year() + ' - ' + (this.viewDate.year() + 11);
      this.viewButton.text(viewRange);
      yearsContainer = this.yearsView.find('ul');
      yearsHTML = '';
      curYear = moment(this.viewDate);
      for (year = _i = 0; _i <= 11; year = ++_i) {
        yearNum = curYear.format('YYYY');
        if (curYear.year() === this.curDate.year()) {
          yearsHTML += "<li class='active' data-date='" + yearNum + "'>" + yearNum + "</li>";
        } else {
          yearsHTML += "<li class='' data-date='" + yearNum + "'>" + yearNum + "</li>";
        }
        curYear.add(1, 'years');
      }
      yearsContainer.html(yearsHTML);
      return yearsContainer.find('li').bind('click', this.yearClickHandler);
    };

    Momentous.prototype.minuteClickHandler = function(event) {
      var target;
      target = $(event.currentTarget);
      this.setDate(target.data('date'));
      return this.hide();
    };

    Momentous.prototype.hourClickHandler = function(event) {
      var newDate, target;
      target = $(event.currentTarget);
      newDate = target.data('date');
      if (this.granularity === 'hours') {
        this.setDate(moment(newDate, this.dateFormat));
        return this.hide();
      } else {
        if (this.dateRangeMode) {
          this.setViewDate(moment(newDate, this.dateFormat).minutes(0));
          return this.showMinutes();
        } else {
          this.setViewDate(moment(newDate, this.dateFormat));
          return this.showMinutes();
        }
      }
    };

    Momentous.prototype.dayClickHandler = function(event) {
      var newDate, target;
      target = $(event.currentTarget);
      newDate = target.data('date');
      if (this.granularity === 'days') {
        this.setDate(moment(newDate, this.dateFormat));
        return this.hide();
      } else {
        if (this.dateRangeMode) {
          this.setViewDate(moment(newDate, this.dateFormat).minutes(0));
          return this.showHours();
        } else {
          this.setViewDate(moment(newDate, this.dateFormat));
          return this.showHours();
        }
      }
    };

    Momentous.prototype.weekClickHandler = function(event) {
      var target;
      target = $(event.currentTarget);
      this.setDate(target.find('td:first').data('date'));
      return this.hide();
    };

    Momentous.prototype.monthClickHandler = function(event) {
      var monthNum, newDate, target;
      target = $(event.currentTarget);
      monthNum = target.data('date');
      newDate = moment(this.curDate).month(monthNum - 1).year(this.viewDate.year());
      if (this.granularity === 'months') {
        this.setDate(newDate.date(1));
        return this.hide();
      } else {
        this.setViewDate(newDate.day(1));
        return this.showDays();
      }
    };

    Momentous.prototype.yearClickHandler = function(event) {
      var newDate, target, yearNum;
      target = $(event.currentTarget);
      yearNum = target.data('date');
      newDate = moment(this.curDate).year(yearNum);
      if (this.granularity === 'years') {
        this.setDate(newDate.date(1));
        return this.hide();
      } else {
        this.setViewDate(newDate.day(1));
        return this.showMonths();
      }
    };

    Momentous.prototype.viewClickHandler = function(event) {
      if (this.curView === this.minutesView) {
        this.showHours();
        return this.update();
      } else if (this.curView === this.hoursViewPeriod) {
        this.showDays();
        return this.update();
      } else if (this.curView === this.hoursView) {
        this.showDays();
        return this.update();
      } else if (this.curView === this.daysView) {
        this.showMonths();
        return this.update();
      } else if (this.curView === this.monthsView) {
        this.showYears();
        return this.update();
      }
    };

    Momentous.prototype.directionClickHandler = function(event) {
      var amount, span, target;
      target = $(event.currentTarget);
      if (this.curView === this.minutesView) {
        span = 'hours';
        amount = 1;
      }
      if (this.curView === this.hoursViewPeriod) {
        span = 'days';
        amount = 1;
      }
      if (this.curView === this.hoursView) {
        span = 'days';
        amount = 1;
      }
      if (this.curView === this.daysView) {
        span = 'months';
        amount = 1;
      }
      if (this.curView === this.monthsView) {
        span = 'years';
        amount = 1;
      }
      if (this.curView === this.yearsView) {
        span = 'years';
        amount = 12;
      }
      if (target.hasClass('prev')) {
        if (this.dateRangeMode) {
          if (this.curView === this.daysView) {
            this.setViewDate(moment(this.viewDate).subtract(amount, span).date(1).minutes(0));
          } else if (this.curView === this.hoursView || this.curView === this.hoursViewPeriod) {
            this.setViewDate(moment(this.viewDate).subtract(amount, span).hour(0).minutes(0));
          } else if (this.curView === this.minutesView) {
            this.setViewDate(moment(this.viewDate).subtract(amount, span).minutes(0));
          } else {
            this.setViewDate(moment(this.viewDate).subtract(amount, span));
          }
        } else {
          this.setViewDate(moment(this.viewDate).subtract(amount, span));
        }
      }
      if (target.hasClass('next')) {
        if (this.dateRangeMode) {
          if (this.curView === this.daysView) {
            return this.setViewDate(moment(this.viewDate).add(amount, span).date(1).minutes(0));
          } else if (this.curView === this.hoursView || this.curView === this.hoursViewPeriod) {
            return this.setViewDate(moment(this.viewDate).add(amount, span).hour(0).minutes(0));
          } else if (this.curView === this.minutesView) {
            return this.setViewDate(moment(this.viewDate).add(amount, span).minutes(0));
          } else {
            return this.setViewDate(moment(this.viewDate).add(amount, span));
          }
        } else {
          return this.setViewDate(moment(this.viewDate).add(amount, span));
        }
      }
    };

    Momentous.prototype.setDate = function(date) {
      this.curDate = moment(date, this.dateFormat);
      this.update();
      return this.events.trigger('dateChange');
    };

    Momentous.prototype.setViewDate = function(date) {
      this.viewDate = moment(date);
      this.curDate = this.viewDate;
      return this.update();
    };

    Momentous.prototype.show = function() {
      this.events.trigger('showDropdown');
      this.visible = true;
      this.update();
      return this.dropdown.stop().css({
        display: 'block'
      }).animate({
        opacity: 1
      }, 200);
    };

    Momentous.prototype.hide = function() {
      this.events.trigger('hideDropdown');
      this.viewDate = this.curDate;
      this.visible = false;
      return this.dropdown.stop().css({
        display: 'none',
        opacity: 0
      });
    };

    Momentous.prototype.toggle = function() {
      if (this.visible) {
        return this.hide();
      } else {
        return this.show();
      }
    };

    Momentous.prototype.date = function() {
      return moment(this.curDate);
    };

    Momentous.prototype.getDate = function() {
      return moment(this.curDate);
    };

    Momentous.prototype.jsDate = function() {
      return this.curDate.toDate();
    };

    return Momentous;

  })();

  DateRangeController = (function() {
    function DateRangeController(placeholder, options) {
      this.endDateChangeHandler = __bind(this.endDateChangeHandler, this);
      this.startDateChangeHandler = __bind(this.startDateChangeHandler, this);
      this.endShowHandler = __bind(this.endShowHandler, this);
      this.startShowHandler = __bind(this.startShowHandler, this);
      var endDatePlaceholder, startDatePlaceholder;
      placeholder.html('<div class="momentous-start-date"></div><div class="momentous-end-date"></div>');
      startDatePlaceholder = $('.momentous-start-date');
      endDatePlaceholder = $('.momentous-end-date');
      this.start = new Momentous(startDatePlaceholder, options, this);
      this.end = new Momentous(endDatePlaceholder, options, this);
      this.start.init();
      this.end.init();
      this.start.events.bind('dateChange', this.startDateChangeHandler);
      this.end.events.bind('dateChange', this.endDateChangeHandler);
      this.start.events.bind('showDropdown', this.startShowHandler);
      this.end.events.bind('showDropdown', this.endShowHandler);
    }

    DateRangeController.prototype.startShowHandler = function(event) {
      return this.end.hide();
    };

    DateRangeController.prototype.endShowHandler = function(event) {
      return this.start.hide();
    };

    DateRangeController.prototype.startDateChangeHandler = function(event) {
      var diff, endDate, startDate;
      startDate = this.start.date();
      endDate = this.end.date();
      diff = this.granularity === 'days' ? endDate.diff(startDate, 'days') : endDate.diff(startDate, 'hours');
      if (diff <= 0) {
        if (this.granularity === 'days') {
          this.end.setDate(moment(startDate).add(1, 'weeks'));
        }
        if (this.granularity === 'hours') {
          this.end.setDate(moment(startDate).add(1, 'hours'));
        }
        if (this.granularity === 'minutes') {
          this.end.setDate(moment(startDate).add(1, 'minutes'));
        }
      }
      return this.end.show();
    };

    DateRangeController.prototype.endDateChangeHandler = function(event) {
      var diff, endDate, startDate;
      startDate = this.start.date();
      endDate = this.end.date();
      diff = this.granularity === 'days' ? endDate.diff(startDate, 'days') : endDate.diff(startDate, 'hours');
      if (diff <= 0) {
        if (this.granularity === 'days') {
          this.start.setDate(moment(endDate).subtract(1, 'weeks'));
        }
        if (this.granularity === 'hours') {
          this.start.setDate(moment(endDate).subtract(1, 'hours'));
        }
        if (this.granularity === 'minutes') {
          return this.start.setDate(moment(endDate).subtract(1, 'minutes'));
        }
      }
    };

    return DateRangeController;

  })();

  window.Momentous = function(placeholder, options) {
    var momentous;
    if (options == null) {
      options = {};
    }
    if (options.dateRangeMode === true) {
      momentous = new DateRangeController(placeholder, options);
    } else {
      momentous = new Momentous(placeholder, options);
      momentous.init();
    }
    return momentous;
  };

  dropdownTemplate = "<div class=\"input-append\">\n  <input class='momentous-input' type='text' value='' readonly>\n  <button class=\"btn momentous-cal-button\" type=\"button\"><i class=\"icon-calendar\"></i></button>\n</div>\n<div class='momentous-dropdown popover bottom'>\n  <div class=\"arrow\"></div>\n  <div class=\"momentous-nav\">\n    <span class=\"dir-button prev\"><i class=\"icon-chevron-left\"></i></span>\n    <span class=\"view-button\"></span>\n    <span class=\"dir-button next\"><i class=\"icon-chevron-right\"></i></span>\n  </div>\n  <div class=\"days-view\" style=\"display: none;\">\n    <table class=\"table-condensed\">\n      <thead>\n        <tr class=\"dow-row\"></tr>\n      </thead>\n      <tbody></tbody>\n    </table>\n  </div>\n  <div class=\"minutes-view\" style=\"display: none;\"><ul></ul></div>\n  <div class=\"hours-view-period\" style=\"display: none;\"><ul></ul></div>\n  <div class=\"hours-view\" style=\"display: none;\"><ul></ul></div>\n  <div class=\"months-view\" style=\"display: none;\"><ul></ul></div>\n  <div class=\"years-view\" style=\"display: none;\"><ul></ul></div>\n</div>";

  log = function(s) {
    return console.log(s);
  };

}).call(this);
