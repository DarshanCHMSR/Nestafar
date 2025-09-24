import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nestafar/blocs/blocs.dart';
import 'package:nestafar/repositories/repositories.dart';
import 'package:nestafar/models/models.dart';

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

    group('LoadRestaurants', () {
      final mockRestaurants = [
        const Restaurant(
          id: '1',
          name: 'Test Restaurant',
          description: 'Test Description',
          imageUrl: 'test.jpg',
          rating: 4.5,
          deliveryTime: '30-40 min',
          deliveryFee: 2.99,
          minimumOrder: 15.0,
          cuisine: 'Italian',
          isOpen: true,
        ),
      ];

      blocTest<RestaurantsBloc, RestaurantsState>(
        'emits [RestaurantsLoading, RestaurantsLoaded] when LoadRestaurants is successful',
        build: () {
          when(() => mockRepository.getRestaurants())
              .thenAnswer((_) async => mockRestaurants);
          return restaurantsBloc;
        },
        act: (bloc) => bloc.add(const LoadRestaurants()),
        expect: () => [
          const RestaurantsLoading(),
          RestaurantsLoaded(restaurants: mockRestaurants),
        ],
        verify: (_) {
          verify(() => mockRepository.getRestaurants()).called(1);
        },
      );

      blocTest<RestaurantsBloc, RestaurantsState>(
        'emits [RestaurantsLoading, RestaurantsError] when LoadRestaurants fails',
        build: () {
          when(() => mockRepository.getRestaurants())
              .thenThrow(Exception('Failed to load restaurants'));
          return restaurantsBloc;
        },
        act: (bloc) => bloc.add(const LoadRestaurants()),
        expect: () => [
          const RestaurantsLoading(),
          const RestaurantsError(message: 'Failed to load restaurants'),
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
          deliveryTime: '30-40 min',
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
          RestaurantsLoaded(restaurants: mockRestaurants),
        ],
      );
    });
  });
}