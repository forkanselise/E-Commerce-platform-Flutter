import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mobile_phone.dart';
import '../services/mobile_phone_service.dart';

class MobilePhoneState {
  final List<MobilePhone> allPhones;
  final String selectedBrand;
  final String searchQuery;
  final bool isLoading;

  MobilePhoneState({
    required this.allPhones,
    this.selectedBrand = 'All',
    this.searchQuery = '',
    this.isLoading = false,
  });

  List<MobilePhone> get phones {
    return allPhones.where((p) {
      final matchesBrand = selectedBrand == 'All' || p.brand.toLowerCase() == selectedBrand.toLowerCase();
      final matchesSearch = searchQuery.isEmpty || p.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesBrand && matchesSearch;
    }).toList();
  }

  MobilePhoneState copyWith({
    List<MobilePhone>? allPhones,
    String? selectedBrand,
    String? searchQuery,
    bool? isLoading,
  }) {
    return MobilePhoneState(
      allPhones: allPhones ?? this.allPhones,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MobilePhoneNotifier extends StateNotifier<MobilePhoneState> {
  MobilePhoneNotifier() : super(MobilePhoneState(allPhones: INITIAL_PHONES)) {
    loadPhones();
  }

  Future<void> loadPhones() async {
    state = state.copyWith(isLoading: true);
    final p = await MobilePhoneService.fetchMobilePhones();
    state = state.copyWith(allPhones: p, isLoading: false);
  }

  void setBrand(String brand) {
    state = state.copyWith(selectedBrand: brand);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final mobilePhoneProvider = StateNotifierProvider<MobilePhoneNotifier, MobilePhoneState>((ref) => MobilePhoneNotifier());
final phoneBrandsProvider = Provider<List<String>>((ref) => ['All', 'Apple', 'Samsung', 'Google', 'Xiaomi']);
