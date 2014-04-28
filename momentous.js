(function() {
  var DateRangeController, Momentous, dropdownTemplate, log,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Momentous = (function() {
    function Momentous(placeholder, options, controller) {
      this.jsDate = __bind(this.jsDate, this);
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
      this.showYears = __bind(this.showYears, this);
      this.showMonths = __bind(this.showMonths, this);
      this.showDays = __bind(this.showDays, this);
      this.update = __bind(this.update, this);
      this.init = __bind(this.init, this);
      this.placeholder = $(placeholder.html(dropdownTemplate));
      this.events = $(this);
      this.options = options;
      this.dateFormat = this.options.dateFormat || 'MM-DD-YYYY';
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
      this.curDate = moment(moment().format('MM-DD-YYYY'), 'MM-DD-YYYY');
      this.viewDate = moment(moment().format('MM-DD-YYYY'), 'MM-DD-YYYY');
      this.today = moment(moment().format('MM-DD-YYYY'), 'MM-DD-YYYY');
      this.weekStart = 1;
      this.granularity = 'days';
      if (this.dateRangeMode && this === this.controller.end) {
        this.curDate.add('weeks', 1);
      }
      if (this.options.date) {
        this.curDate = moment(this.options.date, this.dateFormat);
      }
      if ((_ref = this.options.weekStart) === 0 || _ref === 1) {
        this.weekStart = this.options.weekStart;
      }
      if (this.options.granularity) {
        this.granularity = this.options.granularity;
      }
      this.curView.show();
      daysHeader = this.daysView.find('.dow-row');
      weekStart = moment().day(this.weekStart);
      for (dow = _i = 0; _i <= 6; dow = ++_i) {
        curDay = moment(weekStart).add('days', dow);
        dayName = curDay.format('ddd').substring(0, 2);
        daysHeader.append("<th class='dow'>" + dayName + "</th>");
      }
      if (this.granularity === 'days') {
        this.showDays();
      }
      if (this.granularity === 'weeks') {
        this.setDate(moment(this.curDate).day(1));
        this.showDays();
        if (this.today.day() === 0 && this.weekStart === 1) {
          this.curDate.subtract('weeks', 1);
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
          weekStart = moment(monthWeekStart).add('days', week * 7);
          daysHTML = "";
          weekClasses = "";
          if (_this.granularity === 'weeks') {
            weekClasses = 'week';
          }
          [0, 1, 2, 3, 4, 5, 6].map(function(dow) {
            var classes, curDay, curDayDate, daysFromEnd, daysFromStart, endDate, startDate;
            curDay = moment(weekStart.day(_this.weekStart + dow).format(_this.dateFormat), _this.dateFormat);
            curDayDate = curDay.format(_this.dateFormat);
            classes = 'day';
            if (curDay.month() < month) {
              classes += ' lastMonth';
            }
            if (curDay.month() > month) {
              classes += ' nextMonth';
            }
            if (curDay.format(_this.dateFormat) === _this.curDate.format(_this.dateFormat)) {
              classes += ' active';
              weekClasses += ' active';
            }
            if (_this.dateRangeMode) {
              startDate = _this.controller.start.date();
              endDate = _this.controller.end.date();
              daysFromStart = startDate.diff(curDay, 'days');
              daysFromEnd = endDate.diff(curDay, 'days');
              if (daysFromStart === 0) {
                classes += ' startDate';
              }
              if (daysFromEnd === 0) {
                classes += ' endDate';
              }
              if (daysFromStart < 0 && daysFromEnd > 0) {
                classes += ' inDateRange';
              }
            }
            return daysHTML += "<td class='" + classes + "' data-date='" + curDayDate + "'>" + (curDay.date()) + "</td>";
          });
          weekHTML = "<tr class='" + weekClasses + "'>" + daysHTML + "</tr>";
          return calHTML += weekHTML;
        };
      })(this));
      daysContainer.html(calHTML);
      if (this.granularity === 'days') {
        this.dropdown.find('.day').bind('click', this.dayClickHandler);
      }
      if (this.granularity === 'weeks') {
        return this.dropdown.find('.week').bind('click', this.weekClickHandler);
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
        curMonth.add('months', 1);
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
        curYear.add('years', 1);
      }
      yearsContainer.html(yearsHTML);
      return yearsContainer.find('li').bind('click', this.yearClickHandler);
    };

    Momentous.prototype.dayClickHandler = function(event) {
      var target;
      target = $(event.currentTarget);
      this.setDate(target.data('date'));
      return this.hide();
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
      if (this.curView === this.daysView) {
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
        this.setViewDate(moment(this.viewDate).subtract(span, amount));
      }
      if (target.hasClass('next')) {
        return this.setViewDate(moment(this.viewDate).add(span, amount));
      }
    };

    Momentous.prototype.setDate = function(date) {
      this.curDate = moment(date, this.dateFormat);
      this.update();
      return this.events.trigger('dateChange');
    };

    Momentous.prototype.setViewDate = function(date) {
      this.viewDate = moment(date);
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
      diff = endDate.diff(startDate, 'days');
      if (diff <= 0) {
        this.end.setDate(moment(startDate).add('weeks', 1));
      }
      return this.end.show();
    };

    DateRangeController.prototype.endDateChangeHandler = function(event) {
      var diff, endDate, startDate;
      startDate = this.start.date();
      endDate = this.end.date();
      diff = endDate.diff(startDate, 'days');
      if (diff <= 0) {
        return this.start.setDate(moment(endDate).subtract('weeks', 1));
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

  dropdownTemplate = "<div class=\"input-append\">\n  <input class='momentous-input' type='text' value='' readonly>\n  <button class=\"btn momentous-cal-button\" type=\"button\"><i class=\"icon-calendar\"></i></button>\n</div>\n<div class='momentous-dropdown popover bottom'>\n  <div class=\"arrow\"></div>\n  <div class=\"momentous-nav\">\n    <span class=\"dir-button prev\"><i class=\"icon-chevron-left\"></i></span>\n    <span class=\"view-button\"></span>\n    <span class=\"dir-button next\"><i class=\"icon-chevron-right\"></i></span>\n  </div>\n  <div class=\"days-view\" style=\"display: none;\">\n    <table class=\"table-condensed\">\n      <thead>\n        <tr class=\"dow-row\"></tr>\n      </thead>\n      <tbody></tbody>\n    </table>\n  </div>\n  <div class=\"months-view\" style=\"display: none;\"><ul></ul></div>\n  <div class=\"years-view\" style=\"display: none;\"><ul></ul></div>\n</div>";

  log = function(s) {
    return console.log(s);
  };

}).call(this);
