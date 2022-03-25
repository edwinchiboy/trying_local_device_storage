import 'package:flutter/material.dart';
import 'package:testing_storing_device/DB_helper2.dart';
import 'package:testing_storing_device/DB_model.dart';
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
    return userProfiles = await DBHelper2.instance.readAllDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('MY screen')),
        ),
        body: FutureBuilder(
            future: refreshData(),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: () => refreshData(),
                        child: userProfiles.isEmpty
                            ? const Center(
                                child: Text(
                                  'No Registered User yet',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            : buildUsers(),
                      )));
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
                      style: TextStyle(color: Colors.red),
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
                            // await DBHelper2.instance
                            //     .delete(widget..id);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.orange,
                          )),
                      IconButton(
                          onPressed: () async {
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
