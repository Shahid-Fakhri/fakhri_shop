import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import 'cart_screen.dart';

enum FilteOptions {
  Favorates,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorates = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); //won't work use below with future delayed hack or use didchangedependencies
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fakhri Shop"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilteOptions selectedValue) {
              setState(() {
                if (selectedValue == FilteOptions.Favorates) {
                  _showOnlyFavorates = true;
                } else {
                  _showOnlyFavorates = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favorates'), value: FilteOptions.Favorates),
              PopupMenuItem(child: Text('Show All'), value: FilteOptions.All),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, _2) => Badge(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routName);
                },
              ),
              value: cart.itemCount.toString(),
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorates),
    );
  }
}
