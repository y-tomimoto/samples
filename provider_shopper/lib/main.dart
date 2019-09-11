// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopper/common/theme.dart';
import 'package:provider_shopper/models/cart.dart';
import 'package:provider_shopper/models/catalog.dart';
import 'package:provider_shopper/screens/cart.dart';
import 'package:provider_shopper/screens/catalog.dart';

// ここまではわかるぞ。
void main() {
  runApp(MyApp());
}

// ここはステートレスwidgetになっている。
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // Using MultiProvider is convenient when providing multiple objects.

    // MultiProviderというclassを返している。これは scaffold や MaterialApps と同じクラスだろう。

    // この中でリスナーをいくつも宣言している。
    return MultiProvider(

      providers: [ // ここがroot扱いとなる。いわゆるwrapperだな。

        // In this sample app, CatalogModel never changes, so a simple Provider
        // is sufficient.
        // 多分このProvider自体はクラスとして用意されているもので、自己で定義するものではないのだろう。

        // notifyListeners : その1

        // これはnest内で実行されたchangelistenerを受け取る関数になっている。
        // これを受け取った際にはproviderが実行され、受け取った値を元に別のクラスを構築している。

        // このとき名前は適当でも良いのだろうか?
        // ここについては、変更をlistenしても何も変わらない前提で作成されている。

        // これがListenerになっている?ただ、ChangeNotifierProviderではなく、ただのProviderなんだよな、、、
        // 今回は実際のNotifyListenerは1つだけ。
        // CatalogModelにはChangeNotifierがないけど、一応リスナーを設定しているだけなのだろうか、、、

        // これはlistenerに
        Provider(
            // このbuilderとは一体なんなんだ。
            // CatalogModelクラスに対して何かをしているように見える。
            // これはrebuildを実行している。
            builder: (context) => CatalogModel()
        ),

        // notifyListeners : その2

        // CartModel is implemented as a ChangeNotifier, which calls for the use
        // of ChangeNotifierProvider. Moreover, CartModel depends
        // on CatalogModel, so a ProxyProvider is needed.

        // これは CatalogModelクラス　と CartModelクラス間で何かをしているようだ

        // これがconsumerになっているぽいぞ。

        // けどこのConsumerはreturnされていない。もしかして変数化されているのか?

        // そういうわけでもない、この形式的にconsumerだと思うのだが、、、
        // てかこれ自体がクラスになっているのか?
        // そうでした、tutorialで伝えてねえのに勝手に使うなよ(怒)
        // > https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProxyProvider-class.html

        // 第一引数に反映させたいクラス、第二引数に反映するためのNotifierが入っている。

        // なるほど学習になる。実は上記の `ChangeNotifierProvider`とやっていることは同じなのか。

        // ふつうはlistenerを作成する際は、自身でlistenerクラスを定義して、その中にconsumerクラスを用意する必要がある。
        // しかしそれだと、https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProxyProvider-class.html
        // のようなミスが起きる。

        // ここではまじで何をしてんだ、、、
        // > https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProxyProvider-class.html

        // 他のプロバイダーから取得した値からChangeNotifierを構築および同期するChangeNotifierProvider。

        // これもなんらかのListenerになっていることは間違いないのだが、、
        // これはモデルか?
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(

            // これもまたbuilderになっている。
            // このとき引数が3種類ある。謎だ。
            // 早速見てみよう。

            // 第2引数、第3引数を渡して、CartModelを実行している。

            // 結局作成しているのはCartModelじゃんか。
            // これはCatalogModelのvalueになっている。
            builder: (context, catalog, previousCart) => CartModel(catalog, previousCart)
        ),
      ],

      // なるほど、Provider.of()とconsumerは、上位の値を活用するためのクラスなのね

      // これは存在してもいいのか?
      // 存在していい。rootとして別に実行されているものになる。

      // そしてこれが下位のネストになる。これでこれ以下のディレクトリでは、provider.ofでもconsumerでも値の参照が可能になるというわけだ。
      child: MaterialApp(

        // これは普通のMaterial App

        title: 'Provider Demo',

        theme: appTheme,

        initialRoute: '/',

        // なんだこれ? ルーティングなのか?
        // ああ、これたしかNavigationだ、思い出した。
        routes: {
          '/': (context) => MyCatalog(),
          '/cart': (context) => MyCart(),
        },

      ),
    );
  }
}
