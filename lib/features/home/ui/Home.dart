import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginbloc/features/cart/ui/cart.dart';
import 'package:loginbloc/features/home/bloc/home_bloc.dart';
import 'package:loginbloc/features/home/models/home_product_data_model.dart';
import 'package:loginbloc/features/home/ui/product_list.dart';
import 'package:loginbloc/features/wishlist/ui/wishlist.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final String title;
  const Home({super.key, required this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    homeBloc.add(HomeInitialEvent());
    getData();
  }

  final HomeBloc homeBloc = HomeBloc();
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  Future getData() async {
    var response = await http.get(Uri.parse(url));
    var data;
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      //print(jsonMap);
      print(jsonMap['pokemon'][0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listenWhen: (previous, current) => current is HomeActionState,
        buildWhen: (previous, current) => current is! HomeActionState,
        listener: (context, state) {
          if (state is HOmeNavigateToCartPageActionState) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const Cart();
            }));
          } else if (state is HomeNavigateToWishListPageActionState) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const Wishlist();
            }));
          } else if (state is HomeProductItemAddedToCart) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Item added to cart")));
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case HomeLoadingState:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case HomeLoadedSuccessState:
              final successState = state as HomeLoadedSuccessState;
              return Scaffold(
                appBar: AppBar(
                  title: Text(widget.title),
                  actions: [
                    IconButton(
                        onPressed: () {
                          homeBloc.add(HomeCartButtonNavigateEvent());
                        },
                        icon: const Icon(Icons.shopping_cart_outlined)),
                    IconButton(
                        onPressed: () {
                          homeBloc.add(HomeWhislistButtonNavigateEvent());
                        },
                        icon: const Icon(Icons.favorite_border))
                  ],
                ),
                body: ListView.builder(
                    itemCount: successState.products.length,
                    itemBuilder: (context, index) {
                      return ProductList(
                        product: successState.products[index],
                        homeBloc: homeBloc,
                      );
                    }),
              );
            case HomeErrorState:
              return const Scaffold(
                body: Center(
                  child: Text('error has occured'),
                ),
              );
            default:
              return SizedBox();
          }
        });
  }
}
