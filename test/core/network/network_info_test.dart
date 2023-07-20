import 'package:clean_app/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:mockito/mockito.dart';
import 'network_info_test.mocks.dart';

// class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

@GenerateMocks([DataConnectionChecker])
// void main() {}
void main() {
  NetworkInfoImpl? networkInfo;
  MockDataConnectionChecker? mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker!);
  });

  group('isConnected', () {
    test(
      'should forward the call to DataConnectionChecker.hasConnection',
      () async {
        // arrange
        final tHasConnectionFuture = Future<bool>.value(true);

        when(mockDataConnectionChecker!.hasConnection)
            .thenAnswer((_) => tHasConnectionFuture);
        // act
        final result = networkInfo!.isConnected;
        // assert
        verify(mockDataConnectionChecker!.hasConnection);
        expect(result, tHasConnectionFuture);
      },
    );
  });
}
