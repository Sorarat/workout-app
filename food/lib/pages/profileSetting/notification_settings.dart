import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:food/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime scheduleTime = DateTime.now();

class NotificationSettings extends StatefulWidget {
  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  final NotificationService _notificationService = NotificationService();
  bool _isBreakReminderEnabled = false; // initial toggle state

  @override
  void initState() {
    super.initState();
    _notificationService.initNotification();
    _loadToggleState();
  }

  Future<void> _loadToggleState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBreakReminderEnabled = prefs.getBool('break_reminder_enabled') ?? false;
    });
  }

  Future<void> _saveToggleState(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('break_reminder_enabled', value);
  }

   void _scheduleNotification() {
    if (_isBreakReminderEnabled) {
      _notificationService.scheduleDailyNotification(
        title: 'Goodgrit',
        body: 'It\'s time for your exercise!',
        scheduledTime: scheduleTime,
      );
      debugPrint('Notification Scheduled for $scheduleTime');

  
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enable the break reminder toggle to set a notification.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

   void _toggleBreakReminder(bool value) async {
    setState(() {
      _isBreakReminderEnabled = value;
    });
    await _saveToggleState(value);
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Receive exercise \n reminder every',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(child: CupertinoDatePickerTxt()),
                      ],
                    ),
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
              SizedBox(height: 20),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Take break reminder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    CupertinoSwitch(
                      value: _isBreakReminderEnabled, 
                      onChanged: _toggleBreakReminder,
                    )
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
        color: Color.fromARGB(255, 255, 255, 255),
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
            )
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
