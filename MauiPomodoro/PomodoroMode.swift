import Foundation

var demoMode = false
var demoTime = 10.0
let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

enum PomodoroMode: Int {
  case Work = 0
  case ShortBreak = 1
  case LongBreak = 2
  case Meeting = 3
  
  func totalTimeSeconds() -> Double {
    var result: Double
    if !demoMode {
      switch self {
      case .Work:
        result = prefs.integerForKey("WORKTIME").minutes
        //result = 27.minutes
      case .ShortBreak:
        result = prefs.integerForKey("SHORTBREAKTIME").minutes
        //result = 3.minutes
      case .LongBreak:
        result = prefs.integerForKey("LONGBREAKTIME").minutes
        //result = 15.minutes
      case .Meeting:
        //result = prefs.integerForKey("MEETINGTIME").minutes
        result = 0.0
      }
    } else {
      switch self {
      case .Work:
        result = 1.minutes
      case .ShortBreak:
        result = 10.0
      case .LongBreak:
        result = 20.0
      case .Meeting:
        result = 0.0
      }
    }
    return result
  }
  
  func totalTimeMinSecs() -> String {
    return PomodoroState.convertSecsToMinSecs(totalTimeSeconds())
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
