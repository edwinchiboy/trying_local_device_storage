import 'package:flutter/material.dart';
import 'package:testing_storing_device/DB_helper2.dart';
import 'package:testing_storing_device/DB_model.dart';

class ReadDataScreen extends StatefulWidget {
  const ReadDataScreen({Key? key}) : super(key: key);

  @override
  State<ReadDataScreen> createState() => _ReadDataScreenState();
}

class _ReadDataScreenState extends State<ReadDataScreen> {
  late List<DBModel> userProfiles;
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  void dispose() {
    DBHelper2.instance.close();

    super.dispose();
  }

  Future refreshData() async {
    setState(() => isloading = true);
    userProfiles = await DBHelper2.instance.readAllDB();
    setState(() => isloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY screen'),
      ),
      body: Center(
        child: isloading
            ? const CircularProgressIndicator()
            : userProfiles.isEmpty
                ? const Text(
                    'No Registered User yet',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                    ),
                  )
                : buildUsers(),
      ),
    );
  }

  Widget buildUsers() => ListView.builder(
      itemCount: userProfiles.length,
      itemBuilder: (context, i) => Column(
            children: [
              Text('${userProfiles[i].id}'),
              Text('${userProfiles[i].id}'),
              Text(userProfiles[i].userEmail),
              Text('${userProfiles[i].userDOB}'),
              Text(userProfiles[i].userLocation),
              Text(userProfiles[i].userPassword),
              Text(userProfiles[i].userGender),
              const Divider(),
            ],
          ));
}
