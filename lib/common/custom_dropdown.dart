import 'package:flutter/material.dart';
import 'package:todo_app/common/resources/string_resources.dart';
class CustomDropDown extends StatefulWidget {
  final Function(String) onSelectionChanged;
  const CustomDropDown({super.key, required this.onSelectionChanged});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String selectedValue = StringResources.getTenMin;
  List<String> scheduleNotify = [StringResources.getTenMin, StringResources.getOneHour , StringResources.getOneDay, StringResources.getCustomNotify];
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue!;
          widget.onSelectionChanged(selectedValue);
        });
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
