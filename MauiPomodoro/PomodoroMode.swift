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
    if !Settings.instance.demo {
      let times = Settings.instance.times
      switch self {
      case .Work:
        result = stringToSeconds(times[0])
      case .ShortBreak:
        result = stringToSeconds(times[1])
      case .LongBreak:
        result = stringToSeconds(times[2])
      case .Meeting:
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
  private func stringToSeconds(string: String) -> Double {
    let hoursStr = string[string.startIndex ..< string.startIndex.advancedBy(2)]
    let minutesStr = string[string.endIndex.advancedBy(-2) ..< string.endIndex]
    let hours = Double(hoursStr)!
    let minutes = Double(minutesStr)!
    return hours * 3600 + minutes * 60
  }
  
}
