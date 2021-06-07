import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:whatsapp_status_saver/screens/saved_view.dart';
import 'package:whatsapp_status_saver/utils.dart';

final Directory _fileDir = Directory(saveFolderPath);

class MySaved extends StatefulWidget {
  @override
  _MySavedState createState() => _MySavedState();
}

class _MySavedState extends State<MySaved> {
  List fileList;

  Future<String> _getImage(videoPathUrl) async {
    final thumb = await Thumbnails.getThumbnail(
        videoFile: videoPathUrl,
        imageType:
            ThumbFormat.PNG, //this image will store in created folderpath
        quality: 10);
    return thumb;
  }

  @override
  void initState() {
    super.initState();
    fileList =
        _fileDir.listSync().map((item) => item.path).toList(growable: false);
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
          'My Saved (${fileList.length})',
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
        ),
      ),
      body: Container(
        child: Directory('${_fileDir.path}').existsSync()
            ? Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                child: AnimationLimiter(
                  child: StaggeredGridView.countBuilder(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: fileList.length,
                    crossAxisCount: 4,
                    itemBuilder: (context, index) {
                      final filePath = fileList[index];
                      return filePath.endsWith(".jpg")
                          ? AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              columnCount: 2,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: Material(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    child: InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SavedViewStatus(
                                                    filePath: filePath),
                                          )),
                                      child: Hero(
                                          tag: filePath,
                                          child: Image.file(
                                            File(filePath),
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              columnCount: 2,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SavedViewStatus(
                                              filePath: filePath),
                                        )),
                                    child: Stack(children: [
                                      ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                                stops: [
                                                  0.1,
                                                  0.3,
                                                  0.5,
                                                  0.7,
                                                  0.9
                                                ],
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
                                                future: _getImage(filePath),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    if (snapshot.hasData) {
                                                      return Hero(
                                                        tag: filePath,
                                                        child: Image.file(
                                                          File(snapshot.data),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      );
                                                    } else {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }
                                                  } else {
                                                    return Hero(
                                                      tag: filePath,
                                                      child: SizedBox(
                                                        height: 280.0,
                                                        child: Image.asset(
                                                            'assets/images/video_loader.gif'),
                                                      ),
                                                    );
                                                  }
                                                }),
                                          )),
                                      Center(
                                          child: Icon(
                                        FontAwesomeIcons.playCircle,
                                        size: 30,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      )),
                                    ]),
                                  ),
                                ),
                              ),
                            );
                    },
                    staggeredTileBuilder: (i) =>
                        StaggeredTile.count(2, i.isEven ? 2 : 3),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                ),
              )
            : Text('No status found'),
      ),
    );
  }
}
