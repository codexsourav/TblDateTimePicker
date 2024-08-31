import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A widget that provides a horizontal date picker for selecting a date
/// from a range of dates.
///
/// [startDate] is the starting date for the picker.
/// [endDate] is the ending date for the picker.
/// [selectDate] is the initially selected date (optional).
/// [height] specifies the height of the picker (optional).
/// [padding] specifies the padding around the picker (optional).
/// [disableWeekDays] is a list of day names to disable (optional).
/// [disabledDates] is a list of specific dates to disable (optional).
/// [onTap] is a callback function triggered when a date is tapped (optional).
/// [cardBuilder] is a custom widget builder for each date card (optional).
class TblDatePicker extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? selectDate;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final List<String>? disableWeekDays;
  final List<DateTime>? disabledDates;
  final void Function(DateTime date)? onTap;
  final Widget Function(BuildContext context, bool isSelected, bool isDisabled,
      String year, String week, String date)? cardBuilder;

  const TblDatePicker({
    super.key,
    required this.startDate,
    required this.endDate,
    this.selectDate,
    this.cardBuilder,
    this.onTap,
    this.height,
    this.padding,
    this.disableWeekDays,
    this.disabledDates,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure the start date is before or the same as the end date
    if (startDate.isAfter(endDate)) {
      return const Center(
        child: Text(
          'Invalid date range',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    DateTime adjustedStartDate =
        DateTime(startDate.year, startDate.month, startDate.day);
    DateTime adjustedEndDate =
        DateTime(endDate.year, endDate.month, endDate.day);
    int totalDays = adjustedEndDate.difference(adjustedStartDate).inDays + 1;

    return SizedBox(
      height: height ?? 75,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: totalDays,
        scrollDirection: Axis.horizontal,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 15),
        itemBuilder: (context, index) {
          DateTime currentDate = adjustedStartDate.add(Duration(days: index));
          String dayName = DateFormat('E').format(currentDate);
          String dayNumber = DateFormat('dd').format(currentDate);
          String yearNumber = DateFormat('yyyy').format(currentDate);

          // Determine if the current date should be disabled
          bool isDisabled = (disableWeekDays?.contains(dayName) ?? false) ||
              (disabledDates?.any((date) =>
                      date.year == currentDate.year &&
                      date.month == currentDate.month &&
                      date.day == currentDate.day) ??
                  false);

          return GestureDetector(
            onTap: isDisabled ? null : () => onTap?.call(currentDate),
            child: Builder(
              builder: (context) {
                if (cardBuilder != null) {
                  return cardBuilder!(context, currentDate == selectDate,
                      isDisabled, yearNumber, dayName, dayNumber);
                }

                return Opacity(
                  opacity: isDisabled ? 0.3 : 1,
                  child: Container(
                    width: 63,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: currentDate == selectDate
                          ? Theme.of(context).primaryColor
                          : (isDisabled ? Colors.grey.withOpacity(0.2) : null),
                      borderRadius: BorderRadius.circular(15),
                      border: !isDisabled && currentDate != selectDate
                          ? Border.all(
                              width: 1, color: Colors.grey.withOpacity(0.1))
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            yearNumber,
                            style: TextStyle(
                              color: currentDate == selectDate
                                  ? Colors.white.withOpacity(0.6)
                                  : Theme.of(context).primaryColor,
                              fontSize: 8,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          dayName,
                          style: TextStyle(
                            color: currentDate == selectDate
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          dayNumber,
                          style: TextStyle(
                            color: currentDate == selectDate
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Generates a list of 24-hour time slots in 30-minute intervals.
///
/// Returns a list of time slots formatted as 'hh:mm a'.
List<String> generate24HourTimeSlots() {
  List<String> timeSlots = [];
  DateFormat timeFormat = DateFormat('hh:mm a');

  DateTime startTime = DateTime.now();
  if (startTime.minute >= 30) {
    startTime = DateTime(
        startTime.year, startTime.month, startTime.day, startTime.hour, 30);
  } else {
    startTime = DateTime(
        startTime.year, startTime.month, startTime.day, startTime.hour, 0);
  }

  DateTime endTime = startTime.add(const Duration(hours: 24));

  while (startTime.isBefore(endTime)) {
    timeSlots.add(timeFormat.format(startTime));
    startTime = startTime.add(const Duration(minutes: 30));
  }

  return timeSlots;
}

/// A widget that provides a horizontal time picker with time slots.
///
/// [timeSlots] is a list of available time slots.
/// [selected] is the currently selected time slot (optional).
/// [height] specifies the height of the picker (optional).
/// [padding] specifies the padding around the picker (optional).
/// [disabledTimeSlots] is a list of time slots to disable (optional).
/// [cardBuilder] is a custom widget builder for each time slot card (optional).
/// [onTap] is a callback function triggered when a time slot is tapped (optional).
class TblTimePicker extends StatelessWidget {
  final List<String> timeSlots;
  final String? selected;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final List<String>? disabledTimeSlots;
  final Widget Function(
          BuildContext context, bool isSelected, bool isDisabled, String time)?
      cardBuilder;
  final void Function(int index, String value)? onTap;

  const TblTimePicker({
    super.key,
    required this.timeSlots,
    this.selected,
    this.disabledTimeSlots,
    this.cardBuilder,
    this.onTap,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Check if time slots are available
    if (timeSlots.isEmpty) {
      return const Center(
        child: Text(
          'No time slots available',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return SizedBox(
      height: height ?? 40,
      child: ListView.builder(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 15),
        itemCount: timeSlots.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String currentTimeSlot = timeSlots[index];
          bool isDisabled =
              (disabledTimeSlots?.contains(currentTimeSlot) ?? false);
          bool isSelected = selected == currentTimeSlot;

          return GestureDetector(
            onTap:
                isDisabled ? null : () => onTap?.call(index, currentTimeSlot),
            child: Builder(
              builder: (context) {
                if (cardBuilder != null) {
                  return cardBuilder!(
                      context, isSelected, isDisabled, currentTimeSlot);
                }

                return Opacity(
                  opacity: isDisabled ? 0.3 : 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).primaryColor : null,
                      borderRadius: BorderRadius.circular(13),
                      border: !isSelected
                          ? Border.all(
                              width: 1, color: Colors.grey.withOpacity(0.2))
                          : null,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          currentTimeSlot,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
