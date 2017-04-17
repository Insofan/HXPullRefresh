//
//  UIScrollViewExtension.swift
//  HXPullRefresh
//
//  Created by 海啸 on 2017/4/16.
//  Copyright © 2017年 海啸. All rights reserved.
//

import Foundation
import UIKit

public extension UIScrollView {
    fileprivate func refreshViewWithTag(_ tag: Int) -> PullRefreshView? {
        let pullRefreshView = viewWithTag(tag)
        return pullRefreshView as? PullRefreshView
    }
    
    public func addPullRefresh(options: PullRefreshOption = PullRefreshOption(), refreshCompletion:((Void) -> Void)?) {
        let refreshViewFrame = CGRect(x: 0, y: -PullRefreshConst.height, width: self.frame.size.width, height: PullRefreshConst.height)
        let refreshView = PullRefreshView(options: options, frame: refreshViewFrame, refreshCompletion: refreshCompletion)
        refreshView.tag = PullRefreshConst.pullTag
        addSubview(refreshView)
    }
    
    public func addPushRefresh(options: PullRefreshOption = PullRefreshOption(), refreshCompletion: ((Void) -> Void)?) {
        let refreshViewFrame = CGRect(x: 0, y: contentSize.height, width: self.frame.size.width, height: PullRefreshConst.height)
        let refreshView = PullRefreshView(options: options, frame: refreshViewFrame, refreshCompletion: refreshCompletion, down: false)
        refreshView.tag = PullRefreshConst.pushTag
        addSubview(refreshView)
    }
    
    public func startPullRefresh() {
        let refreshView = self.refreshViewWithTag(PullRefreshConst.pullTag)
        refreshView?.state = .refreshing
    }
    
    public func stopPullRefreshEver(_ ever: Bool = false) {
        let refreshView = self.refreshViewWithTag(PullRefreshConst.pullTag)
        if ever {
            refreshView?.state = .finish
        } else {
            refreshView?.state = .stop
        }
    }
    
    public func removePullRefresh() {
        let refreshView = self.refreshViewWithTag(PullRefreshConst.pullTag)
        refreshView?.removeFromSuperview()
    }
    
    public func startPushRefresh() {
        let refreshView = self.refreshViewWithTag(PullRefreshConst.pushTag)
        refreshView?.state = .refreshing
    }
    
    public func stopPushRefreshEver(_ ever: Bool = false) {
        let refreshView = self.refreshViewWithTag(PullRefreshConst.pushTag)
        if ever {
            refreshView?.state = .finish
        } else {
            refreshView?.state = .stop
        }
    }
    
    public func removePushRefresh() {
        let refreshView = self.refreshViewWithTag(PullRefreshConst.pushTag)
        refreshView?.removeFromSuperview()
    }
    
    public func fixedPullRefreshViewForDidScroll() {
        let pullRefreshView = self.refreshViewWithTag(PullRefreshConst.pullTag)
        if !PullRefreshConst.fixedTop || pullRefreshView == nil {
            return
        }
        var frame = pullRefreshView!.frame
        if self.contentOffset.y < -PullRefreshConst.height {
            frame.origin.y = self.contentOffset.y
            pullRefreshView!.frame = frame
        } else {
            frame.origin.y = -PullRefreshConst.height
            pullRefreshView!.frame = frame
        }
    }
}
