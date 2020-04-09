import 'dart:async';
import 'package:meta/meta.dart';

import 'package:bloc_test_2/src/blocs/timer_bloc/timer_event.dart';
import 'package:bloc_test_2/src/blocs/timer_bloc/timer_state.dart';
import 'package:bloc_test_2/src/ticker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final int _duration = 60;

  Ticker _ticker;
  StreamSubscription<int> _tickSubscription;

  TimerBloc({@required Ticker ticker})
      : assert(ticker != null),
        _ticker = ticker;

  @override
  TimerState get initialState => ReadyState(_duration);

  @override
  Stream<TimerState> mapEventToState(TimerEvent event) async* {
    if (event is StartEvent) {
      yield* _mapStartEventToState(event);
    } else if (event is TickEvent) {
      yield* _mapTickEventToState(event);
    } else if (event is PauseEvent) {
      yield* _mapPauseEventToState(event);
    } else if (event is ResumeEvent) {
      yield* _mapResumeEventToState(event);
    } else if (event is ResetEvent) {
      yield* _mapResetEventToState(event);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }

  Stream<TimerState> _mapStartEventToState(StartEvent startEvent) async* {
    yield RunningState(startEvent.remainingDuration);
    _tickSubscription?.cancel();
    _tickSubscription = _ticker
        .tick(ticks: startEvent.remainingDuration)
        .listen((remainingDuration) {
      add(TickEvent(remainingDuration: remainingDuration));
    });
  }

  Stream<TimerState> _mapTickEventToState(TickEvent tickEvent) async* {
    yield tickEvent.remainingDuration > 0
        ? RunningState(tickEvent.remainingDuration)
        : FinishedState();
  }

  Stream<TimerState> _mapPauseEventToState(PauseEvent pauseEvent) async* {
    if (state is RunningState) {
      _tickSubscription?.pause();
      yield PausedState(state.remainingDuration);
    }
  }

  Stream<TimerState> _mapResumeEventToState(ResumeEvent resumeEvent) async* {
    if (state is PausedState) {
      _tickSubscription?.resume();
      yield RunningState(state.remainingDuration);
    }
  }

  Stream<TimerState> _mapResetEventToState(ResetEvent event) async* {
    _tickSubscription?.cancel();
    yield ReadyState(_duration);
  }
}
