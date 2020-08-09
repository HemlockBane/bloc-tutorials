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
  Stream<TimerState> mapEventToState(TimerEvent timerEvent) async* {
    if (timerEvent is StartEvent) {
      yield* _mapStartEventToState(timerEvent);
    } else if (timerEvent is TickEvent) {
      yield* _mapTickEventToState(timerEvent);
    } else if (timerEvent is PauseEvent) {
      yield* _mapPauseEventToState(timerEvent);
    } else if (timerEvent is ResumeEvent) {
      yield* _mapResumeEventToState(timerEvent);
    } else if (timerEvent is ResetEvent) {
      yield* _mapResetEventToState(timerEvent);
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

  Stream<TimerState> _mapResetEventToState(ResetEvent resetEvent) async* {
    _tickSubscription?.cancel();
    yield ReadyState(_duration);
  }
}
