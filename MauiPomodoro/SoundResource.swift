//
//  SoundResources.swift
//  MauiPomodoro
//
//  Created by Justin Gordon on 7/11/14.
//  Copyright (c) 2014 Justin Gordon. All rights reserved.
//

import Foundation
import AudioToolbox

let soundResource = SoundResource()

class SoundResource {
  func playAlarmSound() {
    AudioServicesPlaySystemSound(1304)
  }
  
  func playStartSound() {
    AudioServicesPlaySystemSound(1103)
  }
  
  func playPauseSound() {
    AudioServicesPlaySystemSound(1104)
  }
}