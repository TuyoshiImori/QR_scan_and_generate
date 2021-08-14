
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qr_scan_and_generate/qr_scanner/barcode_view.dart';
import 'package:qr_scan_and_generate/qr_scanner/image_qr_scanner.dart';
import 'package:qr_scan_and_generate/qr_scanner/null_scan_page.dart';
import 'package:qr_scan_and_generate/qr_scanner/qr_scan_page.dart';
import 'package:qr_scan_and_generate/qr_scanner/qr_view.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
        runApp(FirstPageView());
      }
  );
}

class FirstPageView extends StatelessWidget {
  FirstPageView({Key key, this.date}) : super();
  final String date;
  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          supportedLocales: [Locale('ja', 'JP')],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate
          ],
          locale: Locale('ja', 'JP'),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor: Colors.white),
          routes: <String, WidgetBuilder>{
            Const.routeBarcode: (BuildContext context) => BarcodeView(),
            Const.routeQRCodeScanner: (BuildContext context) => QRCodeScannerView(),
            Const.routeQR: (BuildContext context) => QRView(),
            Const.routeImageQRScanner: (BuildContext context) => ImageQRScanner(),
            Const.routeNullScanPage: (BuildContext context) => NullScanPage(),
          },
          home: QRCodeScannerView(key: qrScannerViewKey),
        );
  }
}


class Const {
  static const routeBarcode = '/barcode-view';
  static const routeQRCodeScanner = '/qr-code-scanner';
  static const routeQR = '/qr-view';
  static const routeImageQRScanner = '/image-qr-scanner';
  static const routeNullScanPage = '/null-scan';
}

