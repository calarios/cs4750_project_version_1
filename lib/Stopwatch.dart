//IMPORTANT TO IMPORT
import 'dart:async' show Timer;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' show AudioPlayer, ProcessingState;

//CLASS CALLED FROM MENU, WORKSTOPWATCH
class workStopwatch extends StatelessWidget {
  const workStopwatch({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: stopWatchPage(),
    );
  }
}

//STOP WATCH PAGE CLASS
class stopWatchPage extends StatefulWidget {
  const stopWatchPage({super.key});

  @override
  stopWatchPageFunctions createState() => stopWatchPageFunctions();
}

// FUNCTIONS
class stopWatchPageFunctions extends State<stopWatchPage> with SingleTickerProviderStateMixin {

  //IMPORTANT VARIABLES
  late TabController _tabController;
  final List<Timer?> _timer = [null,null];
  List<int> timerSeconds = [0,0];
  List<TextEditingController> hourState = [TextEditingController(), TextEditingController()];
  List<TextEditingController> minuteState = [TextEditingController(), TextEditingController()];
  List<TextEditingController> secondState = [TextEditingController(), TextEditingController()];
  final player = AudioPlayer();
  bool alarmPlay = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // START TIMER FUNCTION
  void startTimer(int n)
  {

    // STOP WATCH WILL END IN 24 HOURS
    int hour = 23;
    int minute = 59;
    int second = 59;

    // END TIME
    int endTime = (hour * 60 * 60) + (minute * 60) + second;

    //FUNCTION TO START TIMER
    _timer[n] = Timer.periodic(const Duration(seconds: 1), (timer)
    {
      // IF THE TIMER IS LESS THAN THE END TIME, THEN IT CONTINUES UNTIL ENDTIME
      if (timerSeconds[n] < endTime)
      {
        setState(()
        {
          timerSeconds[n]++;
        });
      } else
      {
        //STOPS TIMER AND ACTIVATES ALARM
        _timer[n]!.cancel();
        Alarm();
      }
    });
  }

  //STOP TIMER FUNCTION
  void stopTimer(int n)
  {
    //STOPS TIMER, AND STOPS ALARM IF NEEDED
    stopAlarm();
    if(_timer[n] != null && _timer[n]!.isActive)
    {
      _timer[n]!.cancel();
    }
  }

  //RESET TIMER FUNCTION
  void resetTimer(int n)
  {
    //STOPS ALARM AND RESETS TIMER BACK TO ZERO
    stopAlarm();
    stopTimer(n);
    setState(() {
      timerSeconds[n] = 0;//TIMER SECONDS
    });
  }

  //ALARM FUNCTION, WILL STAY ACTIVATED UNTIL STOP ALARM FUNCTION IS CALLED
  void Alarm() async
  {
    alarmPlay = true;
    await player.setAsset('assets/alarm.mp3');
    await player.play();
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed &&
          (alarmPlay == true)) {
        Alarm();
      }
    });
  }

  //STOP ALARM FUNCTION
  void stopAlarm()
  {
    alarmPlay = false;
    player.stop();
  }

  //EDIT PAGE WHEN NEEDED, TAB CONTROLLER
  @override
  void dispose() {
    _tabController.dispose();
    for(var timer in _timer)
    {
      timer?.cancel();
    }
    for (var controller in hourState)
    {
      controller.dispose();
    }
    for (var controller in minuteState)
    {
      controller.dispose();
    }
    for (var controller in secondState)
    {
      controller.dispose();
    }
    player.dispose();
    super.dispose();
  }

  //FORMAT OF PAGE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Work Stop Watch'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [

          //NEED TO USE ONLY 1 TAB
          buildTab(0),
        ],
      ),
    );
  }

  // ONLY 1 TAB
  Widget buildTab(int n) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              //START
              ElevatedButton(onPressed: () {
                startTimer(n);
              },
                child: const Text('Start Stopwatch'),
              ),

              //STOP
              ElevatedButton(onPressed: () {
                stopTimer(n);
              },
                child: const Text('Stop Stopwatch'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                //RESET
                ElevatedButton(onPressed: () {
                  resetTimer(n);
                },
                  child: const Text('Reset Stopwatch'),
                )]),
          const SizedBox(height: 20),

          // TIMER SHOWN
          Text('Stopwatch: ${formatDuration(timerSeconds[n])}'),
        ],
      ),
    );
  }

  // FORMAT FOR THE TIMER
  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    return '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

}