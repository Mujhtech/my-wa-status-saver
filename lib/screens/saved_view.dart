import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_status_saver/screens/video_player.dart';

class SavedViewStatus extends StatefulWidget {
  final String filePath;
  SavedViewStatus({@required this.filePath});
  @override
  _SavedViewStatusState createState() => _SavedViewStatusState();
}

class _SavedViewStatusState extends State<SavedViewStatus> {
  Future<String> _getImage(videoPathUrl) async {
    final thumb = await Thumbnails.getThumbnail(
        videoFile: videoPathUrl,
        imageType:
            ThumbFormat.PNG, //this image will store in created folderpath
        quality: 10);
    return thumb;
  }

  Future<bool> deleteFile(imgPath) async {
    try {
      await File(imgPath).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  void _onLoading(String file) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Container(
                  height: 400,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                      image: FileImage(File(file)),
                      fit: BoxFit.contain,
                    ),
                  ),
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _onPlaying() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                      image: FileImage(File(widget.filePath)),
                      fit: BoxFit.contain,
                    ),
                  ),
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      VideoPlayerBox(
                          videoPlayerController:
                              VideoPlayerController.file(File(widget.filePath)),
                          looping: true,
                          videoSrc: widget.filePath),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.keyboard_arrow_left,
              size: 30, color: Theme.of(context).iconTheme.color),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          'Preview',
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          widget.filePath.endsWith(".jpg")
              ? GestureDetector(
                  onTap: () {
                    _onLoading(widget.filePath);
                  },
                  child: Container(
                    height: 400,
                    width: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(widget.filePath)),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    _onPlaying();
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        height: 400,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [0.1, 0.3, 0.5, 0.7, 0.9],
                            colors: [
                              Color(0xffb7d8cf),
                              Color(0xffb7d8cf),
                              Color(0xffb7d8cf),
                              Color(0xffb7d8cf),
                              Color(0xffb7d8cf),
                            ],
                          ),
                        ),
                        child: FutureBuilder(
                            future: _getImage(widget.filePath),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return Hero(
                                    tag: widget.filePath,
                                    child: Image.file(
                                      File(snapshot.data),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              } else {
                                return Hero(
                                  tag: widget.filePath,
                                  child: SizedBox(
                                    height: 280.0,
                                    child: Image.asset(
                                        'assets/images/video_loader.gif'),
                                  ),
                                );
                              }
                            }),
                      ),
                      Center(
                          child: Icon(
                        FontAwesomeIcons.playCircle,
                        size: 30,
                        color: Theme.of(context).iconTheme.color,
                      )),
                    ],
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () async {
                  Share.shareFiles([widget.filePath],
                      text: 'My WA Status Saver');
                },
                child: Container(
                  height: 100,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.blue,
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
              ),
              GestureDetector(
                onTap: () async {
                  if (await deleteFile(widget.filePath)) {
                    Fluttertoast.showToast(
                        msg: "Deleted...",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.black,
                        fontSize: 16.0);
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  height: 100,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.trashAlt,
                        color: Theme.of(context).iconTheme.color,
                        size: 30,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Delete',
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
    );
  }
}
