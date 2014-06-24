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
  let overColorTop = UIColor(red: 192.0/255.0, green: 38.0/255.0, blue: 42.0/255.0, alpha: 1.0)
  let overColorBottom = UIColor(red: 35.0/255.0, green: 2.0/255.0, blue: 2.0/255.0, alpha: 1.0)
  
  let shortBreakColorTop = UIColor(red: 6.0/255.0, green: 61.0/255.0, blue: 117.0/255.0, alpha: 1.0)
  let shortBreakColorBottom = UIColor(red: 1.0/255.0, green: 12.0/255.0, blue: 33.0/255.0, alpha: 1.0)
  
  let longBreakColorTop = UIColor(red: 13.0/255.0, green: 85.0/255.0, blue: 89.0/255.0, alpha: 1.0)
  let longBreakColorBottom = UIColor(red: 4.0/255.0, green: 32.0/255.0, blue: 33.0/255.0, alpha: 1.0)
  
  let workColor = UIColor.blackColor()

  let overColorGradientLayer: CAGradientLayer
  let shortBreakColorGradientLayer: CAGradientLayer
  let longBreakColorGradientLayer: CAGradientLayer
 
  init() {
    overColorGradientLayer = CAGradientLayer()
    overColorGradientLayer.colors = [ overColorTop, overColorBottom]
    overColorGradientLayer.locations = [ 0.0, 1.0]
    
    shortBreakColorGradientLayer = CAGradientLayer()
    shortBreakColorGradientLayer.colors = [ shortBreakColorTop, shortBreakColorBottom]
    shortBreakColorGradientLayer.locations = [ 0.0, 1.0]

    longBreakColorGradientLayer = CAGradientLayer()
    longBreakColorGradientLayer.colors = [ longBreakColorTop, longBreakColorBottom]
    longBreakColorGradientLayer.locations = [ 0.0, 1.0]
  }
}