<img src="http://thom801.github.io/momentous/images/logoexamples.jpg">

# Momentous
A datepicker for [bootstrap](http://twitter.github.io/bootstrap/) built with [Moment.js](http://momentjs.com/)

### Install via Bower
```bash
bower install momentous
```
If you have not done so already, also install Momentous dependencies: Jquery, Moment.js, and Bootstrap.
```bash
bower install jquery moment bootstrap
```
Include jquery.js, moment.js, bootstrap.js, and bootstrap.css tags into your HTML

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
  dateFormat: 'MM-DD-YYYY', // Any valid moment.js display format.
  date: '04-21-2013', // Must match date format
  weekStart: 1, // Sunday: 0, Monday: 1
  granularity: 'days' // 'days', 'weeks', 'months', or 'years' Defaults to days.
};

var momentous = Momentous( $('#placeholder'), options);
```

### Events
```javascript
momentous.events.on('dateChange', function(event) {
  console.log(momentous.curDate);
});
```
