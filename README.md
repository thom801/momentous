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
  date: '04-21-2013, 12:00 pm', // Date you want to initially show. Must match dateFormat. Default is current date
  weekStart: 1, // Sunday: 0, Monday: 1
  granularity: 'days', // 'minutes', 'hours', 'days', 'weeks', 'months', or 'years' Defaults to days.
  timeFormat: 12, // Only applicable for hours or minutes granularity. 12 Sets time to AM/PM format. Default is 24-hour format. Options: 12, 24
  minuteGranularity: 5 // What size minute increments to show. Options: 1, 5, 10, 15, 20, 30. Default is 15.
  dateRangeMode: false // If set to true, two date pickers are shown to allow user to select a range. Ex: November 3rd through November 12th. Works with Days, Hours, and Minutes granularity.
};

var momentous = Momentous( $('#placeholder'), options);
```

### Events
The momentous instance will fire a `dateChange` event whenever the user selects a date
```javascript
momentous.events.on('dateChange', function(event) {
	curDate = momentous.getDate(); // Retrieve the current date (Moment instance)
});
```
And to do the same while in date range mode
```javascript
momentous.start.events.on('dateChange', function(event) { });
momentous.end.events.on('dateChange', function(event) { });
```

### Development
To install dev dependencies.
```bash
npm install
```

This will allow you to run `grunt` and it will watch for changes and do all the coffee and stylus compilation for you.
