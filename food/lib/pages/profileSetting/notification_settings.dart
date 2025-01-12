import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:food/services/notification_service.dart';

DateTime scheduleTime = DateTime.now();

class NotificationSettings extends StatefulWidget {
  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.initNotification();
  }

  Future<void> _scheduleNotification() {
    _notificationService.scheduleDailyNotification(
      title: 'Goodgrit',
      body: 'It\'s time for your exercise!',
      scheduledTime: scheduleTime,
    );
    debugPrint('Notification Scheduled for $scheduleTime');

    // Show Snackbar with the scheduled time
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Daily reminder set for ${_formatTime(scheduleTime)}'),
      duration: Duration(seconds: 2),
    ),
  );
    return Future.value(); // Placeholder for async completion
  }

  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Notifications Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Receive exercise \n reminder every',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    CupertinoDatePickerTxt(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _scheduleNotification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF031927),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Schedule notifications'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CupertinoDatePickerTxt extends StatefulWidget {
  const CupertinoDatePickerTxt({Key? key}) : super(key: key);

  @override
  State<CupertinoDatePickerTxt> createState() => _CupertinoDatePickerTxtState();
}

class _CupertinoDatePickerTxtState extends State<CupertinoDatePickerTxt> {
  TextEditingController _dateTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateTimeController.text = _formatTime(scheduleTime);
  }

  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  void _showCupertinoDateTimePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                initialDateTime: scheduleTime,
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    scheduleTime = newDateTime;
                    _dateTimeController.text = _formatTime(scheduleTime);
                  });
                },
              ),
            ),
            CupertinoButton(
              child: Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _dateTimeController,
      readOnly: true,
      onTap: () => _showCupertinoDateTimePicker(context),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(6.0),
        hintText: 'Select Time',
        hintStyle: TextStyle(
          fontSize: 14,
        ),
        isDense: true,
        isCollapsed: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
