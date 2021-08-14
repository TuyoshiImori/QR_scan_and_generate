import 'dart:io';

import 'package:app_review/app_review.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_scan_and_generate/db/input_text_repository.dart';
import 'package:qr_scan_and_generate/main.dart';
import 'package:qr_scan_and_generate/menu_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class QRViewArguments {
  const QRViewArguments({this.qrtype, this.qrdata});
  final String qrtype;
  final String qrdata;
}

class BarcodeViewArguments {
  const BarcodeViewArguments({this.barcodetype, this.barcodedata});
  final String barcodetype;
  final String barcodedata;
}

class ImageQRScanners {
  final picker = ImagePicker();
  final String qrdata2;
  ImageQRScanners({this.qrdata2});
}

var qrScannerViewKey = GlobalKey<_QRCodeScannerViewState>();

class QRCodeScannerView extends StatefulWidget {
  const QRCodeScannerView({Key key}) : super(key: key);

  @override
  _QRCodeScannerViewState createState() => _QRCodeScannerViewState();
}

class _QRCodeScannerViewState extends State<QRCodeScannerView> {

  QRViewController _qrController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _isQRScanned = false;

  // ホットリロードを機能させるには、プラットフォームがAndroidの場合はカメラを一時停止するか、
  // プラットフォームがiOSの場合はカメラを再開する必要がある

  final picker = ImagePicker();
  String _data = '';
  //String currentDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());

  //履歴に送るリスト


  String QRCodeItems = '';


  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrController?.pauseCamera();
    }
    _qrController?.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    QRCodeItems;
  }

  @override
  void dispose() {
    _qrController?.dispose();
    super.dispose();
  }

  void _getPhotoByGallery() {
    Stream.fromFuture(picker.getImage(source: ImageSource.gallery))
        .flatMap((file) {
      setState(() {});
      return Stream.fromFuture(QrCodeToolsPlugin.decodeFrom(file.path));
    }).listen((data) {
      setState(() {
        if (data != null) {
          QRCodeItems = data;
          //CodeType = type;
        }
        if (data != null) {
          InputTextRepository.create(QRCodeItems);
        }
        _data = data;
        if (data != null)
          Navigator.pushNamed(
            context,
            Const.routeImageQRScanner,
            arguments: ImageQRScanners(qrdata2: _data),
          );
        else{
          Navigator.pushNamed(
            context,
            Const.routeNullScanPage,
          );
        }
      });
    }).onError((error, stackTrace) {
      setState(() {
        _data = '';
      });
      print('${error.toString()}');
    });
  }


  //カメラのQRスキャナー
  Widget _buildQRView(BuildContext context) {
    return QRView(
      key: _qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
  }

  void _onQRViewCreated(QRViewController qrController) {
    setState(() {
      _qrController = qrController;
    });
    // QRを読み込みをlistenする
    qrController.scannedDataStream.listen((scanData) {
      // QRのデータが取得出来ない場合SnackBar表示
      if (scanData.code == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('このQRコードにはデータが入っていません'),//QR code data does not exist
          ),
        );
      } else if ('${describeEnum(scanData.format)}' == 'qrcode') {
        _transitionToNextScreen2(describeEnum(scanData.format),
          scanData.code,
        );
      } else {
        // 次の画面へ遷移
        _transitionToNextScreen1(describeEnum(scanData.format),
          scanData.code,
        );
      }
    });
  }

  //Barcode
  Future<void> _transitionToNextScreen1(String type, String data2, ) async {
    if (!_isQRScanned) {
      // カメラを一時停止
      _qrController?.pauseCamera();
      _isQRScanned = true;
      QRCodeItems = data2;
      InputTextRepository.create(QRCodeItems);
      // 次の画面へ遷移
      await Navigator.pushNamed(
        context,
        Const.routeBarcode,
        arguments: BarcodeViewArguments(barcodetype: type, barcodedata: data2),
      ).then(
        // 遷移先画面から戻った場合カメラを再開
            (value) {
          _qrController?.resumeCamera();
          _isQRScanned = false;
        },
      );
    }
  }

  //QR
  Future<void> _transitionToNextScreen2(String type, String data) async {
    if (!_isQRScanned) {
      // カメラを一時停止
      _qrController?.pauseCamera();
      _isQRScanned = true;
      QRCodeItems = data;
      InputTextRepository.create(QRCodeItems);
      // 次の画面へ遷移
      await Navigator.pushNamed(
        context,
        Const.routeQR,
        arguments: QRViewArguments(qrtype: type, qrdata: data),
      ).then(
        // 遷移先画面から戻った場合カメラを再開
            (value) {
          _qrController?.resumeCamera();
          _isQRScanned = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // _checkPermissionState();
    return Scaffold(
      appBar: AppBar(
        title: Text('カメラを起動中'),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
//            style: TextButton.styleFrom(primary: Colors.black,),
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return MenuPage();
            })),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildQRView(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.image),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        label: Text(
          'アルバムからスキャン',
        ),
        onPressed: _getPhotoByGallery,
      ),
    );
  }

}


