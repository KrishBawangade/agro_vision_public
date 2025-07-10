import 'package:flutter/material.dart';

/// A dropdown button to select a duration (in months).
/// 
/// [onDurationChanged] - Callback returning the index of the selected duration (0 for 3 months, 1 for 6 months, 2 for 12 months).
class DurationDropDownButton extends StatefulWidget {
  final Function(int durationIndex) onDurationChanged;

  const DurationDropDownButton({
    super.key,
    required this.onDurationChanged,
  });

  @override
  State<DurationDropDownButton> createState() => _DurationDropDownButtonState();
}

class _DurationDropDownButtonState extends State<DurationDropDownButton> {
  final List<String> _durationList = ["3", "6", "12"];
  String? _selectedDuration;

  @override
  void initState() {
    super.initState();
    // Default selected duration is 6 months
    _selectedDuration = _durationList[1];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedDuration,
      items: _durationList.map((duration) {
        return DropdownMenuItem<String>(
          value: duration,
          child: Text(
            "$duration months",
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        // Update selected value and notify parent
        setState(() {
          _selectedDuration = value;
        });
        widget.onDurationChanged(_durationList.indexOf(value!));
      },
    );
  }
}
