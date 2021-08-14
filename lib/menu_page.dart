import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_scan_and_generate/admob.dart';
import 'package:qr_scan_and_generate/history_page.dart';
import 'package:qr_scan_and_generate/qr_generator/qr_generate.dart';
import 'package:qr_scan_and_generate/qr_scanner/url_launch.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override

  //お問い合わせ
  String attachment;

  final _recipientController = TextEditingController(
    text: 'qrsgapps@gmail.com',
  );

  final _subjectController = TextEditingController(text: '[QRコード読み取り・作成アプリ]お問い合わせ');

  final _bodyController = TextEditingController(
    text: '----------\n件名を変えずにご送信お願いします。\n----------',
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  //開発者のTwitter
  _launchInTwitter() async {
    const url = 'https://twitter.com/imorin_basson';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,//iOSでアプリ内かブラウザのどちらかでURLを開くか決める。
        forceWebView: false,//Androidでアプリ内かブラウザのどちらかでURLを開くか決める。
        universalLinksOnly: true,
      );
    }
    else {
      throw 'このTwitterアカウントは存在しません';
    }
  }

  //開発者のinstagram
  _launchInInstagram() async {
    const url = 'https://www.instagram.com/iiyotu1142';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,//iOSでアプリ内かブラウザのどちらかでURLを開くか決める。
        forceWebView: false,//Androidでアプリ内かブラウザのどちらかでURLを開くか決める。
        universalLinksOnly: true,
      );
    }
    else {
      throw 'このTwitterアカウントは存在しません';
    }
  }


  @override
  Widget build(BuildContext context) {
    //final theme = Provider.of<AppTheme>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('メニュー'),
      ),
      body: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Divider(
              thickness: 1.0,
            ),
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
              leading: Icon(Icons.mail),
              title: Text('お問い合わせ'),
              trailing: Text('ご意見・ご要望など'),
              onTap: send,
            ),
            Divider(
              thickness: 1.0,
            ),
            ListTile(
                leading: Icon(MaterialCommunityIcons.twitter),
                title: Text('開発者（Twitter）'),
                onTap: () {
                  _launchInTwitter();
                }
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