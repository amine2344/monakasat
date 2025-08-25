import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

class DateRangePickerWidget extends StatelessWidget {
  final Rxn<dp.DatePeriod> selectedDateRange;
  final void Function(dp.DatePeriod) onDateRangeChanged;
  final Color primaryColor;

  const DateRangePickerWidget({
    super.key,
    required this.selectedDateRange,
    required this.onDateRangeChanged,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return dp.RangePicker(
        selectedPeriod:
            selectedDateRange.value ??
            dp.DatePeriod(DateTime.now(), DateTime.now()),
        onChanged: (dp.DatePeriod newPeriod) {
          selectedDateRange.value = newPeriod;
          onDateRangeChanged(newPeriod);
        },
        firstDate: DateTime(2000),
        lastDate: DateTime(2030),
        datePickerStyles: dp.DatePickerRangeStyles(
          selectedPeriodStartDecoration: BoxDecoration(
            color: primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          selectedPeriodLastDecoration: BoxDecoration(
            color: primaryColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          selectedPeriodMiddleDecoration: BoxDecoration(
            color: primaryColor.withOpacity(0.6),
            shape: BoxShape.rectangle,
          ),
          selectedDateStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'NotoKufiArabic',
            fontSize: 14,
          ),
          defaultDateTextStyle: const TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontSize: 14,
          ),
          currentDateStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoKufiArabic',
          ),
          disabledDateStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: 'NotoKufiArabic',
          ),
          displayedPeriodTitle: const TextStyle(
            fontSize: 16,
            fontFamily: 'NotoKufiArabic',
            fontWeight: FontWeight.bold,
          ),
          dayHeaderStyle: const dp.DayHeaderStyle(
            textStyle: TextStyle(
              fontFamily: 'NotoKufiArabic',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }
}
