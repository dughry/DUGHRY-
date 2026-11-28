import 'package:flutter_test/flutter_test.dart';
import 'package:dughry/main.dart';

void main() {
  setUp(() {
    DughryAppStateStore.cartItems.clear();
    DughryAppStateStore.orders.clear();
    DughryLocationStore.selectedGovernorateId = 'cairo';
    DughryLocationStore.selectedCenter = 'مدينة نصر';
    DughryLocationStore.isGpsSynced = false;
  });

  tearDown(() {
    DughryAppStateStore.cartItems.clear();
    DughryAppStateStore.orders.clear();
  });

  test('the location catalogue contains all 27 governorates', () {
    expect(DughryLocationStore.governorates, hasLength(27));
    expect(DughryAppStateStore.categories, hasLength(10));
  });

  test('Minya is available only in El Adwa', () {
    DughryLocationStore.selectedGovernorateId = 'minya';
    DughryLocationStore.selectedCenter = 'مركز العدوة';
    expect(DughryLocationStore.isCurrentAreaAvailable, isTrue);

    DughryLocationStore.selectedCenter = 'مركز بني مزار';
    expect(DughryLocationStore.isCurrentAreaAvailable, isFalse);
  });

  test('checkout rejects a cart item from another governorate', () {
    final gizaProduct = DughryAppStateStore.sampleProducts.firstWhere(
      (product) => product.governorateAr == 'الجيزة',
    );
    DughryAppStateStore.addToCart(gizaProduct);

    expect(DughryAppStateStore.checkoutCart('القاهرة - مدينة نصر'), isNull);
    expect(DughryAppStateStore.cartItems, hasLength(1));
    expect(DughryAppStateStore.orders, isEmpty);
  });
}
