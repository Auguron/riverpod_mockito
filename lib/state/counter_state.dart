import 'package:http/http.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_mockito/constants.dart';
import 'package:riverpod_mockito/services/http_service.dart';

final counterStateProvider = StateNotifierProvider<CounterState, int>((ref) => CounterState(ref));

class CounterState extends StateNotifier<int> {
  Ref ref;
  CounterState(this.ref) : super(0);

  Future<int> incrementCounter() async {
    final Response response = await ref.read(httpProvider).get(url200);

    // Just for testing purposes
    await ref.read(httpProvider).get(url400);

    final int statusCode = response.statusCode;

    if (statusCode == 200) {
      state++;
    } else {
      state--;
    }

    return state;
  }
}
