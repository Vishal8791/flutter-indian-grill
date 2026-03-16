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
        "${_selectedDay!.month}-${_selectedDay!.day}-${_selectedDay!.year}";
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

    return TapRegion(
      onTapOutside: (event) {
        if (_showCalendar) {
          setState(() {
            _showCalendar = false;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Label
        Text(
          widget.labelText,
          style: GoogleFonts.raleway(
            fontSize: 13,
            color: Colors.black,
            fontWeight: FontWeight.w600
          ),
        ),
        const SizedBox(height: 6),

        // Textbox
        TextField(
          controller: widget.controller,
          readOnly: true,
          showCursor: false, // Prevents caret from showing
          onTap: () {
            setState(() {
              _showCalendar = !_showCalendar;
            });
          },
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                color: Color(0xff666666),
                width: 0.5,
              ),
            ),
            suffixIcon: Icon(
              Icons.calendar_today,
              color: _showCalendar ? const Color(0xffe2001a) : Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: _showCalendar ? const Color(0xffe2001a) : Colors.grey,
                width: _showCalendar ? 1.5 : 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: _showCalendar ? const Color(0xffe2001a) : Colors.black54,
                width: _showCalendar ? 1.5 : 1.0,
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
              firstDay: DateTime.now(), // ⛔ No past dates
              lastDay: DateTime(2100),
              rowHeight: rowHeight,
              daysOfWeekHeight: daysOfWeekHeight,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontSize: fontSize),
                weekendStyle: TextStyle(fontSize: fontSize),
              ),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

              // ✅ Prevent selecting past dates
              onDaySelected: (selectedDay, focusedDay) {
                final today = DateTime.now();
                final selected = DateTime(
                  selectedDay.year,
                  selectedDay.month,
                  selectedDay.day,
                );

                if (selected
                    .isBefore(DateTime(today.year, today.month, today.day))) {
                  // Ignore past dates
                  return;
                }

                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focusedDay;
                  _showCalendar = false;
                  widget.controller.text =
                      "${selected.month}-${selected.day}-${selected.year}";
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
                // 🔒 Optional: visually gray out past dates
                disabledTextStyle: const TextStyle(color: Colors.grey),
              ),

              enabledDayPredicate: (day) {
                // 🔒 Disable past days
                return !day.isBefore(
                  DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day),
                );
              },

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
      ),
    );
  }
}
