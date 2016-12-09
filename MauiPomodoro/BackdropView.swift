//
//  BackdropView.swift
//  ZoneHelper
//
//  Created by Алексей Карасев on 01/05/16.
//  Copyright © 2016 Justin Gordon. All rights reserved.
//

import UIKit

class BackdropView: UIView {
  
  var dismissController: UIViewController!
  var tap: UITapGestureRecognizer!
  fileprivate var dismissDuration:CGFloat!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init(frame: CGRect, dismissController: UIViewController, dismissDuration: CGFloat) {
    self.init(frame: frame)
    self.dismissController = dismissController
    self.dismissDuration = dismissDuration
    self.tap = UITapGestureRecognizer(target: self, action: #selector(BackdropView.tapped(_:)))
    addGestureRecognizer(self.tap)
  }
  
  func tapped(_ sender: UITapGestureRecognizer) {
    UIView.animate(withDuration: 0.5, animations: { [unowned self] in
      self.dismissController.view.frame.origin.x = -self.dismissController.view.frame.size.width
      }, completion: { [unowned self] result in
      self.dismissController.view.removeFromSuperview()
      self.dismissController.removeFromParentViewController()
      self.removeFromSuperview()
    })
    

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
