import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:loginbloc/data/cart_items.dart';
import 'package:loginbloc/data/grocery_data.dart';
import 'package:loginbloc/features/home/models/home_product_data_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeProductWhislistButtonClickedEvent>(
        homeProductWishListButtonClickedEvent);
    on<HomeProductCartButtonClickedEvent>(homeProductCartButtonClickedEvent);
    on<HomeWhislistButtonNavigateEvent>(homeNavigateToWishListPageActionState);
    on<HomeCartButtonNavigateEvent>(homeCartButtonNavigateEvent);
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    await Future.delayed(const Duration(seconds: 3));
    var url =
        "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
    var data;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      data = json.decode(jsonString);
      //print(jsonMap);
      print(data['pokemon'][0]);
    }
    if (data != null && data['pokemon'] is List) {
      final List<dynamic> pokeList = data['pokemon'];
      final List<ProductDataModel> products = pokeList.map((item) {
        return ProductDataModel(
          id: item['id'],
          name: item['name'],
          description: item['name'],
          price: double.tryParse(item['spawn_chance'].toString()) ?? 0.0,
          imageUrl: item['img'],
        );
      }).toList();
      emit(HomeLoadedSuccessState(products: products));
    }
  }

  FutureOr<void> homeProductWishListButtonClickedEvent(
      HomeProductWhislistButtonClickedEvent event, Emitter<HomeState> emit) {
    print('wish list item clicked');
  }

  FutureOr<void> homeProductCartButtonClickedEvent(
      HomeProductCartButtonClickedEvent event, Emitter<HomeState> emit) {
    print('cart button clicked');
    cartProducts.add(event.clickedProduct);
    emit(HomeProductItemAddedToCart());
  }

  FutureOr<void> homeNavigateToWishListPageActionState(
      HomeWhislistButtonNavigateEvent event, Emitter<HomeState> emit) {
    print('whis list navigate button clicked');
    emit(HomeNavigateToWishListPageActionState());
  }

  FutureOr<void> homeCartButtonNavigateEvent(
      HomeCartButtonNavigateEvent event, Emitter<HomeState> emit) {
    print('cart navigate button clicked');
    emit(HOmeNavigateToCartPageActionState());
  }
}
