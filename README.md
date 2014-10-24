<img src="http://thom801.github.io/momentous/images/logoexamples.jpg">

# Momentous
A datepicker for [bootstrap](http://twitter.github.io/bootstrap/) built with [Moment.js](http://momentjs.com/)

### Install via Bower
```bash
bower install momentous
```
Then include jquery.js, moment.js, bootstrap.js, and bootstrap.css in your HTML.

### Basic Usage
Include `momentous.js` and `momentous.css` then create a placeholder.
```html
<div id="placeholder"></div>
```
Create a momentous instance by passing the id of your placeholder.
```javascript
var momentous = Momentous( $('#placeholder') );
```

### Initialize with options
```javascript
var options = {
  dateFormat: 'MM-DD-YYYY, h:mm a', // Any valid moment.js display format. Default is "MM-DD-YYYY"
  date: '04-21-2013, 12:00 pm', // Date you want to initially show. Must match dateFormat
  weekStart: 1, // Sunday: 0, Monday: 1
  granularity: 'days', // 'hours', 'days', 'weeks', 'months', or 'years' Defaults to days.
  timeFormat: 12, // Only applicable for hours or minutes granularity. Sets time format to AM/PM. Default is 24-hour format. Options: 12, 24
  minuteGranularity: 5 // Options: 1, 5, 10, 15, 20, 30
};

var momentous = Momentous( $('#placeholder'), options);
```

### Events
```javascript
momentous.events.on('dateChange', function(event) {
  console.log(momentous.curDate);
});
```

### Development
To install dev dependencies.
```bash
npm install
```

This will allow you to run `grunt` and it will watch for changes and do all the coffee and stylus compilation for you.
