import Foundation

var demoMode = false
var demoTime = 10.0
let prefs:UserDefaults = UserDefaults.standard

enum PomodoroMode: Int {
  case work = 0
  case shortBreak = 1
  case longBreak = 2
  case meeting = 3
  
  func totalTimeSeconds() -> Double {
    var result: Double
    if !Settings.instance.demo {
      let times = Settings.instance.times
      switch self {
      case .work:
        result = stringToSeconds(times[0])
      case .shortBreak:
        result = stringToSeconds(times[1])
      case .longBreak:
        result = stringToSeconds(times[2])
      case .meeting:
        result = 0.0
      }
    } else {
      switch self {
      case .work:
        result = 1.minutes
      case .shortBreak:
        result = 10.0
      case .longBreak:
        result = 20.0
      case .meeting:
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
    case .work:
      return "Work"
    case .shortBreak:
      return "Short Break"
    case .longBreak:
      return "Long Break"
    case .meeting:
      return "Meeting"
    }
  }
  
  func startButtonLabel() -> String {
    return "Start \(label())"
  }
  
  func continueButtonLabel() -> String {
    return "Continue \(label())"
  }
  
  func nextButtonLabel(_ consecutiveWorks: Int, secsRemaining: Double) -> String {
    if secsRemaining == totalTimeSeconds() {
      return startButtonLabel()
    }
    
    if 0.0 < secsRemaining && secsRemaining < totalTimeSeconds() && self == .work {
      return continueButtonLabel()
    }
    
    switch self {
    case .work:
      if consecutiveWorks < 3 {
        return "Start Short Break"
      } else {
        return "Start Long Break"
      }
    case .shortBreak, .longBreak:
      return PomodoroMode.work.startButtonLabel()
    case .meeting:
      return "Continue Meeting"
    }
  }
  fileprivate func stringToSeconds(_ string: String) -> Double {
    let hoursStr = string[string.startIndex ..< string.characters.index(string.startIndex, offsetBy: 2)]
    let minutesStr = string[string.characters.index(string.endIndex, offsetBy: -2) ..< string.endIndex]
    let hours = Double(hoursStr)!
    let minutes = Double(minutesStr)!
    return hours * 3600 + minutes * 60
  }
  
}
