//IMPORTANT TO IMPORT
import 'dart:async' show Timer;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

//CLASS CALLED FROM MENU, WORK ALARM
class workAlarm extends StatelessWidget {
  const workAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: alarmPage(),
    );
  }
}

//ALARM PAGE CLASS
class alarmPage extends StatefulWidget {
  const alarmPage({super.key});

  @override
  alarmFunctions createState() => alarmFunctions();
}

//ALARM FUNCTIONS
class alarmFunctions extends State<alarmPage> with SingleTickerProviderStateMixin {

  //IMPORTANT VARIABLES
  late TabController _tabController;
  final List<Timer?> _timer = [null,null];
  final player = AudioPlayer();
  bool alarmPlay = false;
  late DateTime currentTime;
  late DateTime selectedTime;


  String setHourString = "--";
  String setMinuteString = "--";
  String setSecondString = "--";
  String AMorPM = "--";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    currentTime = DateTime.now();
    selectedTime = DateTime.now();

    // CURRENT TIME IS CONTINUOUSLY UPDATED
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          currentTime = DateTime.now();
        });
      }
    });
  }

  // START TIMER FUNCTION, ACTUALLY SETS THE ALARM CLOCK
  Future<void> startTimer(int n)
  async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedTime),
    );

    //EDITS THE USER INPUT TO MAKE INTO THE CLOCK OF THE SET ALARM
    int hour2 = picked?.hour ?? 0;
    int minute2 = picked?.minute ?? 0;
    int second2 = 0;
    AMorPM = "AM";

    if(hour2 > 12)
    {
      hour2 = hour2 - 12;
      AMorPM = "PM";
    }

    String hourString2  = hour2.toString();
    String minuteString2 = minute2.toString();
    String secondString2  = second2.toString().padLeft(2, '0');

    if(hour2 < 10)
    {
      hourString2 = hour2.toString().padLeft(2, '0');
    }

    if(minute2<10)
    {
      minuteString2 = minute2.toString().padLeft(2, '0');
    }

    //UPDATED TO VARIABLES
    setHourString = hourString2.toString();
    setMinuteString = minuteString2.toString();
    setSecondString = secondString2.toString();
  }

  //STOP TIMER FUNCTION
  void stopTimer(int n)
  {
    //STOPS ALARM IF NEEDED
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

    setHourString = "--";
    setMinuteString = "--";
    setSecondString = "--";

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

  //FORMAT OF PAGE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Work management timers'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 'Work Session Alarm' tab
          buildTab(0),
        ],
      ),
    );
  }

  //1 TAB FOR THE SAME PURPOSE AS BEFORE
  Widget buildTab(int n) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Alarm Time: ${AlarmClock()}'),
            ],
          ),
          const SizedBox(height: 16), //EMPTY TO CREATE SPACE TO MAKE NEAT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            //BUTTONS NEEDED
            children: [

              //START ALARM
              ElevatedButton(onPressed: () {
                startTimer(n);
              },
                child: const Text('Set Alarm Clock'),
              ),

              //STOP ALARM
              ElevatedButton(onPressed: () {
                stopTimer(n);
              },
                child: const Text('Stop Alarm'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                //RESET INPUT BUTTON
                ElevatedButton(onPressed: () {
                  resetTimer(n);
                },
                  child: const Text('Reset Alarm'),
                )]),

          const SizedBox(height: 20),

          //ACTUAL TIMER SHOWN
          Text('Current Time: ${formatDuration()}'),
        ],
      ),
    );
  }

  //ALARM SET
  String AlarmClock()
  {
    return '$setHourString:$setMinuteString:$setSecondString $AMorPM';
  }

  // FORMAT FOR THE TIMER
  String formatDuration() {

    int hour = currentTime.hour;
    int minute = currentTime.minute;
    int second = currentTime.second;
    String M = "AM";

    if(hour > 12)
      {
        hour = hour - 12;
        M = "PM";
      }

    String hourString = hour.toString();
    String minuteString = minute.toString();
    String secondString = second.toString();

    if(hour < 10)
    {
      hourString = hour.toString().padLeft(2, '0');
    }

    if(minute<10)
    {
      minuteString = minute.toString().padLeft(2, '0');
    }

    if(second<10)
    {
      secondString = second.toString().padLeft(2, '0');
    }

    if((hourString == setHourString) && (minuteString == setMinuteString) && (secondString == setSecondString))
    {
      Alarm();
    }

    return '$hourString:$minuteString:$secondString $M';
  }

}