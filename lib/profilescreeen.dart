import 'package:flutter/material.dart';
import 'package:testing_storing_device/DB_helper.dart';
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
  // Storage storage = Storage();

  // @override
  // void initState() {
  //   super.initState();
  //   storage.readData().then((String value) {
  //     setState(() {
  //       data = value;
  //     });
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                    FlatButton(
                      onPressed: () async {
                        int i = await DataBaseHelper.instance.insert({
                          DataBaseHelper.columnUserEmail: 'choboy@gmail.com',
                          // DataBaseHelper.columnUserPassword: '08060877-41',
                          // DataBaseHelper.columnUserGender: 'Male',
                          // DataBaseHelper.columnUserLocation: 'Abuja',
                        });
                        print('The inserted id is $i');
                      },
                      child: const Text('Insert'),
                    ),
                    FlatButton(
                      onPressed: () async {
                        List<Map<String, dynamic>> queryRows =
                            await DataBaseHelper.instance.queryAll();
                        print(queryRows);
                      },
                      child: const Text('Query'),
                    ),
                    FlatButton(
                      onPressed: () async {
                        int updatedId = await DataBaseHelper.instance.update({
                          DataBaseHelper.columnId: 12,
                          DataBaseHelper.columnUserEmail: 'Chiboy@gmail'
                        });
                        print(updatedId);
                      },
                      child: const Text('Update'),
                    ),
                    FlatButton(
                      onPressed: () async {
                        int rowaEffected =
                            await DataBaseHelper.instance.delete(13);
                        print(rowaEffected);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              )),
    );
  }
}
