import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Utils {
  static Future openLinkAppBrowser({
    //アプリ内ブラウザで開く
    @required String url,
  }) =>
      _launchUrlAppBrowser(url);

  static Future _launchUrlAppBrowser(String url) async {
    String encode = Uri.encodeFull(url);
    if (await canLaunch(encode)) {
      await launch(
        encode,
        forceSafariVC: true,//iOSでアプリ内かブラウザのどちらかでURLを開くか決める。
        forceWebView: true,//Androidでアプリ内かブラウザのどちらかでURLを開くか決める。
        universalLinksOnly: true,
      );
    }
  }

  static Future openLinkBrowser({
    //ブラウザで開く
    @required String url,
  }) =>
      _launchUrlBrowser(url);

  static Future _launchUrlBrowser(String url) async {
    String _encode = Uri.encodeFull(url);
    if (await canLaunch(_encode)) {
      await launch(
        _encode,
        forceSafariVC: false,//iOSでアプリ内かブラウザのどちらかでURLを開くか決める。
        forceWebView: false,//Androidでアプリ内かブラウザのどちらかでURLを開くか決める。
        universalLinksOnly: false,
      );
    }
  }
}