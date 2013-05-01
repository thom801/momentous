# Momentous
## A datepicker for bootstrap built with Moment.js

### Initialization
```html
<div id="placeholder"></div>
```
Javascript
```javascript
momentous = Momentous('placeholder');
```

### Initialize with options
```javascript
options = {
  date: '09-01-2013',
  dateFormat: 'MM-DD-YYYY'
  weekStart: 1 // Monday
};

momentous = Momentous('placeholder', options);
```

## Events
```javascript
momentous.events.on('dateChange', function(event) {
  console.log(momentous.curDate);
});
```