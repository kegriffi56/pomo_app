import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:circular_countdown_timer/circular_countdown_timer.dart";
import "package:pomo_app/constants/constants.dart" as con;

part "main.g.dart";

void main() {
  runApp(const ProviderScope(
    child: PomoApp(),
  ));
}

class PomoApp extends ConsumerWidget {
  const PomoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var tab = height > 1000 || width > 1000;
    var port = tab ? -0.6 : -0.7;
    var land = tab ? -0.7 : -0.95;
    var timerVert = !tab && width > height ? 0.4 : 0.0;
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
            title: const Text(con.pomodoroLabel,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
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
            const Align(
              alignment: FractionalOffset.bottomCenter,
              child: ConfigButton(),
            )
          ]),
        ),
      ),
    );
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applyButtonColor = ref.watch(highlightColorProvider);
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 20.0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(con.closeIcon),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
            backgroundColor: Colors.transparent.withOpacity(0),
            title: const Text(con.settingsLabel,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                const Column(children: [
                  Divider(),
                  // Duration
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(con.timeLabel,
                        style: TextStyle(
                          letterSpacing: 3.0,
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("TODO"),
                      Text("TODO"),
                      Text("TODO"),
                    ],
                  ),
                  Divider(),
                  // Font
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(con.fontLabel,
                          style: TextStyle(
                            letterSpacing: 3.0,
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          )),
                      Text("TODO"),
                      Text("TODO"),
                      Text("TODO"),
                    ],
                  ),
                  Divider(),
                  // Color
                  ColorSettings(),
                ]),
                Align(
                  alignment: const FractionalOffset(0.5, 1.055),
                  child: SizedBox(
                    width: 150,
                    child: FloatingActionButton.extended(
                      backgroundColor: applyButtonColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        final pendingColor =
                            ref.watch(activeColorButtonProvider);
                        ref
                            .read(highlightColorProvider.notifier)
                            .update(pendingColor);
                      },
                      label: const Text(
                        con.applyLabel,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ColorSettings extends ConsumerWidget {
  const ColorSettings({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(con.colorLabel,
            style: TextStyle(
              letterSpacing: 3.0,
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            )),
        ColorButton(
          color: Colors.orange,
          onPressed: () {
            ref
                .read(activeColorButtonProvider.notifier)
                .update(Colors.orange);
          },
        ),
        ColorButton(
          color: Colors.cyanAccent,
          onPressed: () {
            ref
                .read(activeColorButtonProvider.notifier)
                .update(Colors.cyanAccent);
          },
        ),
        ColorButton(
          color: Colors.purpleAccent,
          onPressed: () {
            ref
                .read(activeColorButtonProvider.notifier)
                .update(Colors.purpleAccent);
          },
        ),
      ],
    );
  }
}

class ConfigButton extends ConsumerWidget {
  const ConfigButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      key: con.settingsKey,
      icon: const Icon(con.settingsIcon),
      color: Colors.grey,
      onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => const SettingsPage()),
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

class ColorButton extends ConsumerWidget {
  const ColorButton({required this.color, this.onPressed, super.key});
  final VoidCallback? onPressed;
  final Color color;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeButton = ref.watch(activeColorButtonProvider);
    final active = activeButton == color;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(15),
      ),
      onPressed: onPressed,
      child: active ? const Icon(con.checkMark) : const Text(""),
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
            )),
      );
    } else {
      return TextButton(
        onPressed: onPressed,
        child: Text(title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.normal,
            )),
      );
    }
  }
}

class ButtonBar extends ConsumerWidget {
  const ButtonBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(controllerProvider);
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
              ref
                  .read(activeScreenButtonProvider.notifier)
                  .update(con.pomodoroLabel);
              ref.read(timerDurationProvider.notifier).update(duration);
              controller.reset();
              ref
                  .read(timerButtonCallbackProvider.notifier)
                  .update(() => controller.restart(duration: duration));
            }),
        ScreenButton(
            title: con.shortBreakLabel,
            active: longActive,
            onPressed: () {
              final duration = ref.watch(shortBreakDurationProvider);
              ref
                  .read(activeScreenButtonProvider.notifier)
                  .update(con.longBreakLabel);
              ref.read(timerDurationProvider.notifier).update(duration);
              controller.reset();
              ref
                  .read(timerButtonCallbackProvider.notifier)
                  .update(() => controller.restart(duration: duration));
            }),
        ScreenButton(
            title: con.longBreakLabel,
            active: shortActive,
            onPressed: () {
              final duration = ref.watch(longBreakDurationProvider);
              ref
                  .read(activeScreenButtonProvider.notifier)
                  .update(con.shortBreakLabel);
              ref.read(timerDurationProvider.notifier).update(duration);
              controller.reset();
              ref
                  .read(timerButtonCallbackProvider.notifier)
                  .update(() => controller.restart(duration: duration));
            }),
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
      if (controller.isPaused.value == true) {
        ref.read(timerButtonTitleProvider.notifier).update(con.resumeLabel);
        ref
            .read(timerButtonCallbackProvider.notifier)
            .update(() => controller.resume());
      }
    });
    controller.isResumed.addListener(() {
      if (controller.isResumed.value == true) {
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
                      duration: duration,
                      initialDuration: 0,
                      controller: controller,
                      // width and height don't seem to matter in a sized box
                      width: 0.0,
                      height: 0.0,
                      ringColor: ringColor,
                      ringGradient: const LinearGradient(
                          colors: [Colors.black, Color(0xFF282a57)]),
                      fillColor: ringColor,
                      fillGradient: null,
                      backgroundColor: Colors.indigo,
                      backgroundGradient: const LinearGradient(
                          colors: [Colors.black, Color(0xFF282a57)]),
                      strokeWidth: 8.0,
                      strokeCap: StrokeCap.round,
                      textStyle: const TextStyle(
                        fontSize: 33.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textFormat: CountdownTextFormat
                          .MM_SS, // doesn't take effect with the custom format
                      isReverse: true,
                      isReverseAnimation: false,
                      isTimerTextShown: true,
                      autoStart: false,
                      onStart: () {
                        ref
                            .read(timerButtonTitleProvider.notifier)
                            .update(con.pauseLabel);
                        ref
                            .read(timerButtonCallbackProvider.notifier)
                            .update(() => controller.pause());
                      },
                      onComplete: () {
                        controller.reset();
                        ref
                            .read(timerButtonTitleProvider.notifier)
                            .update(con.startLabel);
                        ref.read(timerButtonCallbackProvider.notifier).update(
                            () => controller.restart(duration: duration));
                      },
                      onChange: (String timeStamp) {},
                      timeFormatterFunction:
                          (defaultFormatterFunction, duration) {
                        if (duration.inSeconds == 0) {
                          return "0";
                        } else {
                          // Only way I could think of to only update once per minute
                          // comment out  the next 6 lines and uncomment the 7th to get seconds
                          var sec = duration.inSeconds % 60;
                          if (sec != 0) {
                            return ((duration.inMinutes + 1) % 60).toString();
                          } else {
                            return (duration.inMinutes % 60).toString();
                          }
                          // return Function.apply(defaultFormatterFunction, [duration]);
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

// TO-DO: see if there is a way to move all these to a separate file
@riverpod
CountDownController controller(ControllerRef ref) => CountDownController();

@riverpod
class TimerButtonCallback extends _$TimerButtonCallback {
  @override
  VoidCallback build() => () {
        final duration = ref.watch(timerDurationProvider);
        final controller = ref.watch(controllerProvider);
        controller.restart(duration: duration);
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

@riverpod
class ActiveColorButton extends _$ActiveColorButton {
  @override
  Color build() => Colors.orange;
  void update(Color val) {
    state = val;
  }
}
