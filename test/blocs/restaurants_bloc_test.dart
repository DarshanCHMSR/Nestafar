import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../lib/blocs/blocs.dart';
import '../../lib/repositories/repositories.dart';
import '../../lib/models/models.dart';

// Mock classes
class MockRestaurantRepository extends Mock implements IRestaurantRepository {}

void main() {
  group('RestaurantsBloc', () {
    late MockRestaurantRepository mockRepository;
    late RestaurantsBloc restaurantsBloc;

    setUp(() {
      mockRepository = MockRestaurantRepository();
      restaurantsBloc = RestaurantsBloc(restaurantRepository: mockRepository);
    });

    tearDown(() {
      restaurantsBloc.close();
    });

    test('initial state is RestaurantsInitial', () {
      expect(restaurantsBloc.state, const RestaurantsInitial());
    });

    group('FetchRestaurants', () {
      final mockRestaurants = [
        const Restaurant(
          id: '1',
          name: 'Test Restaurant',
          description: 'Test Description',
          imageUrl: 'test.jpg',
          rating: 4.5,
          deliveryTimeMinutes: 35,
          deliveryFee: 2.99,
          minimumOrder: 15.0,
          cuisine: 'Italian',
          isOpen: true,
        ),
      ];

      blocTest<RestaurantsBloc, RestaurantsState>(
        'emits [RestaurantsLoading, RestaurantsLoaded] when FetchRestaurants is successful',
        build: () {
          when(() => mockRepository.getRestaurants())
              .thenAnswer((_) async => mockRestaurants);
          return restaurantsBloc;
        },
        act: (bloc) => bloc.add(const FetchRestaurants()),
        expect: () => [
          const RestaurantsLoading(),
          RestaurantsLoaded(mockRestaurants),
        ],
        verify: (_) {
          verify(() => mockRepository.getRestaurants()).called(1);
        },
      );

      blocTest<RestaurantsBloc, RestaurantsState>(
        'emits [RestaurantsLoading, RestaurantsError] when FetchRestaurants fails',
        build: () {
          when(() => mockRepository.getRestaurants())
              .thenThrow(Exception('Failed to load restaurants'));
          return restaurantsBloc;
        },
        act: (bloc) => bloc.add(const FetchRestaurants()),
        expect: () => [
          const RestaurantsLoading(),
          const RestaurantsError('Exception: Failed to load restaurants'),
        ],
      );
    });

    group('RefreshRestaurants', () {
      final mockRestaurants = [
        const Restaurant(
          id: '1',
          name: 'Test Restaurant',
          description: 'Test Description',
          imageUrl: 'test.jpg',
          rating: 4.5,
          deliveryTimeMinutes: 35,
          deliveryFee: 2.99,
          minimumOrder: 15.0,
          cuisine: 'Italian',
          isOpen: true,
        ),
      ];

      blocTest<RestaurantsBloc, RestaurantsState>(
        'emits [RestaurantsLoaded] when RefreshRestaurants is successful',
        build: () {
          when(() => mockRepository.getRestaurants())
              .thenAnswer((_) async => mockRestaurants);
          return restaurantsBloc;
        },
        act: (bloc) => bloc.add(const RefreshRestaurants()),
        expect: () => [
          RestaurantsLoaded(mockRestaurants),
        ],
      );
    });
  });
}