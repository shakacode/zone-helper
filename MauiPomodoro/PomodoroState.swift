//
//  PomodoroState.swift
//  MauiPomodoro
//
//  Created by Justin Gordon on 6/17/14.
//  Copyright (c) 2014 Justin Gordon. All rights reserved.
//

import Foundation

enum Mode: Int {
  case Work
  case ShortBreak
  case LongBreak
}

class PomodoroState {
  var startTime: NSDate?
  var mode: Mode = Mode.Work
  
  var totalWorkTimeSeconds = 27.minutes
  var totalShortBreakTimeSeconds = 3.minutes
  var totalLongBreakTimeSeconds = 15.minutes
 
  var secondsRemaining = 0.minutes
  
  init() {
    resetWork()
  }
  
  func resetWork() {
    startTime = nil
    secondsRemaining = totalWorkTimeSeconds
  }

  func resetLongBreak() {
    startTime = nil
    secondsRemaining = totalLongBreakTimeSeconds
  }

  func resetShortBreak() {
    startTime = nil
    secondsRemaining = totalShortBreakTimeSeconds
  }
  
  func pause() {
    secondsRemaining = secsLeft()
    startTime = nil
  }
  
  func start() {
    startTime = NSDate()
  }
  
  func convertSecsToMinSecs(secs: Double) -> String {
    var absSecs = abs(secs)
    var minutes = Int(absSecs / 60)
    var seconds = Int(absSecs % 60)
    var secondsString: String
    if seconds < 10 {
      secondsString = "0\(seconds)"
    } else {
      secondsString = String(seconds)
    }
    return String("\(minutes):\(secondsString)")
  }
  
  func secsLeft() -> Double {
    var elapsed = 0.0
    if let st = startTime {
      elapsed = st.timeIntervalSinceNow
    }
    return secondsRemaining + elapsed
  }
  
  func timerStatus() -> (text: String, secs: Double) {
    var secs = secsLeft()
    return (convertSecsToMinSecs(secs), secs)
  }
}
