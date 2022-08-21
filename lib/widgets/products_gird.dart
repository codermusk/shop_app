import 'package:flutter/material.dart';
import '../providers/product_provider.dart';
import '../widgets/Productitem.dart';

import 'package:provider/provider.dart';

class products_grid extends StatelessWidget {
 final  bool showfavs ;

  products_grid(this.showfavs);


  @override
  Widget build(BuildContext context) {
    final ProductData = Provider.of<Products>(context);
    final product = showfavs  ? ProductData.favourites :  ProductData.items;

    return GridView.builder(
        itemCount: product.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10),
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            value: product[i],
            child: productItem(
                // product[i].id, product[i].title, product[i].imageUrl)
                )));
  }
}
