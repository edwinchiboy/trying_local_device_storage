import 'package:flutter/material.dart';
import 'package:testing_storing_device/DB_helper2.dart';
import 'package:testing_storing_device/DB_model.dart';
import 'package:testing_storing_device/login.dart';
import 'package:testing_storing_device/view_more_details.dart';

class ReadDataScreen extends StatefulWidget {
  const ReadDataScreen({Key? key}) : super(key: key);

  @override
  State<ReadDataScreen> createState() => _ReadDataScreenState();
}

class _ReadDataScreenState extends State<ReadDataScreen> {
  late List<DBModel> userProfiles;
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
    userProfiles = await DBHelper2.instance.readAllDB();

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('All Registered User ID screen'),
          ),
          body: RefreshIndicator(
            onRefresh: () => refreshData(),
            child: FutureBuilder(
              future: refreshData(),
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : userProfiles.isEmpty
                          ? const Center(
                              child: Text(
                                'No Registered User yet',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : buildUsers(),
            ),
          )),
    );
  }

  Future<bool> onWillPop() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You want to leave the app?'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          FlatButton(
            onPressed: () async {
              await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LogInScreen()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  Widget buildUsers() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: userProfiles.length,
            itemBuilder: (context, i) {
              final userProfile = userProfiles[i];
              // int get userDetailId (DBModel user){
              //    return user.id;

              // }
              return Column(
                children: [
                  InkWell(
                    child: Text(
                      'Click to see more User ${userProfile.id} details',
                      style: const TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewMoreDetailScreen(
                                userDetailId: userProfile.id,
                              )));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () async {
                            await DBHelper2.instance.delete(userProfile.id);
                            setState(() {
                              refreshData();
                            });
                            // await DBHelper2.instance
                            //     .delete(widget..id);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.orange,
                          )),
                      IconButton(
                          onPressed: () async {
                            await Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogInScreen(
                                        userDetail: userProfile,
                                      )),
                              (Route<dynamic> route) => false,
                            );
                            // if (isloading) return;
                            // await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LogInScreen(userProfile=)))
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.orange,
                          ))
                    ],
                  ),
                  const Divider(),
                ],
              );
            }),
      );
}
