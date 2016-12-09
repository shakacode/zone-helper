//
//  Colors.swift
//  MauiPomodoro
//
//  Created by Justin Gordon on 6/23/14.
//  Copyright (c) 2014 Justin Gordon. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

class Colors {
  let overColorTop = UIColor(red: 192.0/255.0, green: 38.0/255.0, blue: 42.0/255.0, alpha: 1.0).cgColor
  let overColorBottom = UIColor(red: 35.0/255.0, green: 2.0/255.0, blue: 2.0/255.0, alpha: 1.0).cgColor
  
  let shortBreakColorTop = UIColor(red: 6.0/255.0, green: 61.0/255.0, blue: 117.0/255.0, alpha: 1.0).cgColor
  let shortBreakColorBottom = UIColor(red: 1.0/255.0, green: 12.0/255.0, blue: 33.0/255.0, alpha: 1.0).cgColor
  
  let longBreakColorTop = UIColor(red: 13.0/255.0, green: 85.0/255.0, blue: 89.0/255.0, alpha: 1.0).cgColor
  let longBreakColorBottom = UIColor(red: 4.0/255.0, green: 32.0/255.0, blue: 33.0/255.0, alpha: 1.0).cgColor
  
  let meetingColorTop = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 84.0/255.0, alpha: 1.0).cgColor
  let meetingColorBottom = UIColor(red: 7.0/255.0, green: 8.0/255.0, blue: 35.0/255.0, alpha: 1.0).cgColor
  
  let workColor = UIColor.black

  let overColorGradientLayer: CAGradientLayer
  let shortBreakColorGradientLayer: CAGradientLayer
  let longBreakColorGradientLayer: CAGradientLayer
  let meetingColorGradientLayer: CAGradientLayer
 
  init() {
    overColorGradientLayer = CAGradientLayer()
    let arrayColorsOver: Array <AnyObject> = [ overColorTop, overColorBottom]
    overColorGradientLayer.colors = arrayColorsOver
    overColorGradientLayer.locations = [ 0.0, 1.0]
    
    shortBreakColorGradientLayer = CAGradientLayer()
    let arrayColorsShort: Array <AnyObject> = [ shortBreakColorTop, shortBreakColorBottom]
    shortBreakColorGradientLayer.colors = arrayColorsShort
    shortBreakColorGradientLayer.locations = [ 0.0, 1.0]

    longBreakColorGradientLayer = CAGradientLayer()
    let arrayColorsLong: Array <AnyObject> = [ longBreakColorTop, longBreakColorBottom]
    longBreakColorGradientLayer.colors = arrayColorsLong
    longBreakColorGradientLayer.locations = [ 0.0, 1.0]

    meetingColorGradientLayer = CAGradientLayer()
    let arrayColorsMeeting: Array <AnyObject> = [ meetingColorTop, meetingColorBottom]
    meetingColorGradientLayer.colors = arrayColorsMeeting
    meetingColorGradientLayer.locations = [ 0.0, 1.0]
  }
}
