import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:qr_scan_and_generate/admob.dart';
import 'package:qr_scan_and_generate/qr_scanner/qr_scan_page.dart';
import 'package:qr_scan_and_generate/qr_scanner/url_launch.dart';
import 'package:share/share.dart';


class BarcodeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final BarcodeViewArguments arguments =
    ModalRoute.of(context).settings.arguments as BarcodeViewArguments;

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
              Share.share('${arguments.barcodedata}');
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
                  '${arguments.barcodedata}',
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
                  'google',
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Utils.openLinkBrowser(url: 'https://www.google.co.jp/search?q=${arguments.barcodedata}&gws_rd=ssl');
                },
              ),
              Divider(
                thickness: 1.0,
              ),
              ListTile(
                title: Text(
                  'Amazon',
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Utils.openLinkBrowser(url: 'https://amazon.co.jp/s?k=${arguments.barcodedata}&ref=nb_sb_noss');
                },
              ),
              Divider(
                thickness: 1.0,
              ),
              ListTile(
                title: Text(
                  '楽天市場',
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Utils.openLinkBrowser(url: 'https://search.rakuten.co.jp/search/mall/${arguments.barcodedata}/');
                },
              ),
              Divider(
                thickness: 1.0,
              ),
              ListTile(
                title: Text(
                  'Yahooショッピング',
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Utils.openLinkBrowser(url: 'https://shopping.yahoo.co.jp/search?p=${arguments.barcodedata}&type=all&tab_ex=commerce&fr=shp-prop&first=1&cid=&sc_i=shp_sp_top_searchBox&mcr=');
                },
              ),
              Divider(
                thickness: 1.0,
              ),
              ListTile(
                title: Text(
                  'PayPayモール',
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Utils.openLinkBrowser(url: 'https://paypaymall.yahoo.co.jp/search?p=${arguments.barcodedata}&cid=&brandid=&kspec=&catopn=&b=1');
                },
              ),
              Divider(
                thickness: 1.0,
              ),
              SizedBox(
                height: 100,
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
