import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable {
  final int remainingDuration;
  TimerState(this.remainingDuration);

  @override
  List<Object> get props => [remainingDuration];
}

class ReadyState extends TimerState {
  ReadyState(int remainingDuration) : super(remainingDuration);

  @override
  String toString() {
    return 'Ready { remaining duration: $remainingDuration}';
  }
}



class PausedState extends TimerState {
  PausedState(int duration) : super(duration);

  @override
  String toString() {
    return 'Paused { remaining duration: $remainingDuration}';
  }
}

class RunningState extends TimerState {
  RunningState(int remainingDuration) : super(remainingDuration);

  @override
  String toString() {
    return 'Running { remaining duration: $remainingDuration}';
  }
}


class FinishedState extends TimerState {
  FinishedState() : super(0);

  @override
  String toString() {
    return 'Finished { remaining duration: $remainingDuration}';
  }
}
