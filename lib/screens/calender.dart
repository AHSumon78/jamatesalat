import 'package:flutter/material.dart';
import 'package:islamic_hijri_calendar/islamic_hijri_calendar.dart';
import 'package:jamatesalat/models/global_function.dart';

class Calender extends StatelessWidget {
  const Calender({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic Hijri Calendar'),
        backgroundColor: bgColor,
      ),
      body: Center(
        child: IslamicHijriCalendar(
          isHijriView: true,
          highlightBorder: Theme.of(context).colorScheme.primary,
          defaultBorder:
              Theme.of(context).colorScheme.onSurface.withOpacity(.1),
          highlightTextColor: Theme.of(context).colorScheme.surface,
          defaultTextColor: Theme.of(context).colorScheme.onSurface,
          defaultBackColor: Theme.of(context).colorScheme.surface,
          adjustmentValue: 0,
          isGoogleFont: true,
          fontFamilyName: "Lato",
          getSelectedEnglishDate: (selectedDate) {
            print("English Date : $selectedDate");
          },
          getSelectedHijriDate: (selectedDate) {
            print("Hijri Date : $selectedDate");
          },
          isDisablePreviousNextMonthDates: true,
        ),
      ),
    );
  }
}
