import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:human_generator/screens/drawing.dart';
import 'package:human_generator/services/Api.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DrawingArea?> points = [];
  Widget imageOutPut = Container();

  void saveToImage(
      List<DrawingArea?> points, double width, double height) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(
        Offset(0, 0),
        Offset(200, 200),
      ),
    );
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..color = Colors.white
      ..strokeWidth = 2.0;

    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint2);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!.point, points[i + 1]!.point, paint);
      }
    }
    final picture = recorder.endRecording();
    final img =
        await picture.toImage((width).toInt(), (height * .5).toInt());

    final pngBytes = await img.toByteData(format: ImageByteFormat.png);
    final listBytes = Uint8List.view(pngBytes!.buffer);

    String base64 = base64Encode(listBytes);

    ApiProvider().getImage({'Image': base64}).then((response) {
      print(response['Image']);
      String bytes = response['Image'];
      bytes = bytes.substring(2, bytes.length - 1);
      displayImage(bytes, width, height);
    });
  }

  void displayImage(String bytes, double width, double height) async {
    Uint8List convertedBytes = await base64Decode(bytes);
    setState(() {
      imageOutPut = Container(
        height: width * .8,
        width: width * .8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: Offset(10, 10),
              blurRadius: 6,
              color: Colors.black.withOpacity(0.4),
            ),
          ],
        ),
        child: Image.memory(
          convertedBytes,
          fit: BoxFit.cover,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(220, 221, 26, 118),
                Color.fromARGB(220, 123, 25, 172)
              ],
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.width * .8,
                  width: size.width * .8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(10, 10),
                        blurRadius: 6,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onPanDown: (details) {
                      this.setState(() {
                        points.add(
                          DrawingArea(
                              point: details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = Colors.white
                                ..strokeWidth = 2.0),
                        );
                      });
                    },
                    onPanUpdate: (details) {
                      this.setState(() {
                        points.add(
                          DrawingArea(
                              point: details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = Colors.white
                                ..strokeWidth = 2.0),
                        );
                      });
                    },
                    onPanEnd: (details) {
                      saveToImage(points, size.width * .8, size.height * .8);
                      this.setState(() {
                        points.add(null);
                      });
                    },
                    child: SizedBox.expand(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CustomPaint(
                          painter: MyCustomPainter(points: points),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: size.width * .05, horizontal: size.width * .11),
                child: Container(
                  height: size.width * .1,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.6),
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.clear_all),
                    onPressed: () {
                      this.setState(() {
                        points.clear();
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: imageOutPut,
              )
            ],
          ),
        )
      ],
    ));
  }
}
