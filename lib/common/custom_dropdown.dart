import 'package:flutter/material.dart';
import 'package:todo_app/common/resources/string_resources.dart';
class CustomDropDown extends StatefulWidget {
  final Function(String) onSelectionChanged;
  final String selectedValue;
  const CustomDropDown({super.key, required this.onSelectionChanged,required this.selectedValue});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  List<String> scheduleNotify = [StringResources.getTenMin, StringResources.getOneHour , StringResources.getOneDay, StringResources.getCustomNotify];
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedValue,
      onChanged: (String? newValue) {
          widget.onSelectionChanged(newValue ?? " ");
      },
      items: scheduleNotify.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
