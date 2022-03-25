import 'package:flutter/material.dart';
import 'package:testing_storing_device/DB_helper2.dart';
import 'package:testing_storing_device/DB_model.dart';

class ViewMoreDetailScreen extends StatefulWidget {
  final int? userDetailId;
  const ViewMoreDetailScreen({
    Key? key,
    required this.userDetailId,
  }) : super(key: key);

  @override
  State<ViewMoreDetailScreen> createState() => _ViewMoreDetailScreenState();
}

class _ViewMoreDetailScreenState extends State<ViewMoreDetailScreen> {
  late DBModel userDetail;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    refreshDetail();
  }

  Future refreshDetail() async {
    setState(() {
      isLoading = true;
    });
    userDetail = await DBHelper2.instance.readDB(widget.userDetailId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('User profile')),
        actions: [
          IconButton(
            onPressed: () async {
              await DBHelper2.instance.delete(widget.userDetailId);
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () async {
              // if (isloading) return;
              // await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LogInScreen(userProfile=)))
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              //color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('User ${userDetail.id} id : ${userDetail.id}'),
                      Text(
                          'User ${userDetail.id} Email:  ${userDetail.userEmail}'),
                      Text(
                          'User ${userDetail.id} password: ${userDetail.userPassword}'),
                      Text('User ${userDetail.id} DOB: ${userDetail.userDOB}'),
                      Text(
                          'User ${userDetail.id} Location: ${userDetail.userLocation}'),
                      Text(
                          'User ${userDetail.id} Gender: ${userDetail.userGender}'),
                    ]),
              )),
    );
  }
}
