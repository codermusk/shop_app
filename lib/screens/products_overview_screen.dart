import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../widgets/Productitem.dart';
import '../widgets/products_gird.dart';
import '../widgets/badge.dart';

enum filterOptions {
  favourites,
  all,
}

class productOverview extends StatefulWidget {
  const productOverview({Key? key}) : super(key: key);

  @override
  State<productOverview> createState() => _productOverviewState();
}

class _productOverviewState extends State<productOverview> {
  var ShowisFavourites = false;
  var isInit = true;

  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    //   Future.delayed(Duration.zero).then((_) =>     Provider.of<Products>(context).getsetProduct();)
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).getsetProduct().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (filterOptions selectedVal) {
              setState(() {
                if (selectedVal == filterOptions.favourites) {
                  ShowisFavourites = true;
                } else {
                  ShowisFavourites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('YourFavourites'),
                value: filterOptions.favourites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: filterOptions.all,
              )
            ],
            icon: Icon(Icons.unfold_more_outlined),
          ),
          Consumer<Cart>(
            builder: (ctx, cart, child) => Badge(
              child: child!,
              value: cart.cartcount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(cartScreen.route);
              },
            ),
          )
        ],
        title: Text('SHOP APP'),
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : products_grid(ShowisFavourites),
    );
  }
}
