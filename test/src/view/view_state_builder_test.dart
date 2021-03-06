import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:flutter_bloc_patterns/src/view/view_state_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../util/view_test_util.dart';

class MockTestBloc extends MockBloc<int, ViewState>
    implements Bloc<int, ViewState> {}

void main() {
  Bloc<int, ViewState> bloc;
  const readyKey = Key('ready');
  const loadKey = Key('loading');
  const refreshKey = Key('refreshing');
  const emptyKey = Key('empty');
  const successKey = Key('success');
  const errorKey = Key('errorKey');
  const someData = 0;
  final someError = Exception();

  setUp(() {
    bloc = MockTestBloc();
  });

  Widget makeTestableViewStateBuilder() {
    return makeTestableWidget(
      child: ViewStateBuilder<int, Bloc<int, ViewState>>(
        bloc: bloc,
        onReady: (context) => Container(key: readyKey),
        onLoading: (context) => Container(key: loadKey),
        onRefreshing: (context, number) => Container(key: refreshKey),
        onEmpty: (context) => Container(key: emptyKey),
        onSuccess: (context, number) => Container(key: successKey),
        onError: (context, error) => Container(key: errorKey),
      ),
    );
  }

  testWidgets('should diplay onReady widget when block is in inital state',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(const Initial());

    await tester.pumpWidget(makeTestableViewStateBuilder());

    expect(find.byKey(readyKey), findsOneWidget);
  });

  testWidgets('should diplay onLoading widget when block is in loading state',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(const Loading());

    await tester.pumpWidget(makeTestableViewStateBuilder());

    expect(find.byKey(loadKey), findsOneWidget);
  });

  testWidgets(
      'should diplay onRefreshing widget when block is in refreshing state',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(const Refreshing(someData));

    await tester.pumpWidget(makeTestableViewStateBuilder());

    expect(find.byKey(refreshKey), findsOneWidget);
  });

  testWidgets('should diplay onEmpty widget when block is in empty state',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(const Empty());

    await tester.pumpWidget(makeTestableViewStateBuilder());

    expect(find.byKey(emptyKey), findsOneWidget);
  });

  testWidgets('should diplay onSuccess widget when block is in success state',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(const Success(someData));

    await tester.pumpWidget(makeTestableViewStateBuilder());

    expect(find.byKey(successKey), findsOneWidget);
  });

  testWidgets('should diplay onError widget when block is in failure state',
      (WidgetTester tester) async {
    when(bloc.initialState).thenReturn(Failure(someError));
    when(bloc.state).thenReturn(Failure(someError));

    await tester.pumpWidget(makeTestableViewStateBuilder());

    expect(find.byKey(errorKey), findsOneWidget);
  });

  tearDown(() {
    bloc.close();
  });
}
