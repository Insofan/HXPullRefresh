//
//  PullRefreshOption.swift
//  HXPullRefresh
//
//  Created by 海啸 on 2017/4/16.
//  Copyright © 2017年 海啸. All rights reserved.
//

import UIKit

struct PullRefreshConst {
    static let pullTag                   = 810
    static let pushTag                   = 811
    static let alpha                     = true
    static let height: CGFloat           = 80
    static let imageName: String         = "refreshArrow.png"
    static let animationDuration: Double = 0.5
    static let fixedTop                  = true
}

public struct PullRefreshOption {
    public var backgroundColor: UIColor //The backgroundColor
    public var indicatorColor: UIColor //The indicatorColor
    public var autoStopTime: Double //0 is not auto stop
    public var fixedSectionHeader: Bool //Update the content inset for fixed section headers
    
    //refreshLabel option
    public var refreshLabelText: String //Label text
    public var refreshLabelTextColor: UIColor//Label text color
    public var refreshLabelTextFont: CGFloat//Label text font size
    
    public init(backgroundColor: UIColor = .clear, indicatorColor: UIColor = .gray, autoStopTime: Double = 0, fixedSectionHeader: Bool = false, refreshLabelText: String = "", refreshLabelTextColor: UIColor = .gray, refreshLabelTextFont: CGFloat = 15) {
        self.backgroundColor       = backgroundColor
        self.indicatorColor        = indicatorColor
        self.autoStopTime          = autoStopTime
        self.fixedSectionHeader    = fixedSectionHeader
        self.refreshLabelText      = refreshLabelText
        self.refreshLabelTextColor = refreshLabelTextColor
        self.refreshLabelTextFont  = refreshLabelTextFont
    }
}
