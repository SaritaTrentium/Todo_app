import 'package:flutter/material.dart';
import 'package:todo_app/common/custom_textformfield.dart';
import 'package:todo_app/common/validator.dart';
import 'package:country_picker/country_picker.dart';

class RegisterWithPhone extends StatefulWidget {
  const RegisterWithPhone({super.key});

  @override
  State<RegisterWithPhone> createState() => _RegisterWithPhoneState();
}

class _RegisterWithPhoneState extends State<RegisterWithPhone> {
  Country selectedCountry = Country(
    phoneCode: '91',
    countryCode: 'IN',
    e164Sc: 0,
    geographic: true,
    level: 1, name: 'India', example: 'India', displayName: 'India', displayNameNoCountryCode: 'India', e164Key: '',
  );
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController smsCodeController = TextEditingController();

  bool codeSent = false;
  @override
  Widget build(BuildContext context) {
    // late AuthProvider _authProvider;
    //_authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Phone Number Authentication',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                  labelText: 'Enter your phone number',
                  controller: phoneNumberController,
                textInputAction: TextInputAction.done,
                prefixIcon: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      showCountryPicker(
                          context: context,
                          countryListTheme: const CountryListThemeData(
                            bottomSheetHeight: 550,
                          ),
                          onSelect: (value) {
                            setState(() {
                              selectedCountry = value;
                            });
                          });
                    },
                    child: Text(
                      "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                validator: (value) => Validator.validateNumber(phoneNumberController.text),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                      onPressed: () {
                       // Navigator.of(context).pushNamed('/otp');
                      },
                      child: Text('Verify Code'),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
