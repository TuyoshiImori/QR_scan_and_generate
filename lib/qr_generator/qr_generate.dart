import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:qr_scan_and_generate/menu_page.dart';

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'utils.dart';



class QRGenerate extends StatefulWidget {
  QRGenerate();

  @override
  _QRGenerateState createState() => _QRGenerateState();
}

class _QRGenerateState extends State<QRGenerate> {
  //QRの画像を作る
  GlobalKey _globalKey = GlobalKey();

  //QRに入れるデータ
  final controller = TextEditingController(text: '');
  final _form = GlobalKey<FormState>();

  //QRに入れる画像
  File _image;
  final picker = ImagePicker();
  final cropper = ImageCropper();
  bool isGallery = true;

  Future _getImage() async {
    //final pickedFile = await picker.getImage(source: ImageSource.camera);//カメラ
    final pickedFile = await Utils.pickMedia(
      isGallery: isGallery,
      cropImage: cropSquareImage,
    );
    //picker.getImage(source: ImageSource.gallery,);//アルバム

    if(pickedFile != null) {
      setState((){
        _image = File(pickedFile.path);
      });
    }
  }

  Future<File> cropSquareImage(File _image) async =>
      await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square],
        compressQuality: 70,
        compressFormat: ImageCompressFormat.jpg,
      );


  void _exportToImage() async {
    // 現在描画されているWidgetを取得する
    RenderRepaintBoundary boundary =
    _globalKey.currentContext.findRenderObject();

    // 取得したWidgetからイメージファイルをキャプチャする
    ui.Image image = await boundary.toImage(
      pixelRatio: 3.0,
    );

    // 以下はお好みで
    // PNG形式化
    ByteData byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    // バイトデータ化
    final _pngBytes = byteData.buffer.asUint8List();
    // BASE64形式化
    final _base64 = base64Encode(_pngBytes);
    print(_base64);
    if(_pngBytes != null) {
      Uint8List _buffer = await _pngBytes;
      final result = await ImageGallerySaver.saveImage(_buffer);
    }
    showDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text('QRを保存しました'),
          content: Text('アルバムで確認できます。'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            )
          ],
        );
      },
    );
  }

  void _controllerNull() {
    showDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text('注意'),
          content: Text('QRのデータが空のままです。\nQRにするデータを入力しましょう。'),
          actions: <Widget>[
            FlatButton(onPressed: () => Navigator.pop(context),
                child: Text('OK'),
            ),
          ],
        );
      }
    );
  }

  void embedded() async{
    if(_image != null) {
      await Image.file(_image).image;
    } else {
      return null;
    }
  }

  //QRの色を変更する
  ThemeData _customTheme = ThemeData(
      primaryColor: Colors.black,
      accentColor: Colors.white,
      backgroundColor: Colors.white,
  );


  Widget _themeColorContainer(String colorName, Color color) {
    return Container(
      width: double.infinity,
      height: 50,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 16),
      color: color,
      child: Text(colorName,
          textAlign: TextAlign.center,
          style: Theme.of(context).primaryTextTheme.button),
    );
  }

  void _openDialog(String title, Color currentColor, bool primaryColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          //contentPadding: EdgeInsets.all(6.0),
          title: Text(title),
          content: Container(
            height: 250,
            child: MaterialColorPicker(
              selectedColor: currentColor,
              colors: fullMaterialColors,
              circleSize: 65.0,
              spacing: 10.0,
              allowShades: false,
              onColorChange: (color) => setState(() => _customTheme =
              (primaryColor)
                  ? _customTheme.copyWith(primaryColor: color)
                  : _customTheme.copyWith(accentColor: color)
              ),
              onMainColorChange: (color) => setState(() => _customTheme =
              (primaryColor)
                  ? _customTheme.copyWith(primaryColor: color)
                  : _customTheme.copyWith(accentColor: color)),
            ),
          ),

          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              isDestructiveAction: true,
              child: Text(
                '決定',
                style: Theme.of(context).textTheme.button,
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CupertinoNavigationBar(
            middle: Text('QRを作成する'),
            leading: CupertinoButton(
              alignment: FractionalOffset.centerLeft,
              padding: EdgeInsets.zero,
              child: Icon(
                CupertinoIcons.left_chevron,
                size: 25,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage(),
                  ),
                );
              },
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: RepaintBoundary(
                        key: _globalKey,
                        child: QrImage(
                          data: controller.text ?? '',
                          size: 250,
                          version: QrVersions.auto,
                          embeddedImage: _image == null
                              ? null
                              : Image.file(_image).image,
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: Size(45,45),
                          ),
                          foregroundColor: _customTheme.primaryColor,
                          backgroundColor: _customTheme.accentColor,
                        ),
                      ),
                    ),
                    Row(
                      key: _form,
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                            decoration: InputDecoration(
                              hintText: '＊QRにするデータを入力',
                              border: OutlineInputBorder(),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () => controller.clear(),
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        FloatingActionButton(
                          backgroundColor: Colors.grey,
                          child: Text('適用'),
                          onPressed: () => setState(() {}),
                          shape: RoundedRectangleBorder(),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                    ListTile(
                      onTap: _getImage,
                      leading: Icon(
                        Icons.photo_camera,
                      ),
                      title: Text('QRにオリジナルの画像を入れる'),
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                    ListTile(
                        leading: Icon(Icons.image_outlined),
                        trailing: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _customTheme.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.black),
                          ),
                        ),
                        title: Text('QRの色を変更する'),
                        onTap: () async {
                          _openDialog(
                            'QRの色を変更する',
                            _customTheme.primaryColor,
                            true,
                          );
                        }
                        ),
                    Divider(
                      thickness: 1.0,
                    ),
                    ListTile(
                        leading: Icon(Icons.image),
                        trailing: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _customTheme.accentColor,
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.black),
                          ),
                        ),
                        title: Text('QRの背景の色を変更する'),
                        onTap: () async {
                          _openDialog(
                            'QRの背景の色を変更する',
                            _customTheme.accentColor,
                            false,
                          );
                        }
                        ),
                    Divider(
                      thickness: 1.0,
                    ),
                    ListTile(
                      title: Text(
                        '＊QRの色を薄い色同士に設定した場合\nうまくスキャンできない可能性があります。',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
                child: Icon(Icons.save_alt),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: controller.text == ''
                  ? _controllerNull
                  : _exportToImage,
            ),
        );
  }
}
