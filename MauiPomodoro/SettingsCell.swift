//
//  SettingsCell.swift
//  ZoneHelper
//
//  Created by Алексей Карасев on 01/05/16.
//  Copyright © 2016 Justin Gordon. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
  
  fileprivate let inset:CGFloat = 10
  fileprivate let breaklineInset: CGFloat = 15
  fileprivate let breaklineColor = UIColor(red: 70.0/255, green: 70.0/255, blue: 70.0/255, alpha: 1.0)
  fileprivate var backView: UIView! = nil
  fileprivate var lineView: UIView! = nil
  fileprivate let cornerRadius:CGFloat = 10
  
  @IBInspectable var top: Bool = false
  @IBInspectable var bottom: Bool = false
  @IBInspectable var backviewColor: UIColor = UIColor(red: 55.0/255, green: 55.0/255, blue: 55.0/255, alpha: 1.0)
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backView = UIView()
    backView.backgroundColor = backviewColor
    addSubview(backView)
    sendSubview(toBack: backView)
    
    lineView = UIView()
    lineView.backgroundColor = breaklineColor
    addSubview(lineView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    backView.frame = CGRect(origin: CGPoint(x: inset, y: 0),
                            size: CGSize(width: frame.width - 2 * inset, height: frame.height))
    var corners = UIRectCorner()
    if top { corners = corners.union(UIRectCorner.topLeft).union(UIRectCorner.topRight) }
    if bottom { corners = corners.union(UIRectCorner.bottomRight).union(UIRectCorner.bottomLeft) }
    let path = UIBezierPath(roundedRect: backView.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    backView.layer.mask = maskLayer
    
    if !bottom {
      lineView.frame = CGRect(x: inset + breaklineInset, y: bounds.height - 1 , width: bounds.width - 2*(inset + breaklineInset), height: 1)
    }
  }
  
}
