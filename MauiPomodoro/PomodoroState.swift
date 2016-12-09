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


let pomodoroState = PomodoroState()

class PomodoroState {
  let colors = Colors()
  
  var timeConsecutiveWorksResets = 30.minutes
  
  var startTime: Date?
  var pauseStartTime: Date?
  
  var mode: PomodoroMode = PomodoroMode.work
  
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
    if mode == PomodoroMode.meeting {
      return colors.meetingColorGradientLayer
    }
    
    if secsUntilTimerEnds() < 0 {
      return colors.overColorGradientLayer
    } else {
      switch mode {
      case .work:
        return colors.longBreakColorGradientLayer
      case .shortBreak:
        return colors.shortBreakColorGradientLayer
      case .longBreak:
        return colors.longBreakColorGradientLayer
      case .meeting:
        return colors.meetingColorGradientLayer
      }
    }
  }
  
  func statusLabel() -> (String) {
    if secsUntilTimerEnds() > 0 || mode == PomodoroMode.meeting {
      return "\(mode.label())\(pausedTimeMinSecs())"
    } else {
      if mode == PomodoroMode.work {
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
      if secsUntilTimerEnds() < 0 && mode == PomodoroMode.work {
        consecutiveWorks += 1
        if consecutiveWorks < 4 {
          resetShortBreak()
        } else {
          resetLongBreak()
          consecutiveWorks = 0
        }
      } else {
        if (mode == PomodoroMode.shortBreak || mode == PomodoroMode.longBreak) {
          resetWork()
        }
      }
    }
    // else just start (continue)
    start()
  }
  
  func totalTimeForMode(_ mode: PomodoroMode) -> (Double) {
    return mode.totalTimeSeconds()
  }
  
  func resetCommon(_ mode: PomodoroMode) {
    self.mode = mode
    startTime = nil
    pauseStartTime = nil
    secondsRemainingWhenTimerStarts = mode.totalTimeSeconds()
    playedAlarm = mode == PomodoroMode.meeting // false otherwise
  }
  
  func resetWork() {
    resetCommon(PomodoroMode.work)
  }
  
  func resetShortBreak() {
    resetCommon(PomodoroMode.shortBreak)
  }
  
  func resetLongBreak() {
    resetCommon(PomodoroMode.longBreak)
  }
  
  func resetMeeting() {
    resetCommon(PomodoroMode.meeting)
  }
  
  func pause() {
    secondsRemainingWhenTimerStarts = secsUntilTimerEnds()
    startTime = nil
    pauseStartTime = Date()
    soundResource.playPauseSound()
  }
  
  func start() {
    pauseStartTime = nil
    startTime = Date()
    soundResource.playStartSound()
  }
  
  func paused() -> Bool {
    return pauseStartTime != nil
  }
  
  class func convertSecsToMinSecs(_ secs: Double) -> String {
    func leadingZero(_ num: Int) -> String {
      if num < 10 {
        return "0\(num)"
      } else {
        return String(num)
      }
    }
    let absSecs = abs(secs)
    let hours = Int(absSecs / 3600)
    let secondsAfterHours = Int(absSecs.truncatingRemainder(dividingBy: 3600))
    let minutes = secondsAfterHours / 60
    let seconds = Int(secondsAfterHours % 60)
    if 0 < hours {
      return String("\(hours):\(leadingZero(minutes)):\(leadingZero(seconds))")
    } else {
      return String("\(minutes):\(leadingZero(seconds))")
    }
  }
  
  class func convertMinSecsToSecs(_ minSecs: String) -> Int {
    let minSecArr = minSecs.components(separatedBy: ":")
    let minutes: Int? = Int(minSecArr[0])
    let seconds: Int? = Int(minSecArr[1])
    return (minutes! * 60) + seconds!
  }
  
  func secsUntilTimerEnds() -> Double {
    var elapsed = 0.0
    if let st = startTime {
      elapsed = st.timeIntervalSinceNow
    }
    return secondsRemainingWhenTimerStarts + elapsed
  }
  
  func timerStatus() -> (text: String, secs: Double) {
    let secs = secsUntilTimerEnds()
    checkResetConsecutiveWorks(secs)
    return (PomodoroState.convertSecsToMinSecs(secs), secs)
  }
  
  // If any time goes over 30 min or if paused for over 30 min
  func checkResetConsecutiveWorks(_ secs: Double) {
    if secs < -timeConsecutiveWorksResets || timeConsecutiveWorksResets < pausedTime() {
      consecutiveWorks = 0
    }
  }
  
  func pausedTimeMinSecs() -> String {
    if let st = pauseStartTime {
      return " (Paused \(PomodoroState.convertSecsToMinSecs(-st.timeIntervalSinceNow)))"
    }
    return ""
  }
  
  func pausedTime() -> Double {
    if let st = pauseStartTime {
      return -st.timeIntervalSinceNow
    }
    return 0.0
  }
  
  func checkPlayedAlarm() {
    let secs = secsUntilTimerEnds()
    if secs < -5 {
      // if more than 5 secs went by, then probably app was in background, so don't play sound when going to foreground
      playedAlarm = true
    } else if secs < 0 && !playedAlarm {
      soundResource.playAlarmSound()
      playedAlarm = true
    }
  }
}
