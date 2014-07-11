//
//  IntExtension.swift
//  MauiPomodoro
//
//  Created by Justin Gordon on 7/11/14.
//  Copyright (c) 2014 Justin Gordon. All rights reserved.
//

import Foundation

extension Int {
  var minutes: Double { return Double(self) * 60.0 }
  var minute: Double { return Double(self) * 60.0 }
}