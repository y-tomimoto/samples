// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopper/models/cart.dart';

class MyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: Theme.of(context).textTheme.display4),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.yellow,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _CartList(),
              ),
            ),
            Divider(height: 4, color: Colors.black),
            _CartTotal()
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.title;

    // お、ここで引き出しているやないか、、、
    // しかも、これどういう記法だこの野郎。
    // この記法を用いて、全て参照可能?
    // ここに対してはあるのか。
    var cart = Provider.of<CartModel>(context);

    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.done),
        title: Text(
          cart.items[index].name,
          style: itemNameStyle,
        ),
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hugeStyle = Theme.of(context).textTheme.display4.copyWith(fontSize: 48);

    return SizedBox(
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ここにConsumerがあるな、これはbuild実行時に参照されるものぽいな。
            // stateを消費するイメージだろうか。
            // リスナーが発火したら、そのroot下全てのクラスでconsumeできるようになるぽいな。
            // consumer自体がどこにあるのか、、、そもそもあのlistを表示する最後のアウトプットの部分はどうなっているのか。

            //多分ここがdart
            Consumer<CartModel>(
                builder: (context, cart, child) =>
                    // これが実際に引き出しているところになっているぽいぞ。
                    // しかしこれはtotalPlace、つまり別のところにまだありそうだぜ。
                    Text('\$${cart.totalPrice}', style: hugeStyle)),
            SizedBox(width: 24),
            FlatButton(
              onPressed: () {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Buying not supported yet.')));
              },
              color: Colors.white,
              child: Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}
