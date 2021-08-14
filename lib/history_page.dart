import 'dart:io';

import 'package:app_review/app_review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:qr_scan_and_generate/db/input_text_repository.dart';
import 'package:qr_scan_and_generate/qr_scanner/url_launch.dart';
import 'package:share/share.dart';

import '../model/input_text.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      AppReview.requestReview.then((onValue){
        print(onValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      future: InputTextRepository.getAll(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Text('');
          default:
            if (snapshot.hasError)
              return Text('エラー: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('履歴'),
      ),
      body: futureBuilder,

    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<InputText> inputTextList = snapshot.data;
    return Scrollbar(
      child: ListView.builder(
        itemCount: inputTextList != null ? inputTextList.length : 0,
        itemBuilder: (BuildContext context, int index) {
          InputText inputText = inputTextList[index];
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(inputText.getBody),
                subtitle: Text(
                  DateFormat('yyyy/MM/dd HH:mm:ss').format(inputText.getUpdatedAt),
                ),
                trailing: IconButton(
                  icon: Icon(
                    MaterialCommunityIcons.trash_can_outline,
                    color: Colors.red,
                  ),
                  tooltip: '削除',
                  onPressed: (){
                    setState(() {
                      InputTextRepository.delete(inputText.id);
                    });
                  },
                ),
                onTap: ((){
                  //qrの検索
                  if (inputText.getBody.contains('http')) {
                    return showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                        title: Text('検索方法'),
                        //message: Text(''),
                        actions: [
                          CupertinoActionSheetAction(
                              onPressed: (){
                                Utils.openLinkBrowser(url:'${inputText.getBody}');
                              },
                              child: Text('safari・アプリで開く')
                          ),
                          CupertinoActionSheetAction(
                              onPressed: (){
                                Utils.openLinkAppBrowser(url:'${inputText.getBody}');
                              },
                              child: Text('アプリ内ブラウザで開く')
                          ),
                          CupertinoActionSheetAction(
                            onPressed: (){
                              Share.share(inputText.getBody);
                            },
                            child: Text('コピー・シェアする'),
                          )
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text('キャンセル'),
                          isDefaultAction: true,
                          onPressed: (){
                            Navigator.pop(context, 'Cancel');
                          },
                        ),
                      ),
                    );
                  } else if (inputText.getBody.length == 13 || inputText.getBody.length == 8){
                    //バーコードの検索
                    return showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                        title: Text('検索方法'),
                        //message: Text(''),
                        actions: [
                          CupertinoActionSheetAction(
                              onPressed: (){
                                //Utils.openLinkBrowser(url:'${inputText.getBody}');
                                Utils.openLinkBrowser(url: 'https://www.google.co.jp/search?q=${inputText.getBody}&gws_rd=ssl');
                              },
                              child: Text('google')
                          ),
                          CupertinoActionSheetAction(
                              onPressed: (){
                                Utils.openLinkBrowser(url: 'https://amazon.co.jp/s?k=${inputText.getBody}&ref=nb_sb_noss');
                              },
                              child: Text('Amazon')
                          ),
                          CupertinoActionSheetAction(
                              onPressed: (){
                                Utils.openLinkBrowser(url: 'https://search.rakuten.co.jp/search/mall/${inputText.getBody}/');
                              },
                              child: Text('楽天市場')
                          ),
                          CupertinoActionSheetAction(
                              onPressed: (){
                                Utils.openLinkAppBrowser(url:'${inputText.getBody}');
                                Utils.openLinkBrowser(url: 'https://shopping.yahoo.co.jp/search?p=${inputText.getBody}&type=all&tab_ex=commerce&fr=shp-prop&first=1&cid=&sc_i=shp_sp_top_searchBox&mcr=');

                              },
                              child: Text('Yahooショッピング')
                          ),
                          CupertinoActionSheetAction(
                              onPressed: (){
                                Utils.openLinkBrowser(url: 'https://paypaymall.yahoo.co.jp/search?p=${inputText.getBody}&cid=&brandid=&kspec=&catopn=&b=1');
                              },
                              child: Text('PayPayモール')
                          ),
                          CupertinoActionSheetAction(
                            onPressed: (){
                              Share.share(inputText.getBody);
                            },
                            child: Text('コピー・シェアする'),
                          )
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text('キャンセル'),
                          isDefaultAction: true,
                          onPressed: (){
                            Navigator.pop(context, 'Cancel');
                          },
                        ),
                      ),
                    );
                  } else {

                  }
                }
                ),
              ),
              Divider(height: 1.0),
            ],
          );
        },
      ),
    );
  }
}


