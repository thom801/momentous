# Momentous
A datepicker for bootstrap built with Moment.js

### Initialization
```html
<div id="placeholder"></div>
```
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