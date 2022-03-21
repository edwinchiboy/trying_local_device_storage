import 'package:flutter/material.dart';
import 'package:testing_storing_device/helper.dart';

class ProfileScreen extends StatefulWidget {
  final String emailAddress;
  final String password;
  final String dOB;
  final String location;
  final String gender;

  const ProfileScreen(
      {Key? key,
      required this.emailAddress,
      required this.password,
      required this.dOB,
      required this.location,
      required this.gender})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? data;
  final bool _isLoading = false;
  Storage storage = Storage();

  @override
  void initState() {
    super.initState();
    storage.readData().then((String value) {
      setState(() {
        data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("User Sign In Details")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
              ),
              height: deviceHeight,
              width: deviceWidth,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(data ?? ' '),
                  ],
                ),
              )),
    );
  }
}
