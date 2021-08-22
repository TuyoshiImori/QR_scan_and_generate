import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:qr_scan_and_generate/admob.dart';
import 'package:qr_scan_and_generate/qr_scanner/qr_scan_page.dart';
import 'package:url_launcher/url_launcher.dart';

class NullScanPage extends StatefulWidget {
  @override
  _NullScanPageState createState() => _NullScanPageState();
}

class _NullScanPageState extends State<NullScanPage> {
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

  //お問い合わせ
  String attachment;

  final _recipientController = TextEditingController(
    text: 'qrsgapps@gmail.com',
  );

  final _subjectController = TextEditingController(text: '[QRコード読み取り・作成アプリ]QRを読み取れなかったことに関するメール');

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('検索結果'),
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
      body: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            ListTile(
              title: Text('QRコードを検出できませんでした。'),
            ),
            Divider(
              thickness: 1.0,
            ),
          ],
        ),
      ),
    );
  }
}
