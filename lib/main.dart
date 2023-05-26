import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter MultiProvider Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

/// Function that returns the current date and time as a string
String now() => DateTime.now().toIso8601String();

/// Class which contains data which is updated every second
@immutable
class Seconds {
  final String value;

  /// Initialized [value] to [now]
  Seconds() : value = now();
}

/// Class which contains data which is updated every minute
@immutable
class Minutes {
  final String value;

  /// Initialized [value] to [now]
  Minutes() : value = now();
}

/// Stream of [String] that is updated around each [duration]
///
/// Returns value of [now] everytime [duration] elapses.
Stream<String> newStream(Duration duration) =>
    Stream.periodic(duration, (_) => now());

/// Shows data from [Seconds] class
class SecondsWidget extends StatelessWidget {
  const SecondsWidget({Key? key}) : super(key: key);

  /// [seconds] tracks changes in [Seconds] class
  ///
  /// If any change occurs, then the wiget is rebuilt.
  @override
  Widget build(BuildContext context) {
    final seconds = context.watch<Seconds>();
    return Expanded(
      child: Container(
        height: 100,
        color: Colors.yellow,
        child: Text(seconds.value),
      ),
    );
  }
}

class MinutesWidget extends StatelessWidget {
  const MinutesWidget({Key? key}) : super(key: key);

  /// [minutes] tracks changes in [Minutes] class
  ///
  /// If change occurs, then widget is rebuilt.
  @override
  Widget build(BuildContext context) {
    final minutes = context.watch<Minutes>();
    return Expanded(
      child: Container(
        height: 100,
        color: Colors.blue,
        child: Text(minutes.value),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Home Page')),
      ),
      /// MultiProvider is used with 2 StreamProviders
      ///
      /// First one is emitting a stream of [Seconds] periodically
      /// after each second
      ///
      /// Seconds one is emitting a stream of [Minutes] periodically
      /// after each 60 seconds, or one minute.
      body: MultiProvider(
        providers: [
          StreamProvider.value(
            value: Stream<Seconds>.periodic(
              const Duration(seconds: 1),
              (_) => Seconds(),
            ),
            initialData: Seconds(),
          ),
          StreamProvider.value(
            value: Stream<Minutes>.periodic(
              const Duration(minutes: 1),
              (_) => Minutes(),
            ),
            initialData: Minutes(),
          ),
        ],

        /// The [MultiProvider] is being consumed by a [Column]
        /// which contains [SecondsWidget] and [MinutesWidget]
        child: const Column(
          children: [
            Row(
              children: [
                SecondsWidget(),
                MinutesWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
