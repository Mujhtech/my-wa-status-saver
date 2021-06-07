import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:whatsapp_status_saver/screens/saved.dart';
import 'package:whatsapp_status_saver/screens/status.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp Screen Saver',
      themeMode: ThemeMode.system,
      theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.white, size: 14),
          backgroundColor: Color(0xFF30BC42),
          textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.black, fontSize: 14, fontFamily: 'Rubik'),
            bodyText1: TextStyle(
                color: Colors.white, fontSize: 14, fontFamily: 'Rubik'),
            bodyText2: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: 'Rubik'),
          )),
      darkTheme: ThemeData(
          iconTheme: IconThemeData(color: Colors.white, size: 14),
          backgroundColor: Color(0xFF30BC42),
          textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.white, fontSize: 14, fontFamily: 'Rubik'),
            bodyText1: TextStyle(
                color: Colors.white, fontSize: 14, fontFamily: 'Rubik'),
            bodyText2: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: 'Rubik'),
          )),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _storagePermissionCheck;
  Future<int> storagePermissionChecker;

  Future<int> checkStoragePermission() async {
    final result = await Permission.storage.status;
    print('Checking Storage Permission ' + result.toString());
    setState(() {
      _storagePermissionCheck = 1;
    });
    if (result.isDenied) {
      return 0;
    } else if (result.isGranted) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> checkPermisson() async {
    int storagePermissionCheckInt;
    int finalPermission;

    print('Initial Values of $_storagePermissionCheck');
    if (_storagePermissionCheck == null || _storagePermissionCheck == 0) {
      _storagePermissionCheck = await checkStoragePermission();
    } else {
      _storagePermissionCheck = 1;
    }
    if (_storagePermissionCheck == 1) {
      storagePermissionCheckInt = 1;
    } else {
      storagePermissionCheckInt = 0;
    }

    if (storagePermissionCheckInt == 1) {
      finalPermission = 1;
    } else {
      finalPermission = 0;
    }

    return finalPermission;
  }

  Future<int> requestStoragePermission() async {
    final result = await [Permission.storage].request();
    print(result);
    setState(() {});
    if (result[Permission.storage].isDenied) {
      return 0;
    } else if (result[Permission.storage].isGranted) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            'My WA Status Saver',
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage("assets/images/bg.jpg"),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(),
              Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 200,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Status',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 18),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Saver',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 18, color: Color(0xFF30BC42)),
                      )
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (await checkPermisson() == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyStatus()));
                      } else if (await requestStoragePermission() == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyStatus()));
                      } else {}
                    },
                    child: Container(
                      height: 100,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Theme.of(context).iconTheme.color,
                            size: 30,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'My Status',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (await checkPermisson() == 1) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MySaved()));
                      } else if (await requestStoragePermission() == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyStatus()));
                      } else {}
                    },
                    child: Container(
                      height: 100,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.save,
                            color: Theme.of(context).iconTheme.color,
                            size: 30,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'My Saved',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Share.share(
                          "Hey! I've been using My Whatsapp Status Saver to save and share my status on Whatsapp. \n You should totally try it out too it's free \n https://mujh.tech");
                    },
                    child: Container(
                      height: 100,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.shareSquare,
                            color: Theme.of(context).iconTheme.color,
                            size: 30,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Share',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
