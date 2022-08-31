import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product.dart';
import 'package:shop_app/widgets/user_productItem.dart';
import '../providers/product_provider.dart';
import '../widgets/app_drawer.dart';

class userProducts extends StatelessWidget {
  const userProducts({Key? key}) : super(key: key);
  static const route = '/user_products';

  Future<void> _refreshproducyts(BuildContext context) async {
    Provider.of<Products>(context, listen: false).getsetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('YOUR PRODUCTS'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(editProductScreen.route);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshproducyts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshproducyts(context),
                    child: Consumer<Products>(
                      builder: (context, value, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Column(
                            children: [
                              userProductItem(
                                  productData.items[i].id.toString(),
                                  productData.items[i].title,
                                  productData.items[i].imageUrl),
                              Divider(),
                            ],
                          ),
                          itemCount: productData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
