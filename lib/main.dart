import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import "package:pomo_app/constants/constants.dart" as con;

part 'main.g.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleColor = ref.watch(highlightColorProvider);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var tab = height > 1000 || width > 1000;
    var port = tab ? -0.6 : -0.7;
    var land = tab ? -0.7 : -0.95;
    var timerVert = !tab && width > height ? 0.5 : 0.0;
    var buttonBarVert = height > width ? port : land;
    return MaterialApp(
      theme:
          ThemeData(scaffoldBackgroundColor: Colors.transparent.withOpacity(0)),
      home: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF282a57), Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent.withOpacity(0),
            title: Text("pomodoro",
                style: TextStyle(
                  fontSize: 30,
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                )),
            centerTitle: true,
          ),
          body: Stack(children: [
            // Button Bar
            Align(
                alignment: Alignment(0.5, buttonBarVert),
                child: const ButtonBar()),
            // Timer Display
            Align(
              alignment: Alignment(0.0, timerVert),
              child: const TimerDisplay(),
            ),
          ]),
        ),
      ),
    );
  }
}

class TimerButton extends ConsumerWidget {
  const TimerButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(timerButtonTitleProvider);
    final onPressed = ref.watch(timerButtonCallbackProvider);
    return TextButton(
      onPressed: onPressed,
      child: Text(title,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          )),
    );
  }
}

class ScreenButton extends ConsumerWidget {
  const ScreenButton(
      {required this.title, required this.active, this.onPressed, super.key});
  final VoidCallback? onPressed;
  final String title;
  final bool active;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(highlightColorProvider);
    if (active) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: color,
          elevation: 5, // button's elevation when it's pressed
        ),
        child: Text(title,
          style: const TextStyle(
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          )
        ),
      );
    } else {
      return TextButton(
        onPressed: onPressed,
        child: Text(title,
          style: const TextStyle(
          fontSize: 13,
          color: Colors.grey,
          fontWeight: FontWeight.normal,
          )
        ),
      );
    }
  }
}

class ButtonBar extends ConsumerWidget {
  const ButtonBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeButton = ref.watch(activeScreenButtonProvider);
    final pomoActive = activeButton == con.pomodoroLabel;
    final longActive = activeButton == con.longBreakLabel;
    final shortActive = activeButton == con.shortBreakLabel;
    return OverflowBar(
      alignment: MainAxisAlignment.center,
      spacing: 8.0,
      children: <Widget>[
        ScreenButton(
          title: con.pomodoroLabel,
          active: pomoActive,
          onPressed: () {
            final duration = ref.watch(pomoDurationProvider);
            ref.read(activeScreenButtonProvider.notifier).update(con.pomodoroLabel);
            ref.read(timerDurationProvider.notifier).update(duration);
          }
        ),
        ScreenButton(
            title: con.shortBreakLabel,
            active: longActive,
            onPressed: () {
              final duration = ref.watch(longBreakDurationProvider);
              ref.read(activeScreenButtonProvider.notifier).update(con.longBreakLabel);
              ref.read(timerDurationProvider.notifier).update(duration);
            }
          ),
        ScreenButton(
            title: con.longBreakLabel,
            active: shortActive,
            onPressed: () {
              final duration = ref.watch(shortBreakDurationProvider);
              ref.read(activeScreenButtonProvider.notifier).update(con.shortBreakLabel);
              ref.read(timerDurationProvider.notifier).update(duration);
            }
          ),
      ],
    );
  }
}

class TimerDisplay extends ConsumerWidget {
  const TimerDisplay({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = ref.watch(timerDurationProvider);
    final controller = ref.watch(controllerProvider);
    final ringColor = ref.watch(highlightColorProvider);
    controller.isPaused.addListener(() {
      debugPrint("----> isPaused: ${controller.isPaused.value}");
      if (controller.isPaused.value == true) {
        ref.read(timerButtonTitleProvider.notifier).update(con.resumeLabel);
        ref
            .read(timerButtonCallbackProvider.notifier)
            .update(() => controller.resume());
      }
    });
    controller.isResumed.addListener(() {
      if (controller.isResumed.value == true) {
        debugPrint("----> isResumed: ${controller.isResumed.value}");
        ref.read(timerButtonTitleProvider.notifier).update(con.pauseLabel);
        ref
            .read(timerButtonCallbackProvider.notifier)
            .update(() => controller.pause());
      }
    });
    return Container(
      width: 180.0,
      height: 180.0,
      margin: const EdgeInsets.all(25),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularCountDownTimer(
                      // Countdown duration in Seconds.
                      duration: duration,

                      // Countdown initial elapsed Duration in Seconds.
                      initialDuration: 0,

                      // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                      controller: controller,

                      // Width of the Countdown Widget.
                      width: MediaQuery.of(context).size.width / 2,

                      // Height of the Countdown Widget.
                      height: MediaQuery.of(context).size.height / 2,

                      // Ring Color for Countdown Widget.
                      ringColor: ringColor,

                      // Ring Gradient for Countdown Widget.
                      ringGradient: const LinearGradient(
                          colors: [Colors.black, Color(0xFF282a57)]),

                      // Filling Color for Countdown Widget.
                      fillColor: ringColor,

                      // Filling Gradient for Countdown Widget.
                      fillGradient: null,

                      // Background Color for Countdown Widget.
                      backgroundColor: Colors.indigo,

                      // Background Gradient for Countdown Widget.
                      backgroundGradient: const LinearGradient(
                          colors: [Colors.black, Color(0xFF282a57)]),

                      // Border Thickness of the Countdown Ring.
                      strokeWidth: 8.0,

                      // Begin and end contours with a flat edge and no extension.
                      strokeCap: StrokeCap.round,

                      // Text Style for Countdown Text.
                      textStyle: const TextStyle(
                        fontSize: 33.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),

                      // Format for the Countdown Text.
                      textFormat: CountdownTextFormat.MM_SS,

                      // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                      isReverse: true,

                      // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                      isReverseAnimation: false,

                      // Handles visibility of the Countdown Text.
                      isTimerTextShown: true,

                      // Handles the timer start.
                      autoStart: false,

                      // This Callback will execute when the Countdown Starts.
                      onStart: () {
                        debugPrint('Countdown Started');
                        ref
                            .read(timerButtonTitleProvider.notifier)
                            .update(con.pauseLabel);
                        ref
                            .read(timerButtonCallbackProvider.notifier)
                            .update(() => controller.pause());
                      },

                      // This Callback will execute when the Countdown Ends.
                      onComplete: () {
                        // Here, do whatever you want
                        debugPrint('Countdown Ended');
                        controller.reset();
                        ref
                            .read(timerButtonTitleProvider.notifier)
                            .update(con.startLabel);
                        ref
                            .read(timerButtonCallbackProvider.notifier)
                            .update(() => controller.restart());
                      },

                      // This Callback will execute when the Countdown Changes.
                      onChange: (String timeStamp) {},
                      timeFormatterFunction:
                          (defaultFormatterFunction, duration) {
                        if (duration.inSeconds == 0) {
                          return "00:00";
                        } else {
                          return Function.apply(
                              defaultFormatterFunction, [duration]);
                        }
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Center(child: TimerButton()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

@riverpod
CountDownController controller(ControllerRef ref) => CountDownController();

@riverpod
class TimerButtonCallback extends _$TimerButtonCallback {
  @override
  VoidCallback build() => () {
        final controller = ref.watch(controllerProvider);
        controller.start();
      };

  void update(VoidCallback cb) {
    state = cb;
  }
}

@riverpod
class TimerDuration extends _$TimerDuration {
  @override
  int build() => con.initPomoDuration;
  void update(int val) {
    state = val;
  }
}

@riverpod
class PomoDuration extends _$PomoDuration {
  @override
  int build() => con.initPomoDuration;
  void update(int val) {
    state = val;
  }
}

@riverpod
class LongBreakDuration extends _$LongBreakDuration {
  @override
  int build() => con.initLongBreakDuration;
  void update(int val) {
    state = val;
  }
}

@riverpod
class ShortBreakDuration extends _$ShortBreakDuration {
  @override
  int build() => con.initShortBreakDuration;
  void update(int val) {
    state = val;
  }
}

@riverpod
class TimerButtonTitle extends _$TimerButtonTitle {
  @override
  String build() => con.startLabel;
  void update(String val) {
    state = val;
  }
}

@riverpod
class TimerIsPaused extends _$TimerIsPaused {
  @override
  bool build() => false;
  void update(bool val) {
    state = val;
  }
}

@riverpod
class HighlightColor extends _$HighlightColor {
  @override
  Color build() => Colors.orange;
  void update(Color val) {
    state = val;
  }
}

@riverpod
class ActiveScreenButton extends _$ActiveScreenButton {
  @override
  String build() => con.pomodoroLabel;
  void update(String val) {
    state = val;
  }
}
