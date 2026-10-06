import 'package:checkout_engine/checkout_engine.dart';
import 'package:test/test.dart';

void main() {
  group('BagItem', () {
    test('resolves its product from the catalog', () {
      expect(BagItem('soda').product, catalog['soda']);
    });

    test('throws UnknownProductException for an id not in the catalog', () {
      expect(
        () => BagItem('pizza'),
        throwsA(
          isA<UnknownProductException>()
              .having((error) => error.productId, 'productId', 'pizza'),
        ),
      );
    });
  });

  group('Bag', () {
    test('add throws for an unknown product and keeps the bag intact', () {
      final bag = Bag()..add('soda');

      expect(() => bag.add('pizza'), throwsA(isA<UnknownProductException>()));
      expect(bag.items, hasLength(1));
    });

    test('rejects an unknown product passed to the constructor', () {
      expect(
        () => Bag([BagItem('soda'), BagItem('pizza')]),
        throwsA(isA<UnknownProductException>()),
      );
    });
  });

  group('UnknownProductException', () {
    test('names the unknown id in its message', () {
      expect(
        const UnknownProductException('pizza').toString(),
        contains('pizza'),
      );
    });
  });
}
