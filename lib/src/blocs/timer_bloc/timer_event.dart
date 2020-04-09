import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class StartEvent extends TimerEvent {
  final int remainingDuration;

  const StartEvent({@required this.remainingDuration});

  @override
  String toString() => "Start { duration: $remainingDuration }";
}

class PauseEvent extends TimerEvent {}

class ResumeEvent extends TimerEvent {}

class ResetEvent extends TimerEvent {}

class TickEvent extends TimerEvent {
  final int remainingDuration;

  const TickEvent({@required this.remainingDuration});

  @override
  List<Object> get props => [remainingDuration];

  @override
  String toString() => "Tick { duration: $remainingDuration }";
}
