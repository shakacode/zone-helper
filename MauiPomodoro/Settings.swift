//
//  Settings.swift
//  ZoneHelper
//
//  Created by Алексей Карасев on 01/05/16.
//  Copyright © 2016 Justin Gordon. All rights reserved.
//

import Foundation

struct Settings {
  
  static var instance = Settings()
  
  var demo: Bool {
    get {
      return NSUserDefaults.standardUserDefaults().boolForKey("demo")
    }
    set {
      NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "demo")
    }
  }
  
  var times: [String] {
    get {
      let objects = NSUserDefaults.standardUserDefaults().arrayForKey("times") ?? ["00:27", "00:03", "00:15"]
      return objects as! [String]
    }
    set {
      NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "times")
    }
  }
}
