import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/custom_button.dart';
import 'package:todo_app/common/custom_textformfield.dart';
import 'package:todo_app/common/custom_dropdown.dart';
import 'package:todo_app/common/resources/string_resources.dart';
import 'package:todo_app/common/validator.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
import 'dart:async';

class TodoScreen extends StatefulWidget {
  TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late Timer notificationTimer;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController customTimeController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();
  late TodoListProvider todoListProvider;
  var selectedTimeUnit;
  int? customTimeValue;
  bool showError = false;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  // onDropdownValueChanged(String value) {
  //   selectedDropdownValue = value;
  //   if(selectedDropdownValue == StringResources.getCustomNotify){
  //     _showCustomTimeInputDialog(context, selectedDropdownValue, setCustomTime);
  //   }
  // }

    @override
    Widget build(BuildContext context) {
    todoListProvider = Provider.of<TodoListProvider>(context);
      return Container(
        child: _buildAddTodoScreen(),
      );
    }
  Future<void> _selectDateAndTime(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10), // Set a reasonable future limit
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
        confirmText: StringResources.getConfirm,
      );
      if (selectedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  void addTodo() async {
    if (_formKey.currentState!.validate()) {
      final title = titleController.text;
      final desc = descController.text;
      print('Adding todo: Title: $title, Description: $desc');
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String userEmail = user.email ?? "";

          final newTodo = Todo(
            id: 1,
            title: title,
            desc: desc,
            deadline: selectedDateTime,
            userId: userEmail,);

          late TodoListProvider _todoListProvider;
           _todoListProvider = Provider.of<TodoListProvider>(
              context, listen: false);
          setState(() {
            _todoListProvider.addTodo(newTodo);
          });
          print('Add data title: $title and desc: $desc deadline: $selectedDateTime userId: $userEmail');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(StringResources.getAddSuccess),),);
            Navigator.of(context).popAndPushNamed('/dashboard');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(StringResources.getUserNotExist)));
        }
      } on PlatformException catch (e) {
        print('PlatformException: $e');}
      catch (error) {
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())));
      }
    }
  }

  Widget _buildAddTodoScreen() {
    return  Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomTextFormField(
                controller: titleController,
                labelText: StringResources.getAddTodoTitle,
                textInputAction: TextInputAction.next,
                validator:(value) => Validator.validateTitle(titleController.text),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomTextFormField(
                controller: descController,
                labelText: StringResources.getAddTodoDesc,
                textInputAction: TextInputAction.next,
                validator:(value) => Validator.validateDesc(descController.text),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      readOnly: true,
                      textInputAction: TextInputAction.done,
                      controller: TextEditingController(
                          text:DateFormat.yMEd().add_jms().format(selectedDateTime)),
                      labelText: StringResources.getAddTodoSelectedDateTime,
                      onTap: () => _selectDateAndTime(context),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  CustomDropDown(
                    selectedValue: todoListProvider.selectedDropdownValue,
                    onSelectionChanged: (String value){
                      todoListProvider.setNotificationTimer(value);
                      print("DropDown Value: $value");
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
              onPressed: addTodo,
              text: StringResources.getAdd,
              textColor: Theme.of(context).brightness == Brightness.dark
                  ?  Colors.black
                  :  Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // void _showCustomTimeInputDialog(BuildContext context, String selectedDropdownValue, void Function(int?) setCustomTime) {
  //   double dialogWidth = 300.0;
  //   double dialogHeight = 100.0;
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context){
  //         final _formKey = GlobalKey<FormState>();
  //         return AlertDialog(
  //           title: Text(StringResources.getCustomNotify),
  //           content: Form(
  //             key: _formKey,
  //             child: Container(
  //               height: dialogHeight,
  //               width: dialogWidth,
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Expanded(
  //                     child: CustomTextFormField(
  //                         controller: customTimeController,
  //                         labelText: StringResources.getAddCustomTitle,
  //                         textInputAction: TextInputAction.done,
  //                         keyboardType: TextInputType.number,
  //                         validator: (value) => Validator.validateCustomTime(customTimeController.text),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 10),
  //                   DropdownButton<String>(
  //                     value: selectedTimeUnit,
  //                     onChanged: (String? newValue) {
  //                       setState(() {
  //                         selectedTimeUnit = newValue!;
  //                       });
  //                     },
  //                     items: [
  //                       DropdownMenuItem<String>(
  //                         value: StringResources.getMinutes,
  //                         child: Text(StringResources.getMinutes),
  //                       ),
  //                       DropdownMenuItem<String>(
  //                         value: StringResources.getHours,
  //                         child: Text(StringResources.getHours),
  //                       ),
  //                       DropdownMenuItem<String>(
  //                         value: StringResources.getDays,
  //                         child: Text(StringResources.getDays),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           actions: <Widget>[
  //             TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text(StringResources.getCancel),),
  //             TextButton(
  //               onPressed: () {
  //                 if(_formKey.currentState!.validate()){
  //                   int customTime = int.parse(customTimeController.text);
  //                   if(selectedTimeUnit == StringResources.getHours){
  //                     customTime *= 60;
  //                   }else if (selectedTimeUnit == StringResources.getDays) {
  //                     customTime *= 60 * 24; // Convert days to minutes
  //                   }
  //                   print('Custom Time: $customTime minutes');
  //                   setCustomTime(customTime);
  //                   Navigator.of(context).pop();
  //                                   }
  //                 }, child: Text(StringResources.getConfirm),
  //             ),
  //           ],
  //         );
  //       });
  // }

  // void setCustomTime(int? time) {
  //   setState(() {
  //     customTimeValue = time;
  //   });
  // }

}