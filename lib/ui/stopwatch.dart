import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stopwatch/ui/stop_watch_renderer.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({Key? key}) : super(key: key);

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> with SingleTickerProviderStateMixin {
  Duration _elasped = Duration.zero;
  late final Ticker _ticker;
  bool onStart = false;
  Duration _previouslyElapsed = Duration.zero;
  Duration _currentlyElapsed = Duration.zero;
  Duration get _elapsed => _previouslyElapsed + _currentlyElapsed;

  @override
  void dispose(){
    _ticker.dispose();
    super.dispose();
  }

  void reset(){
    _ticker.stop();
    setState((){
      _previouslyElapsed = Duration.zero;
      _currentlyElapsed = Duration.zero;
    });
  }

  @override
  void initState(){
    super.initState();
    _ticker = this.createTicker((elapsed) {
      setState((){
        _currentlyElapsed = elapsed;
        print(elapsed);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraint){
      final radius = constraint.maxWidth / 2;
      return StopWatchRenderer(
        onpause: (){
          setState(() {
            onStart = false;
            _ticker.stop();
            _previouslyElapsed += _currentlyElapsed;
            _currentlyElapsed = Duration.zero;
          });
        },
        startState: onStart,
        elasped: _elapsed,
        radius: radius,
        startCallback: () {
          setState(() {
            onStart = true;

            _currentlyElapsed = _previouslyElapsed;
            _ticker.start();
          });
        },
        resetCallback: () {
          onStart = false;
          reset();
        },
      );
    });
  }
}