//
//  PomodoroState.swift
//  MauiPomodoro
//
//  Created by Justin Gordon on 6/17/14.
//  Copyright (c) 2014 Justin Gordon. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import AudioToolbox

var demoMode = false
var demoTime = 10.0

enum PomodoroMode: Int {
  case Work = 0
  case ShortBreak = 1
  case LongBreak = 2
  case Meeting = 3
  
  func totalTimeSeconds() -> Double {
    var result: Double
    switch self {
    case .Work:
      result = 27.minutes
    case .ShortBreak:
      result = 3.minutes
    case .LongBreak:
      result = 15.minutes
    case .Meeting:
      result = 0.0
    }
    
    if demoMode {
      result /= 60
    }
    
    return result
  }
  
  func label() -> String {
    switch self {
    case .Work:
      return "Work"
    case .ShortBreak:
      return "Short Break"
    case .LongBreak:
      return "Long Break"
    case .Meeting:
      return "Meeting"
    }
  }

  func startButtonLabel() -> String {
    return "Start \(label())"
  }
  
  func continueButtonLabel() -> String {
    return "Continue \(label())"
  }
  
  func nextButtonLabel(consecutiveWorks: Int, secsRemaining: Double) -> String {
    if secsRemaining == totalTimeSeconds() {
      return startButtonLabel()
    }

    if 0.0 < secsRemaining && secsRemaining < totalTimeSeconds() && self == .Work {
      return continueButtonLabel()
    }
    
    switch self {
    case .Work:
      if consecutiveWorks < 3 {
        return "Start Short Break"
      } else {
        return "Start Long Break"
      }
    case .ShortBreak, .LongBreak:
      return PomodoroMode.Work.startButtonLabel()
    case .Meeting:
      return "Continue Meeting"
    }
  }
}

class PomodoroState {
  let colors = Colors()
  
  let timeConsecutiveWorksResets = 30.minutes
  
  var startTime: NSDate?
  var pauseStartTime: NSDate?
  
  var mode: PomodoroMode = PomodoroMode.Work
  
  // Used when timer is paused and restarted
  var secondsRemainingWhenTimerStarts = 0.minutes
  
  var playedAlarm = false
  
  var consecutiveWorks = 0
  
  init() {
    resetWork()
    if demoMode {
      timeConsecutiveWorksResets = 15.0
    }
  }
  
  func backgroundGradient() -> (CAGradientLayer) {
    if secsUntilTimerEnds() < 0 {
      return colors.overColorGradientLayer
//      if mode == PomodoroMode.Work {
//        return colors.overColorGradientLayer
//      } else {
//        return colors.overColorGradientLayer // back to same color for over break and over work
//      }
    } else {
      switch mode {
      case .Work:
        return colors.longBreakColorGradientLayer
      case .ShortBreak:
        return colors.shortBreakColorGradientLayer
      case .LongBreak:
        return colors.longBreakColorGradientLayer
      case .Meeting:
        return colors.meetingColorGradientLayer
      }
    }
  }
  
  func statusLabel() -> (String) {
    if secsUntilTimerEnds() > 0 || mode == PomodoroMode.Meeting {
      return mode.label()
    } else {
      if mode == PomodoroMode.Work {
        return "\(mode.label()) Finished: Take Break"
      } else {
        return "\(mode.label()) Finished: Start Work"
      }
    }
  }
  
  func nextButtonLabel() -> (String) {
    return mode.nextButtonLabel(consecutiveWorks, secsRemaining: secsUntilTimerEnds())
  }
  
  func nextButtonHidden() -> (Bool) {
    return startTime != nil
  }
  
  func startedSinceReset() -> (Bool) {
    return secsUntilTimerEnds() != totalTimeForMode(mode)
  }
  
  func nextPressed() {
    if startedSinceReset() {
      if secsUntilTimerEnds() < 0 && mode == PomodoroMode.Work {
        consecutiveWorks++
        if consecutiveWorks < 4 {
          resetShortBreak()
        } else {
          resetLongBreak()
          consecutiveWorks = 0
        }
      } else {
        if (mode == PomodoroMode.ShortBreak || mode == PomodoroMode.LongBreak) {
          resetWork()
        }
      }
    }
    // else just start (continue)
    start()
  }
  
  func totalTimeForMode(mode: PomodoroMode) -> (Double) {
    return mode.totalTimeSeconds()
  }
  
  func resetCommon(mode: PomodoroMode) {
    self.mode = mode
    startTime = nil
    secondsRemainingWhenTimerStarts = mode.totalTimeSeconds()
    playedAlarm = mode == PomodoroMode.Meeting // false otherwise
  }
  
  func resetWork() {
    resetCommon(PomodoroMode.Work)
  }
  
  func resetShortBreak() {
    resetCommon(PomodoroMode.ShortBreak)
  }
  
  func resetLongBreak() {
    resetCommon(PomodoroMode.LongBreak)
  }
  
  func resetMeeting() {
    resetCommon(PomodoroMode.Meeting)
  }
  
  func pause() {
    secondsRemainingWhenTimerStarts = secsUntilTimerEnds()
    startTime = nil
    pauseStartTime = NSDate()
  }
  
  func start() {
    pauseStartTime = nil
    startTime = NSDate()
  }
  
  func convertSecsToMinSecs(secs: Double) -> String {
    func leadingZero(num: Int) -> String {
      if num < 10 {
        return "0\(num)"
      } else {
        return String(num)
      }
    }
    var absSecs = abs(secs)
    var hours = Int(absSecs / 3600)
    var secondsAfterHours = Int(absSecs % 3660)
    var minutes = secondsAfterHours / 60
    var seconds = Int(secondsAfterHours % 60)
    if 0 < hours {
      return String("\(hours):\(leadingZero(minutes)):\(leadingZero(seconds))")
    } else {
      return String("\(minutes):\(leadingZero(seconds))")
    }
  }
  
  func secsUntilTimerEnds() -> Double {
    var elapsed = 0.0
    if let st = startTime {
      elapsed = st.timeIntervalSinceNow
    }
    return secondsRemainingWhenTimerStarts + elapsed
  }
  
  func timerStatus() -> (text: String, secs: Double) {
    var secs = secsUntilTimerEnds()
    checkResetConsecutiveWorks(secs)
    return (convertSecsToMinSecs(secs), secs)
  }
  
  // If any time goes over 30 min or if paused for over 30 min
  func checkResetConsecutiveWorks(secs: Double) {
    if secs < -timeConsecutiveWorksResets || timeConsecutiveWorksResets < pausedTime() {
      consecutiveWorks = 0
    }
  }
  
  func pausedTime() -> Double {
    if let st = pauseStartTime {
      return -st.timeIntervalSinceNow
    }
    return 0.0
  }
  
  func checkPlayedAlarm() {
    if secsUntilTimerEnds() < 0 && !playedAlarm {
      AudioServicesPlaySystemSound(1304)
      playedAlarm = true
    }
  }
}
