part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

sealed class CartActionState extends CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoadedSuccessfully extends CartState {
  final List<ProductDataModel> cartProducts;
  CartLoadedSuccessfully({required this.cartProducts});
}

final class CartError extends CartState {}
