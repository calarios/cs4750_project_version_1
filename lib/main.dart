//IMPORTANT IMPORT
import 'package:flutter/material.dart';
import 'Timers.dart';
import 'Stopwatch.dart';
import 'alarmTime.dart';
import 'twentyRule.dart';

//LAUNCH APP
void main() {
  runApp(const project_app());
}

//PROJECT APP
class project_app extends StatelessWidget {
  const project_app({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CS 4750 PROJECT',
      home: HomePage(),
    );
  }
}

//HOME PAGE CLASS
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        //TITLE OF THE PAGE SEEN IN THE APP
        title: const Text('Management Assistance'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          //WHERE THE BUTTONS WILL BE SEEN
          children: [

            // 1ST BUTTON, WORK SESSION TIMERS
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => const workSessionTimers()),
                );
              },
              child: const Text('Work Session Timers'),
            ),
            const SizedBox(height: 16), //EMPTY TO CREATE SPACE

            // 2ND BUTTON, 20/20/20 RULE TIMERS
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => const Twenty()),
                );
              },
              child: const Text('Work Session Timers 20/20/20 rule'),
            ),

            const SizedBox(height: 16), //EMPTY

            // 3RD BUTTON, STOPWATCH
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => const workStopwatch()),
                );
              },
              child: const Text('Work Stopwatch'),
            ),

            const SizedBox(height: 16), //EMPTY

            // 4th BUTTON, ALARM
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => const workAlarm()),
                );
              },
              child: const Text('Work Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}