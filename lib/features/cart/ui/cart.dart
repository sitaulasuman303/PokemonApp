import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginbloc/features/cart/bloc/cart_bloc.dart';
import 'package:loginbloc/features/cart/ui/CartList.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final CartBloc cartBloc = CartBloc();
  @override
  void initState() {
    super.initState();
    cartBloc.add(CartInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      bloc: cartBloc,
      listenWhen: (previous, current) => current is CartActionState,
      buildWhen: (previous, current) => current is! CartActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case CartLoading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case CartLoadedSuccessfully:
            final successState = state as CartLoadedSuccessfully;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Cart Page'),
              ),
              body: ListView.builder(
                  itemCount: successState.cartProducts.length,
                  itemBuilder: (context, index) {
                    return CartList(
                      product: successState.cartProducts[index],
                      cartBloc: cartBloc,
                    );
                  }),
            );
          case CartError:
            return (const Center(
              child: Text('Error has occured'),
            ));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
