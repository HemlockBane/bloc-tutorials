import 'package:bloc_test_2/src/blocs/counter_bloc.dart';
import 'package:bloc_test_2/src/blocs/timer_bloc/timer_bloc.dart';
import 'package:bloc_test_2/src/screens/timer_screen.dart';
import 'package:bloc_test_2/src/ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => TimerBloc(ticker: Ticker()),
        child: TimerScreen(),
      ),
    );
  }
}
