import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';

class DatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  const DatePickerField({
    super.key,
    required this.controller,
    this.labelText = "Select Date",
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  bool _showCalendar = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    widget.controller.text =
        "${_selectedDay!.day}-${_selectedDay!.month}-${_selectedDay!.year}";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600; // breakpoint

    // 📱 Mobile sizing vs 🖥️ Desktop sizing
    final rowHeight = isMobile ? 36.0 : 52.0;
    final daysOfWeekHeight = isMobile ? 26.0 : 32.0;
    final fontSize = isMobile ? 12.0 : 14.0;
    final headerFontSize = isMobile ? 14.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.labelText,
          style: GoogleFonts.raleway(
            fontSize: 13,
            color: const Color(0xff666666),
          ),
        ),
        const SizedBox(height: 6),

        // Textbox
        GestureDetector(
          onTap: () {
            setState(() {
              _showCalendar = !_showCalendar;
            });
          },
          child: AbsorbPointer(
            child: TextField(
              controller: widget.controller,
              readOnly: true,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: const BorderSide(
                    color: Color(0xff666666),
                    width: 0.5,
                  ),
                ),
                suffixIcon: const Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0), // No rounded corners
                  borderSide: const BorderSide(
                    color: Colors
                        .grey, // Border color when text field is not focused
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0), // No rounded corners
                  borderSide: const BorderSide(
                    color:
                        Colors.grey, // Border color when text field is focused
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Calendar Popup
        if (_showCalendar)
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              // borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(1900),
              lastDay: DateTime(2100),
              rowHeight: rowHeight,
              daysOfWeekHeight: daysOfWeekHeight,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontSize: fontSize),
                weekendStyle: TextStyle(fontSize: fontSize),
              ),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _showCalendar = false; // close after picking
                  widget.controller.text =
                      "${selectedDay.day}-${selectedDay.month}-${selectedDay.year}";
                });
              },
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(fontSize: fontSize),
                weekendTextStyle: TextStyle(fontSize: fontSize),
                selectedDecoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: GoogleFonts.raleway(
                  fontSize: headerFontSize,
                  color: const Color(0xff666666),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
