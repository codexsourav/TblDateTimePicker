# Date and Time Picker Widgets

This package provides two customizable widgets for date and time picking:

- `TblDatePicker`: A horizontal date picker that allows users to select a date within a specified range.
- `TblTimePicker`: A horizontal time picker that allows users to select a time slot from a list of time slots.

![screenshot](simulator_screenshot_5EBE9BAC-05CB-46E3-9254-3A3148967F74.png)

## Usage

### TblDatePicker

The `TblDatePicker` widget allows users to pick a date from a range.

#### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:your_package_name/tbl_date_picker.dart'; // Update with the correct package name

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Date Picker Example')),
        body: Center(
          child: TblDatePicker(
            startDate: DateTime.now().subtract(Duration(days: 30)),
            endDate: DateTime.now().add(Duration(days: 30)),
            selectDate: DateTime.now(),
            onTap: (selectedDate) {
              // Handle date selection
              print('Selected Date: $selectedDate');
            },
          ),
        ),
      ),
    );
  }
}
```

#### Customizing the Date Picker

```dart
TblDatePicker(
  startDate: DateTime.now().subtract(Duration(days: 30)),
  endDate: DateTime.now().add(Duration(days: 30)),
  selectDate: DateTime.now(),
  disableWeekDays: ['Sat', 'Sun'], // Disables weekends
  disabledDates: [
    DateTime.now().add(Duration(days: 5)), // Disable a specific date
  ],
  cardBuilder: (context, isSelected, isDisabled, year, week, date) {
    return Container(
      color: isSelected ? Colors.blue : Colors.white,
      child: Center(
        child: Text(date),
      ),
    );
  },
  onTap: (selectedDate) {
    print('Selected Date: $selectedDate');
  },
)
```

#### Preview

Here is a preview of how the `TblDatePicker` widget looks:

![TblDatePicker Preview](assets/tbl_date_picker_preview.png)

Ensure the image file `tbl_date_picker_preview.png` is placed in the `assets` directory of your project.

### TblTimePicker

The `TblTimePicker` widget allows users to pick a time slot from a list of time slots.

#### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:your_package_name/tbl_time_picker.dart'; // Update with the correct package name

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Time Picker Example')),
        body: Center(
          child: TblTimePicker(
            timeSlots: generate24HourTimeSlots(), // Generate 30-minute intervals
            selected: '12:00 PM',
            onTap: (index, selectedTime) {
              // Handle time slot selection
              print('Selected Time: $selectedTime');
            },
          ),
        ),
      ),
    );
  }
}
```

#### Customizing the Time Picker

```dart
TblTimePicker(
  timeSlots: generate24HourTimeSlots(),
  selected: '12:00 PM',
  disabledTimeSlots: ['03:00 PM', '04:00 PM'], // Disable specific time slots
  cardBuilder: (context, isSelected, isDisabled, time) {
    return Container(
      color: isSelected ? Colors.blue : Colors.white,
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            color: isSelected ? Colors.white : Colors.black,
          ),
          SizedBox(width: 10),
          Text(
            time,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  },
  onTap: (index, selectedTime) {
    print('Selected Time: $selectedTime');
  },
)
```

## Parameters

### TblDatePicker

- `startDate`: The start date of the date range.
- `endDate`: The end date of the date range.
- `selectDate`: The initially selected date (optional).
- `height`: The height of the date picker (optional).
- `padding`: The padding around the date picker (optional).
- `disableWeekDays`: List of day names to disable (optional).
- `disabledDates`: List of specific dates to disable (optional).
- `onTap`: Callback function when a date is tapped (optional).
- `cardBuilder`: Custom widget builder for each date card (optional).

### TblTimePicker

- `timeSlots`: List of time slots to display.
- `selected`: The currently selected time slot (optional).
- `height`: The height of the time picker (optional).
- `padding`: The padding around the time picker (optional).
- `disabledTimeSlots`: List of time slots to disable (optional).
- `cardBuilder`: Custom widget builder for each time slot card (optional).
- `onTap`: Callback function when a time slot is tapped (optional).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
