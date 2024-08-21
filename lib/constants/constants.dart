import "package:flutter/material.dart";

const String startLabel = "START";
const String pauseLabel = "PAUSE";
const String resumeLabel = "RESUME";
const String pomodoroLabel = "pomodoro";
const String shortBreakLabel = "short break";
const String longBreakLabel = "long break";
const String settingsLabel = "Settings";
const String timeLabel = "TIME (MINUTES)";
const String applyLabel = "Apply";
const String fontLabel = "FONT";
const String colorLabel = "COLOR";

const int initPomoDuration = 1800;
const int initLongBreakDuration = 900;
const int initShortBreakDuration = 300;

const IconData settingsIcon = IconData(0xe57f, fontFamily: "MaterialIcons");
const IconData closeIcon = IconData(0xe16a, fontFamily: "MaterialIcons");
const IconData checkMark = IconData(0xe156, fontFamily: "MaterialIcons");

const Key settingsKey = Key("settings_key");
