import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/progress_header.dart';
import '../widgets/footer_button.dart';

class DateTimeScreen extends StatefulWidget {
  const DateTimeScreen({Key? key}) : super(key: key);

  @override
  _DateTimeScreenState createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen>
    with TickerProviderStateMixin {

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? _selectedTimeSlot;

  final List<TimeSlotCategory> _timeSlotCategories = [
    TimeSlotCategory(
      title: 'Morning',
      timeSlots: [
        TimeSlot(time: '10:00 AM', isAvailable: true),
        TimeSlot(time: '10:30 AM', isAvailable: true),
        TimeSlot(time: '11:00 AM', isAvailable: false),
        TimeSlot(time: '11:30 AM', isAvailable: true),
      ],
    ),
    TimeSlotCategory(
      title: 'Afternoon',
      timeSlots: [
        TimeSlot(time: '12:00 PM', isAvailable: false),
        TimeSlot(time: '12:30 PM', isAvailable: false),
        TimeSlot(time: '1:00 PM', isAvailable: true),
        TimeSlot(time: '1:30 PM', isAvailable: true),
        TimeSlot(time: '2:00 PM', isAvailable: true),
        TimeSlot(time: '2:30 PM', isAvailable: false),
        TimeSlot(time: '3:00 PM', isAvailable: true),
        TimeSlot(time: '3:30 PM', isAvailable: true),
        TimeSlot(time: '4:00 PM', isAvailable: true),
        TimeSlot(time: '4:30 PM', isAvailable: true),
      ],
    ),
    TimeSlotCategory(
      title: 'Evening',
      timeSlots: [
        TimeSlot(time: '5:00 PM', isAvailable: true),
        TimeSlot(time: '5:30 PM', isAvailable: true),
        TimeSlot(time: '6:00 PM', isAvailable: true),
        TimeSlot(time: '6:30 PM', isAvailable: true),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedTimeSlot = null;
      });
    }
  }

  void _selectTimeSlot(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
  }

  // Helper function to get the first day of current month
  DateTime _getFirstDayOfCurrentMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  // Helper function to get the last day of next month
  DateTime _getLastDayOfNextMonth() {
    final now = DateTime.now();
    final nextMonth = now.month == 12 ? 1 : now.month + 1;
    final nextYear = now.month == 12 ? now.year + 1 : now.year;
    return DateTime(nextYear, nextMonth + 1, 0); // Last day of next month
  }

  // Custom centered alert dialog
  void _showCenteredAlert(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 140),
                  const SizedBox(height: 25),

                  // Date Title - Outside the calendar box
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Date",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Calendar Card - Fixed to allow parent scrolling
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          // Let parent handle all scroll notifications
                          return false;
                        },
                        child: TableCalendar<dynamic>(
                          firstDay: _getFirstDayOfCurrentMonth(),
                          lastDay: _getLastDayOfNextMonth(),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: _onDaySelected,
                          onPageChanged: (focusedDay) {
                            // Only allow page change if it's within the allowed range
                            if (focusedDay.isAfter(_getFirstDayOfCurrentMonth().subtract(Duration(days: 1))) &&
                                focusedDay.isBefore(_getLastDayOfNextMonth().add(Duration(days: 1)))) {
                              setState(() {
                                _focusedDay = focusedDay;
                              });
                            }
                          },
                          // Disable page scrolling/swiping and gestures on calendar
                          pageAnimationEnabled: false,
                          availableGestures: AvailableGestures.none,
                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: false,
                            selectedDecoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            todayDecoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            defaultDecoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            weekendDecoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            defaultTextStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            weekendTextStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            selectedTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            todayTextStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            disabledTextStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            cellMargin: EdgeInsets.all(4),
                            cellPadding: EdgeInsets.zero,
                            tablePadding: EdgeInsets.zero,
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            leftChevronIcon: Icon(
                              Icons.chevron_left,
                              color: Colors.black87,
                            ),
                            rightChevronIcon: Icon(
                              Icons.chevron_right,
                              color: Colors.black87,
                            ),
                            titleTextStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            headerPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                            weekendStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          // Add this to control which days can be selected
                          enabledDayPredicate: (day) {
                            return day.isAfter(DateTime.now().subtract(Duration(days: 1)));
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Available Slots Title - Outside the slots box
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Available Slots",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Time Slots Card - Without title inside
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._timeSlotCategories.map((category) {
                            return _buildTimeSlotCategory(category);
                          }).toList(),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProgressHeader(
              title: 'grow Tokyo BKK',
              currentStep: 3,
              totalSteps: 3,
              stepLabels: ['Staff', 'Services', 'Date & Time'],
              onBackPressed: () => Navigator.of(context).pop(),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.grey[50],
              child: FooterButton(
                staffName: 'Mochi',
                serviceText: 'Cut (For Men)',
                onButtonPressed: () {
                  if (_selectedTimeSlot != null) {
                    final bookingDateTime = {
                      'date': _selectedDay,
                      'time': _selectedTimeSlot,
                    };
                    Navigator.of(context).pushNamed('/detail', arguments: bookingDateTime);
                  } else {
                    _showCenteredAlert('Please select a time slot');
                  }
                },
                buttonText: 'Continue',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotCategory(TimeSlotCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              category.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          _buildTimeSlots(category),
        ],
      ),
    );
  }

  Widget _buildTimeSlots(TimeSlotCategory category) {
    // Calculate the available width for slots (same as calendar width)
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - 80; // 40px margin on each side

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemsPerRow = 3; // Same as calendar days
        final spacing = 12.0;
        final itemWidth = (constraints.maxWidth - (spacing * (itemsPerRow - 1))) / itemsPerRow;

        final rows = <Widget>[];
        for (int i = 0; i < category.timeSlots.length; i += itemsPerRow) {
          final rowItems = category.timeSlots.skip(i).take(itemsPerRow).toList();

          rows.add(
            Padding(
              padding: EdgeInsets.only(bottom: i + itemsPerRow < category.timeSlots.length ? 12 : 0),
              child: Row(
                children: [
                  ...rowItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final timeSlot = entry.value;

                    return [
                      SizedBox(
                        width: itemWidth,
                        child: _buildTimeSlotItem(timeSlot),
                      ),
                      if (index < rowItems.length - 1) SizedBox(width: spacing),
                    ];
                  }).expand((element) => element),
                  // Add empty spaces for incomplete rows
                  ...List.generate(
                    itemsPerRow - rowItems.length,
                        (index) => [
                      if (rowItems.isNotEmpty) SizedBox(width: spacing),
                      SizedBox(width: itemWidth),
                    ],
                  ).expand((element) => element),
                ],
              ),
            ),
          );
        }

        return Column(children: rows);
      },
    );
  }

  Widget _buildTimeSlotItem(TimeSlot timeSlot) {
    final bool isSelected = timeSlot.time == _selectedTimeSlot;

    return InkWell(
      onTap: timeSlot.isAvailable ? () => _selectTimeSlot(timeSlot.time) : null,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black
              : timeSlot.isAvailable
              ? Colors.grey[100]
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Colors.black
                : Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            timeSlot.time,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : timeSlot.isAvailable
                  ? Colors.black87
                  : Colors.grey[500],
              fontWeight: FontWeight.w600,
              fontSize: 15,
              decoration: timeSlot.isAvailable
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
              decorationColor: Colors.grey[500],
              decorationThickness: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class TimeSlotCategory {
  final String title;
  final List<TimeSlot> timeSlots;
  bool isExpanded;

  TimeSlotCategory({
    required this.title,
    required this.timeSlots,
    this.isExpanded = false,
  });
}

class TimeSlot {
  final String time;
  final bool isAvailable;

  TimeSlot({
    required this.time,
    this.isAvailable = true,
  });
}