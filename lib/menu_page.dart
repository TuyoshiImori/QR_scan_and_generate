
import 'package:admob_flutter/admob_flutter.dart';
import 'package:app_review/app_review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_scan_and_generate/admob.dart';
import 'package:qr_scan_and_generate/history_page.dart';
import 'package:qr_scan_and_generate/qr_generator/qr_generate.dart';
import 'package:qr_scan_and_generate/qr_scanner/qr_scan_page.dart';
import 'package:qr_scan_and_generate/qr_scanner/url_launch.dart';
import 'package:url_launcher/url_launcher.dart';


class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}
//1351179121402011651
class _MenuPageState extends State<MenuPage> {
  //開発者のTwitter
  _launchInTwitter() async {
    String twitter_url = 'twitter://user?id=1351179121402011651';
    if (await canLaunch(twitter_url)) {
      await launch(twitter_url);
    }
    else {
      throw 'このTwitterアカウントは存在しません';
    }
  }


  //開発者のinstagram
  _launchInInstagram() async {
    String instagram_url = 'https://www.instagram.com/imorin_0729';
    if (await canLaunch(instagram_url)) {
      await launch(
        instagram_url,
        forceSafariVC: false,//iOSでアプリ内かブラウザのどちらかでURLを開くか決める。
        forceWebView: false,//Androidでアプリ内かブラウザのどちらかでURLを開くか決める。
        universalLinksOnly: true,
      );
    }
    else {
      throw 'このinstagramアカウントは存在しません';
    }
  }


  @override
  Widget build(BuildContext context) {
    //final theme = Provider.of<AppTheme>(context);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('メニュー'),
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
              MaterialPageRoute(builder: (context) => QRCodeScannerView(),
              ),
            );
          },
        ),
      ),
      body: CupertinoScrollbar(
        child: ListView(
          children: <Widget>[

            ListTile(
              leading: Icon(Icons.article_outlined),
              title: Text('履歴'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryPage()),
                );
              },
            ),
            Divider(
              thickness: 1.0,
            ),
            ListTile(
              leading: Icon(Icons.qr_code),
              title: Text('QRを作成する'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRGenerate()),
                );
              },
            ),
            Divider(
              thickness: 1.0,
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('設定を確認する'),
              onTap: () async {
                openAppSettings();
              },
            ),
            Divider(
              thickness: 1.0,
            ),
            ListTile(
              leading: Icon(MaterialCommunityIcons.twitter),
              title: Text('お問い合わせ（Twitter）'),
              onTap: () {
                //Utils.openLinkBrowser(url: 'https://twitter.com/imorin_basson');
                _launchInTwitter();
                },
            ),
            Divider(
              thickness: 1.0,
            ),
            ListTile(
              leading: Icon(MaterialCommunityIcons.instagram),
              title: Text('お問い合わせ（Instagram）'),
              onTap: () {
                //Utils.openLinkBrowser(url: 'https://twitter.com/imorin_basson');
                _launchInInstagram();
              },
            ),
            Divider(
              thickness: 1.0,
            ),
            //ListTile(
              //leading: Icon(MaterialCommunityIcons.instagram),
              //title: Text('開発者（Instagram）'),
              //onTap: () {
               // _launchInInstagram();
              //},
           // ),
            //Divider(thickness: 1.0,),
            new ListTile(
              leading: Icon(Icons.star),
              title: const Text('評価'),
              onTap: () {
                AppReview.requestReview.then((context) {});
              },
            ),
            Divider(
              thickness: 1.0,
            ),
            ListTile(
              title: Text('利用規約・プライバシーポリシー'),
              onTap: () {
                Utils.openLinkAppBrowser(url: 'https://qr-scan-and-generate.web.app');
              },
            ),
            Divider(
              thickness: 1.0,
            ),
          ],
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