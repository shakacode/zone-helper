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
      return UserDefaults.standard.bool(forKey: "demo")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "demo")
    }
  }
  
  var times: [String] {
    get {
      let objects = UserDefaults.standard.array(forKey: "times") ?? ["00:27", "00:03", "00:15"]
      return objects as! [String]
    }
    set {
      UserDefaults.standard.setValue(newValue, forKey: "times")
    }
  }
}
