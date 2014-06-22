//
//  PomodoroState.swift
//  MauiPomodoro
//
//  Created by Justin Gordon on 6/17/14.
//  Copyright (c) 2014 Justin Gordon. All rights reserved.
//

import Foundation
import UIKit

enum PomodoroMode: Int {
  case Work
  case ShortBreak
  case LongBreak
}

class PomodoroState {
  let overWorkColor = UIColor.redColor()
  let overBreakColor = UIColor.orangeColor()
  let workColor = UIColor.blackColor()
  let shortBreakColor = UIColor.brownColor()
  let longBreakColor = UIColor.darkGrayColor()
  
  var startTime: NSDate?
  var mode: PomodoroMode = PomodoroMode.Work

  var totalWorkTimeSeconds = 27.minutes //10.0 //
  var totalShortBreakTimeSeconds = 3.minutes //3.0 //
  var totalLongBreakTimeSeconds = 15.minutes // 5.0 //
 
  var secondsRemaining = 0.minutes
  
  var consecutiveWorks = 0
  
  init() {
    resetWork()
  }
  
  func backgroundColor() -> (UIColor) {
    if secsLeft() < 0 {
      if mode == PomodoroMode.Work {
        return overWorkColor
      } else {
        return overBreakColor
      }
    } else {
      switch mode {
      case PomodoroMode.Work:
        return workColor
      case PomodoroMode.ShortBreak:
        return shortBreakColor
      case PomodoroMode.LongBreak:
        return longBreakColor
      }
    }
  }
  
  func nextButtonLabel() -> (String) {
    switch mode {
    case PomodoroMode.Work:
      if startTime {
        if consecutiveWorks < 3 {
          return "Start Short Break"
        } else {
          return "Start Long Break"
        }
      } else {
        return "Start Working"
      }
    case PomodoroMode.ShortBreak, PomodoroMode.LongBreak:
      if startTime {
        return "Start Working"
      } else {
        if mode == PomodoroMode.ShortBreak {
          return "Start Short Break"
        } else {
          return "Start Long Break"
        }
      }
    }
  }
  
  func nextButtonHidden() -> (Bool) {
    if startTime == nil {
      return false
    }
    
    // do not show next button if in work mode and secs left > 0
    return mode == PomodoroMode.Work && secsLeft() > 0.0
  }

  func nextPressed() {
    if startTime {
      if mode == PomodoroMode.Work {
        consecutiveWorks++
        if consecutiveWorks < 4 {
          resetShortBreak()
        } else {
          resetLongBreak()
          consecutiveWorks = 0
        }
      } else {
        resetWork()
      }
    } // else just start
    start()
  }
  
  func resetWork() {
    startTime = nil
    secondsRemaining = totalWorkTimeSeconds
    mode = PomodoroMode.Work
  }

  func resetLongBreak() {
    startTime = nil
    secondsRemaining = totalLongBreakTimeSeconds
    mode = PomodoroMode.LongBreak
  }

  func resetShortBreak() {
    startTime = nil
    secondsRemaining = totalShortBreakTimeSeconds
    mode = PomodoroMode.ShortBreak
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
