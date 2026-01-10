import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Home Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class GetWasteCategoriesEvent extends HomeEvent {
  const GetWasteCategoriesEvent();
}

class GetWasteListEvent extends HomeEvent {
  final String categoryId;

  const GetWasteListEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class FilterByCategoryEvent extends HomeEvent {
  final String categoryId;

  const FilterByCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

// Home States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class CategoriesLoaded extends HomeState {
  final List<dynamic> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class WasteListLoaded extends HomeState {
  final List<dynamic> wasteItems;
  final String selectedCategory;

  const WasteListLoaded({
    required this.wasteItems,
    required this.selectedCategory,
  });

  @override
  List<Object?> get props => [wasteItems, selectedCategory];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

// Home BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<GetWasteCategoriesEvent>(_onGetCategories);
    on<GetWasteListEvent>(_onGetWasteList);
    on<FilterByCategoryEvent>(_onFilterByCategory);
  }

  Future<void> _onGetCategories(
      GetWasteCategoriesEvent event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 1));
      final mockCategories = ['All', 'Plastic', 'Glass', 'Electronics', 'Metal', 'Paper', 'Paul'];
      emit(CategoriesLoaded(mockCategories));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onGetWasteList(
      GetWasteListEvent event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 1));
      final mockWaste = [
        {'id': '1', 'name': 'Plastic Bottle', 'price': 2.50},
        {'id': '2', 'name': 'Glass Bottle', 'price': 5.00},
        {'id': '3', 'name': 'Aluminum Can', 'price': 3.00},
      ];
      emit(WasteListLoaded(
        wasteItems: mockWaste,
        selectedCategory: event.categoryId,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onFilterByCategory(
      FilterByCategoryEvent event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final mockWaste = [
        {'id': '1', 'name': 'Item 1', 'price': 2.50},
        {'id': '2', 'name': 'Item 2', 'price': 5.00},
      ];
      emit(WasteListLoaded(
        wasteItems: mockWaste,
        selectedCategory: event.categoryId,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
