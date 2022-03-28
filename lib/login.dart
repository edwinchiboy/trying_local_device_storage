import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testing_storing_device/DB_helper2.dart';
import 'package:testing_storing_device/DB_model.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

//import 'package:testing_storing_device/helper.dart';
import 'package:testing_storing_device/profilescreeen.dart';
import 'package:testing_storing_device/read_data_page.dart';

class LogInScreen extends StatefulWidget {
  final DBModel? userDetail;
  const LogInScreen({Key? key, this.userDetail}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late String email;
  late String password;
  late String dOB;
  late String location;
  late String gender;

  dynamic _selectedLocation;
  final _formkey = GlobalKey<FormState>();
  DateTime? selectedDate;
  dynamic _userGender = "male";
  bool _loginAuthMode = false;
  bool _showEmailError = false;
  bool _showPasswordError = false;
  bool _showConfirmPasswordError = false;
  bool _showDOBError = false;
  bool _showLocationError = false;
  bool _obscurePassword = true;
  bool _obscureConfirmedPassword = true;
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dateofBirthTextFieldController =
      TextEditingController();
  //Helper helper = Helper();
  // Storage storage = Storage();

  final List<String> _locations = [
    "Abia",
    "Adamawa",
    "Akwa Ibom",
    "Anambra",
    "Bauchi",
    "Bayelsa",
    "Benue",
    "Borno",
    "Cross River",
    "Delta",
    "Ebonyi",
    "Edo",
    "Ekiti",
    "Enugu",
    "FCT - Abuja",
    "Gombe",
    "Imo",
    "Jigawa",
    "Kaduna",
    "Kano",
    "Katsina",
    "Kebbi",
    "Kogi",
    "Kwara",
    "Lagos",
    "Nasarawa",
    "Niger",
    "Ogun",
    "Ondo",
    "Osun",
    "Oyo",
    "Plateau",
    "Rivers",
    "Sokoto",
    "Taraba",
    "Yobe",
    "Zamfara"
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    DBHelper2.instance.close();

    super.dispose();
  }

  late List<DBModel> userProfiles;
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future refreshData() async {
    setState(() => isloading = true);
    userProfiles = await DBHelper2.instance.readAllDB();
    setState(() => isloading = false);
  }

  Future addNote() async {
    final userProfile = DBModel(
      userEmail: _emailController.text.toString(),
      userPassword: _passwordController.text.toString(),
      userDOB: _dateofBirthTextFieldController.text.toString(),
      userGender: _userGender,
      userLocation: _selectedLocation.toString(),
    );
    await DBHelper2.instance.create(userProfile);
  }

  void _submit() async {
    if (!_loginAuthMode) {
      if (!_formkey.currentState!.validate()) {
        return;
      }
      _formkey.currentState!.save();
      if (!_showEmailError &&
          !_showPasswordError &&
          !_showConfirmPasswordError &&
          !_showDOBError &&
          !_showLocationError) {
        addNote();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => ProfileScreen(
                      emailAddress: _emailController.text.toString(),
                      password: _passwordController.text.toString(),
                      dOB: _dateofBirthTextFieldController.text.toString(),
                      location: _selectedLocation.toString(),
                      gender: _userGender,
                    ))));
      }
    } else {
      if (!_formkey.currentState!.validate()) {
        return;
      }
      _formkey.currentState!.save();
      if (!_showEmailError && !_showPasswordError) {
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const ReadDataScreen())));
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(1980, 1),
        lastDate: DateTime(2030));
    // lastDate: DateTime(int.parse(formatted)));
    {
      if (picked != null) {
        setState(() {
          selectedDate = picked;
          _dateofBirthTextFieldController
            ..text = DateFormat.yMMMd().format(selectedDate!)
            ..selection = TextSelection.fromPosition(TextPosition(
                offset: _dateofBirthTextFieldController.text.length,
                affinity: TextAffinity.upstream));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    var borderRadiusSize = BorderRadius.circular(30);
    TextStyle greyMinStyle = TextStyle(
        color: Colors.grey[500], fontSize: 10.0, fontWeight: FontWeight.bold);
    TextStyle orangeMinStyle = const TextStyle(
        color: Colors.orange, fontSize: 10.0, fontWeight: FontWeight.bold);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.grey[50],
          ),
          width: deviceWidth,
          child: Column(children: [
            Container(
              height: deviceHeight * 0.4,
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                  ),
                  gradient: LinearGradient(
                    colors: [Colors.red, Color.fromARGB(255, 255, 163, 59)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0, 1],
                  )),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: deviceHeight * 0.12,
                      bottom: deviceWidth * 0.12,
                      left: deviceWidth * 0.3,
                      right: deviceWidth * 0.3,
                    ),
                    child: const Center(
                      child: Image(
                        image: AssetImage(
                            'lib/assets/images/product-placeholder.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 40,
                      ),
                      child: Text(
                        _loginAuthMode ? 'Login' : 'Sign Up',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            ),
            SizedBox(
              height: deviceHeight * 0.03,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.deepOrange.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              height: deviceHeight * 0.54,
              width: deviceWidth * 0.9,
              child: Padding(
                padding: EdgeInsets.only(
                  top: _loginAuthMode
                      ? deviceHeight * 0.06
                      : deviceHeight * 0.03,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: borderRadiusSize,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(1, 4),
                              ),
                            ]
                            // boxShadow: :
                            ),
                        width: deviceWidth * 0.8,
                        height: deviceHeight * 0.06,
                        child: TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            //labelText: ' Enter your Email',

                            border: InputBorder.none,
                            hintText: "Email",
                            hintStyle: greyMinStyle,
                            // contentPadding:
                            //   const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              size: 15,
                            ),
                            fillColor: Colors.white,
                            filled: false,
                          ),
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              setState(() {
                                _showEmailError = true;
                              });
                            } else {
                              setState(() {
                                _showEmailError = false;
                              });
                            }
                            return null;
                          },
                        ),
                      ),
                      Visibility(
                          visible: _showEmailError,
                          child: const Text(
                            "invalid email",
                            style: TextStyle(color: Colors.red, fontSize: 10),
                          )),
                      SizedBox(
                        height: deviceHeight * 0.03,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: borderRadiusSize,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(1, 4),
                              ),
                            ]
                            // boxShadow: :
                            ),
                        width: deviceWidth * 0.8,
                        height: deviceHeight * 0.06,
                        child: TextFormField(
                          maxLines: 1,
                          obscureText: _obscurePassword,
                          controller: _passwordController,
                          style: const TextStyle(fontSize: 10),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle: greyMinStyle,
                            //contentPadding: const EdgeInsets.all(0),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 15),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            prefixIcon: const Icon(
                              Icons.key_outlined,
                              size: 15,
                            ),
                            fillColor: Colors.white,
                            filled: false,
                          ),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 8) {
                              setState(() {
                                _showPasswordError = true;
                              });
                            } else {
                              setState(() {
                                _showPasswordError = false;
                              });
                            }

                            return null;
                          },
                        ),
                      ),
                      Visibility(
                          visible: _showPasswordError,
                          child: const Text(
                            "Incorrect Password!",
                            style: TextStyle(color: Colors.red, fontSize: 10),
                          )),
                      Visibility(
                        visible: !_loginAuthMode,
                        child: SizedBox(
                          height: deviceHeight * 0.03,
                        ),
                      ),
                      Visibility(
                        visible: !_loginAuthMode,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: borderRadiusSize,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(1, 4),
                                ),
                              ]),
                          width: deviceWidth * 0.8,
                          height: deviceHeight * 0.06,
                          child: TextFormField(
                            maxLines: 1,
                            obscureText: _obscureConfirmedPassword,
                            style: const TextStyle(fontSize: 10),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Confirm Password",
                              hintStyle: greyMinStyle,
                              // contentPadding: const EdgeInsets.all(0),
                              prefixIcon: const Icon(
                                Icons.key_outlined,
                                size: 15,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    _obscureConfirmedPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: 15),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmedPassword =
                                        !_obscureConfirmedPassword;
                                  });
                                },
                              ),
                              fillColor: Colors.white,
                              filled: false,
                            ),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  value != _passwordController.text) {
                                setState(() {
                                  _showConfirmPasswordError = true;
                                });
                              } else {
                                setState(() {
                                  _showConfirmPasswordError = false;
                                });
                              }

                              return null;
                            },
                          ),
                        ),
                      ),
                      Visibility(
                          visible: _showConfirmPasswordError,
                          child: const Text(
                            "Passwords do not match!",
                            style: TextStyle(color: Colors.red, fontSize: 10),
                          )),
                      SizedBox(
                        height: !_loginAuthMode ? deviceHeight * 0.03 : 02,
                      ),
                      Visibility(
                        visible: !_loginAuthMode,
                        child: Padding(
                            padding: EdgeInsets.only(
                              left: deviceWidth * 0.00,
                              right: deviceWidth * 0.03,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: deviceWidth * 0.05,
                                    bottom: 0,
                                  ),
                                  child: const Text(
                                    'Please Select Gender: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: deviceWidth * 0.05,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Male:',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black)),
                                      Transform.scale(
                                        scale: 0.5,
                                        child: Radio(
                                          value: "male",
                                          groupValue: _userGender,
                                          onChanged: (value) {
                                            setState(() {
                                              _userGender = value;
                                            });
                                          },
                                        ),
                                      ),
                                      const Text(
                                        'Female:',
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.black),
                                      ),
                                      Transform.scale(
                                        scale: 0.5,
                                        child: Radio(
                                          value: "female",
                                          groupValue: _userGender,
                                          onChanged: (value) {
                                            setState(() {
                                              _userGender = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Visibility(
                        visible: !_loginAuthMode,
                        child: SizedBox(
                          height: deviceHeight * 0.03,
                        ),
                      ),
                      Visibility(
                        visible: !_loginAuthMode,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: borderRadiusSize,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(1, 4),
                                ),
                              ]),
                          width: deviceWidth * 0.8,
                          height: deviceHeight * 0.06,
                          child: TextFormField(
                            focusNode: AlwaysDisabledFocusNode(),
                            controller: _dateofBirthTextFieldController,
                            onTap: () => _selectDate(context),
                            maxLines: 1,
                            style: const TextStyle(fontSize: 10),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "enter date of Birth",
                              hintStyle: greyMinStyle,
                              //contentPadding: const EdgeInsets.all(0),
                              prefixIcon: const Icon(
                                Icons.calendar_month_outlined,
                                size: 15,
                              ),
                              fillColor: Colors.white,
                              filled: false,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  _showDOBError = true;
                                });
                              } else {
                                setState(() {
                                  _showDOBError = false;
                                });
                              }

                              return null;
                            },
                          ),
                        ),
                      ),
                      Visibility(
                          visible: _showDOBError,
                          child: const Text(
                            "DOB empty, please fill in your DOB",
                            style: TextStyle(color: Colors.red, fontSize: 10),
                          )),
                      Visibility(
                        visible: !_loginAuthMode,
                        child: SizedBox(
                          height: deviceHeight * 0.03,
                        ),
                      ),
                      Visibility(
                        visible: !_loginAuthMode,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: borderRadiusSize,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: const Offset(1, 4),
                                  ),
                                ]),
                            width: deviceWidth * 0.8,
                            height: deviceHeight * 0.06,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: deviceHeight * 0.01,
                                  bottom: 0,
                                  left: deviceWidth * 0.1,
                                  right: deviceWidth * 0.05),
                              child: DropdownButtonFormField(
                                icon: const Icon(Icons.keyboard_arrow_down),
                                iconSize: 15,
                                decoration: const InputDecoration.collapsed(
                                  hintText: 'Please select your location',
                                  hintStyle: TextStyle(fontSize: 10),
                                ),
                                value: _selectedLocation,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedLocation = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    setState(() {
                                      _showLocationError = true;
                                    });
                                  } else {
                                    setState(() {
                                      _showLocationError = false;
                                    });
                                  }

                                  return null;
                                },
                                items: _locations.map((location) {
                                  return DropdownMenuItem(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: deviceWidth * 0.05,
                                      ),
                                      child: Text(
                                        location,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ),
                                    value: location,
                                  );
                                }).toList(),
                              ),
                            )),
                      ),
                      Visibility(
                          visible: _showLocationError,
                          child: const Text(
                            "Please Select your Location",
                            style: TextStyle(color: Colors.red, fontSize: 10),
                          )),
                      Visibility(
                        visible: _loginAuthMode,
                        child: SizedBox(
                            height: deviceHeight * 0.03,
                            child: GestureDetector(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 5,
                                    right: deviceWidth * 0.1,
                                  ),
                                  child: Text(
                                    'See Details Page',
                                    style: greyMinStyle,
                                  ),
                                ),
                              ),
                              onTap: () {},
                            )),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.06,
                      ),
                      Container(
                        height: deviceHeight * 0.06,
                        width: deviceWidth * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: borderRadiusSize,
                          color: Colors.black,
                        ),
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: borderRadiusSize)),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [Colors.red, Colors.yellow]),
                                borderRadius: borderRadiusSize),
                            child: Container(
                              // width: 00,
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                _loginAuthMode ? 'Log In' : 'Sign Up',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.035,
                      ),
                      SizedBox(
                        height: deviceHeight * 0.03,
                        child: Center(
                          child: _loginAuthMode
                              ? RichText(
                                  text:
                                      TextSpan(style: greyMinStyle, children: [
                                    const TextSpan(
                                      text: 'Don\'t have an account ? ',
                                    ),
                                    TextSpan(
                                      text: ' Register',
                                      style: orangeMinStyle,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          setState(() {
                                            _loginAuthMode = false;
                                          });
                                        },
                                    ),
                                  ]),
                                )
                              : RichText(
                                  text:
                                      TextSpan(style: greyMinStyle, children: [
                                    const TextSpan(
                                      text: 'Have an account ? ',
                                    ),
                                    TextSpan(
                                      text: ' Login',
                                      style: orangeMinStyle,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          setState(() {
                                            _loginAuthMode = true;
                                          });
                                        },
                                    ),
                                  ]),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.04,
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
