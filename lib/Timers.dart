//IMPORTANT TO IMPORT
import 'dart:async' show Timer;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

//CLASS CALLED FROM MENU, WORKSESSIONTIMERS
class workSessionTimers extends StatelessWidget {
  const workSessionTimers({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: timerPage(),
    );
  }
}

//TIMER PAGE CLASS
class timerPage extends StatefulWidget {
  const timerPage({super.key});

  @override
  timersFunctions createState() => timersFunctions();
}

//TIMERS FUNCTIONS
class timersFunctions extends State<timerPage> with SingleTickerProviderStateMixin {

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
    // USES HOURS, MINUTES, AND SECOND STATES AND PARSE THEM INTO THE VARIABLES
    int hour = int.parse(hourState[n].text);
    int minute = int.parse(minuteState[n].text);
    int second = int.parse(secondState[n].text);

    // USER DESIRED END TIME
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
          title: const Text('Work management timers'),
          bottom: TabBar(
              controller: _tabController,

              //TABS IMPORTANT FOR BOTH TIMERS
              tabs: const [
                Tab(text: 'Work Session Timer'),
                Tab(text: 'Break Session Timer'),
              ]
          )
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 'Work Session Timer' tab
          buildTab(0),
          // 'Break Session Timer' tab
          buildTab(1),
        ],
      ),
    );
  }

  //WILL USE BOTH TABS FOR THE SAME PURPOSE
  Widget buildTab(int n) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //USER MAKES CHOICE ON HOW THEY WANT TO SET THE TIMER
              buildInput('Hours', hourState[n]),
              buildInput('Minutes', minuteState[n]),
              buildInput('Seconds', secondState[n]),
            ],
          ),
          const SizedBox(height: 16), //EMPTY TO CREATE SPACE TO MAKE NEAT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            //BUTTONS NEEDED
            children: [

              //START TIMER
              ElevatedButton(onPressed: () {
                startTimer(n);
              },
                child: Text('Start Timer ${n + 1}'),
              ),

              //STOP TIMER
              ElevatedButton(onPressed: () {
                stopTimer(n);
              },
                child: Text('Stop Timer ${n + 1}'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                //RESET TIMER BUTTON
                ElevatedButton(onPressed: () {
                  resetTimer(n);
                  },
                  child: Text('Reset Timer ${n + 1}'),
                )]),

          const SizedBox(height: 20),

          //ACTUAL TIMER SHOWN
          Text('Timer ${n + 1}: ${formatDuration(timerSeconds[n])}'),
        ],
      ),
    );
  }

  //ALLOWS FOR INPUT
  Widget buildInput(String label, TextEditingController controller)
  {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType:  TextInputType.number,
        decoration: InputDecoration(labelText: label),
      )
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