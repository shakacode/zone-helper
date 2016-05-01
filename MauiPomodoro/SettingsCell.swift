//
//  SettingsCell.swift
//  ZoneHelper
//
//  Created by Алексей Карасев on 01/05/16.
//  Copyright © 2016 Justin Gordon. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    private let inset:CGFloat = 10
    private let breaklineInset: CGFloat = 15
    private let breaklineColor = UIColor.whiteColor()
    private var backView: UIView! = nil
    private var lineView: UIView! = nil
    private let cornerRadius:CGFloat = 10
    
    @IBInspectable var top: Bool = false
    @IBInspectable var bottom: Bool = false
    @IBInspectable var backviewColor: UIColor = UIColor(red: 55.0/255, green: 55.0/255, blue: 55.0/255, alpha: 1.0)

    override func awakeFromNib() {
        super.awakeFromNib()
        print(self.frame)
        backView = UIView()
        backView.backgroundColor = backviewColor
        addSubview(backView)
        sendSubviewToBack(backView)
        
        lineView = UIView()
        lineView.backgroundColor = breaklineColor
        addSubview(lineView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.frame = CGRect(origin: CGPoint(x: inset, y: 0),
                                size: CGSize(width: frame.width - 2 * inset, height: frame.height))
        print(backView.frame)
        var corners = UIRectCorner()
        if top { corners = corners.union(UIRectCorner.TopLeft).union(UIRectCorner.TopRight) }
        if bottom { corners = corners.union(UIRectCorner.BottomRight).union(UIRectCorner.BottomLeft) }
        let path = UIBezierPath(roundedRect: backView.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.CGPath
        backView.layer.mask = maskLayer
        
        if !bottom {
            print(bounds)
            lineView.frame = CGRect(x: inset + breaklineInset, y: bounds.height - 1 , width: bounds.width - 2*(inset + breaklineInset), height: 1)
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
//        if !bottom {
//            let path = UIBezierPath()
//            path.moveToPoint(CGPoint(x: , y: rect.height))
//            path.addLineToPoint(CGPoint(x: rect.width - inset - breaklineInset ,y: rect.height))
//            path.lineWidth = 1
//            breaklineColor.setStroke()
//            path.stroke()
//        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
