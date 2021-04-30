import 'package:flutter_app/dr_appointments_edit.dart';

import 'horizontal_time_picker.dart';

int counter = 0;
List<TimeUnit> getDateTimeSlotList(int startTimeInHour, int endTimeInHour,
    int timeIntervalInMinutes, DateTime dateForTime) {
  List<TimeUnit> timeSlots = [];
  for (int i = startTimeInHour; i < endTimeInHour; i++) {
    int intervalDerived = 0;
    // By default 0 minute: int intervalDerived = 0;
    // Made change to set starting minute from selected minute
    if(counter == 0) {
      intervalDerived = startTime.minute;
      counter++;
    }
      while (intervalDerived < 60) {
        timeSlots.add(TimeUnit(i, intervalDerived));
        intervalDerived = intervalDerived + timeIntervalInMinutes;
      }
  }
  return timeSlots;
}

isTimeSlotDisabled(DateTime dateForTime, TimeUnit timeSlot) {
  DateTime selectedDateTime = DateTime(dateForTime.year, dateForTime.month,
      dateForTime.day, timeSlot.hour, timeSlot.minute, 0, 0, 0);
  if (selectedDateTime.isBefore(DateTime.now())) {
    return true;
  }
  return false;
}

isTimeSlotSelected(
    List<TimeUnit> selectedDateTimeSlots, TimeUnit timeSlotIterated) {
  if (selectedDateTimeSlots.isEmpty) return false;
  bool found = false;
  selectedDateTimeSlots.forEach((timeSlot) {
    if (timeSlot.hour == timeSlotIterated.hour &&
        timeSlot.minute == timeSlotIterated.minute) {
      found = true;
    }
  });

  return found;
}