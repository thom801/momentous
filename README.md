# Momentous
A datepicker for bootstrap built with Moment.js

### Basic Usage
Include `momentous.js` and `momentous.css` then create a placeholder.
```html
<div id="placeholder"></div>
```
Create a momentous instance by passing the id of your placeholder.
```javascript
momentous = Momentous('placeholder');
```

### Initialize with options
```javascript
options = {
  date: '09-01-2013',
  dateFormat: 'MM-DD-YYYY'
  weekStart: 1 // Sunday: 0, Monday: 1
};

momentous = Momentous('placeholder', options);
```

### Events
```javascript
momentous.events.on('dateChange', function(event) {
  console.log(momentous.curDate);
});
```
