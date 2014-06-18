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
    var workTimeSecondsRemaining: Double?
    
    init() {
        
    }
    
    func reset() {
        workTimeSecondsRemaining = totalWorkTimeSeconds
        startTime = nil
    }

    func pause() {
        workTimeSecondsRemaining = secsLeft()
        startTime = nil
    }
    
    func start() {
        startTime = NSDate()
    }
    
    func convertSecsToMinSecs(secs: Double) -> String {
        return String(secs)
    }

    func secsLeft() -> Double {
        if let st = startTime {
            var secs = st.timeIntervalSinceNow
            return workTimeSecondsRemaining! - secs
        } else {
            return 0
        }
    }
    
    func timerValue() -> String {
        var secs = secsLeft()
        return convertSecsToMinSecs(secs)
    }
}
