import 'package:flutter/material.dart';
import 'package:testing_storing_device/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boss Aliyu LogIn Screen Task',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const LogInScreen(),
      // routes: {
      //   '/ProfileScreen':(context) =>  ProfileScreen(emailAddress: ,),
      // }),
    ));
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
