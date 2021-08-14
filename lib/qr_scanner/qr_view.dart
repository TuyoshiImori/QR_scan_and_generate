import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:qr_scan_and_generate/admob.dart';
import 'package:qr_scan_and_generate/qr_scanner/qr_scan_page.dart';
import 'package:qr_scan_and_generate/qr_scanner/url_launch.dart';
import 'package:share/share.dart';


class QRView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final QRViewArguments arguments =
    ModalRoute.of(context).settings.arguments as QRViewArguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('読み取り結果'),
        actions: [
          //Icon(Icons.ios_share),
          IconButton(
            icon: Icon(
              Icons.ios_share,
              color: Colors.blue,
            ),
            onPressed: (){
              Share.share('${arguments.qrdata}');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ListBody(
            children: <Widget> [
              ListTile(
                title: Text(
                  '読み取り内容',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                tileColor: Colors.grey[350],
              ),
              ListTile(
                title: Text(
                  '${arguments.qrdata}',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(
                thickness: 1.0,
              ),
              ListTile(
                title: Text(
                  'Safari・アプリで開く',
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Utils.openLinkBrowser(url: '${arguments.qrdata}');
                },
              ),
              Divider(
                thickness: 1.0,
              ),
              ListTile(
                title: Text(
                  'アプリ内ブラウザで開く',
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Utils.openLinkAppBrowser(url: '${arguments.qrdata}');
                },
              ),
              Divider(
                thickness: 1.0,
              ),
            ]
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          AdmobBanner(
            adUnitId: AdMobService().getBannerAdUnitId(),
            adSize: AdmobBannerSize(
              width: MediaQuery.of(context).size.width.toInt(),
              height: AdMobService().getHeight(context).toInt(),
              name: 'SMART_BANNER',
            ),
          ),
        ],
      ),
    );
  }
}

