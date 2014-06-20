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
  
  let totalWorkTimeSeconds = 25.0 * 60.0
  var workTimeSecondsRemaining = 0.0
  
  init() {
    reset()
  }
  
  func reset() {
    workTimeSecondsRemaining = totalWorkTimeSeconds
  }
  
  func pause() {
    workTimeSecondsRemaining = secsLeft()
    startTime = nil
  }
  
  func start() {
    startTime = NSDate()
  }
  
  func convertSecsToMinSecs(secs: Double) -> String {
    var mm = Int(secs / 60)
    var ss = Int(secs % 60)
    var sss = String(ss)
    if ss < 10 {
      sss = "0" + sss
    }
    return String("\(mm):\(sss)")
  }
  
  func secsLeft() -> Double {
    if let st = startTime {
      var elapsed = st.timeIntervalSinceNow
      var remaining = workTimeSecondsRemaining + elapsed
      return max(0, remaining)
    }
    return totalWorkTimeSeconds
  }
  
  func timerValue() -> String {
    var secs = secsLeft()
    return convertSecsToMinSecs(secs)
  }
}
