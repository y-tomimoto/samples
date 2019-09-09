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

      providers: [

        // In this sample app, CatalogModel never changes, so a simple Provider
        // is sufficient.

        // notifyListeners : その1

        Provider(
            // このbuilderとは一体なんなんだ。
            // CatalogModelクラスに対して何かをしているように見える。
            builder: (context) => CatalogModel()
        ),

        // notifyListeners : その2

        // CartModel is implemented as a ChangeNotifier, which calls for the use
        // of ChangeNotifierProvider. Moreover, CartModel depends
        // on CatalogModel, so a ProxyProvider is needed.

        // これは CatalogModelクラス　と CartModelクラス間で何かをしているようだ

        //これがconsumerになっているぽいぞ。

        // けどこのConsumerはreturnされていない。もしかして変数化されているのか?

        // そういうわけでもない、この形式的にconsumerだと思うのだが、、、
        // てかこれ自体がクラスになっているのか?
        // そうでした、tutorialで伝えてねえのに勝手に使うなよ(怒)
        // > https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProxyProvider-class.html

        // 第一引数に反映させたいクラス、第二引数に反映するためのNotifierが入っている。

        // なるほど学習になる。実は上記の `ChangeNotifierProvider`とやっていることは同じなのか。
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(

            // これもまたbuilderになっている。
            // このとき引数が3種類ある。謎だ。
            // 早速見てみよう。

            // 第2引数、第3引数を渡して、CartModelを実行している。
            builder: (context, catalog, previousCart) =>

                // これはカートモデルを2つの引数を用いて実行しているようだが、、、
                CartModel(catalog, previousCart)

        ),

      ],

      // これは存在してもいいのか?
      // 存在していい。rootとして別に実行されているものになる。
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
