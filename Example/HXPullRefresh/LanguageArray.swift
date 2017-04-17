//
//  LanguageArray.swift
//  HXPullRefresh
//
//  Created by 海啸 on 2017/4/17.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation

extension Array {
    mutating func random() {
        for _ in 0..<self.count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
