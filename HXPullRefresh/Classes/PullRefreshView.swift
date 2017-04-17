//
//  PullRefreshView.swift
//  HXPullRefresh
//
//  Created by 海啸 on 2017/4/16.
//  Copyright © 2017年 海啸. All rights reserved.
//

import UIKit
import SnapKit

open class PullRefreshView: UIView {
    
    enum PullRefreshState {
        case pulling
        case triggered
        case refreshing
        case stop
        case finish
    }
    
    // MARK: Variables, KVO的keyPath
    let contentOffsetKeyPath = "contentOffset"
    let contentSizeKeyPath = "contentSize"
    var kvoContext = "PullRefreshKVOContext"
    
    //MARK:Const
    fileprivate let screenWidth = UIScreen.main.bounds.width
    
    fileprivate var options: PullRefreshOption
    fileprivate var backgroundView: UIView
    fileprivate var arrow: UIImageView
    fileprivate var refreshLabel: UILabel
    fileprivate var indicator: UIActivityIndicatorView
    fileprivate var scrollViewInsets: UIEdgeInsets = UIEdgeInsets.zero
    fileprivate var refreshCompletion:((Void) -> Void)?
    fileprivate var pull: Bool = true
    
    fileprivate var positionY: CGFloat = 0 {
        //监视属性变化后positionY的值
        didSet {
            if self.positionY == oldValue {
                return
            }
            var frame = self.frame
            frame.origin.y = positionY
            self.frame = frame
            
        }
    }
    
    var state: PullRefreshState = PullRefreshState.pulling {
        didSet {
            if self.state == oldValue {
                return
            }
            switch self.state {
            case .stop:
                stopAnimation()
                
            case .finish:
                var duration = PullRefreshConst.animationDuration
                var time = DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                
                DispatchQueue.main.asyncAfter(deadline: time) {
                    self.stopAnimation()
                }
                duration *= 2
                time = DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time) {
                    self.removeFromSuperview()
                }
                
            case .refreshing:
                startAnimation()
                
            case .pulling:
                arrowRotationBack()
                
            case .triggered:
                arrowRotation()
            }
        }
    }
    
    //MARK: Init UIView
    public override convenience init(frame: CGRect) {
        self.init(options: PullRefreshOption(), frame: frame, refreshCompletion: nil)
    }
    public required init(coder aDecoder: NSCoder) {
        fatalError("init has error")
    }
    
    public init(options: PullRefreshOption, frame: CGRect, refreshCompletion :((Void) -> Void)?, down:Bool = true) {
        self.options = options
        self.refreshCompletion = refreshCompletion
        
        //backgroundView
        self.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width , height: frame.size.height))
        self.backgroundView.backgroundColor = self.options.backgroundColor
        //自动调整view的宽度，保证左边距和右边距不变
        self.backgroundView.autoresizingMask = .flexibleWidth
        
        //arrow
        self.arrow = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        self.arrow.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        self.arrow.image = UIImage(named: PullRefreshConst.imageName, in: Bundle(for: type(of:self)), compatibleWith: nil)
        
        //refresh Label
        self.refreshLabel = UILabel(frame: CGRect(x: 0, y: 0, width:screenWidth/3, height: 30))
        self.refreshLabel.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        self.refreshLabel.textAlignment = .left
        self.refreshLabel.text = options.refreshLabelText
        self.refreshLabel.textColor = options.refreshLabelTextColor
        self.refreshLabel.font = UIFont.systemFont(ofSize: options.refreshLabelTextFont)
        self.refreshLabel.isHidden = true

        
        self.indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.indicator.bounds = self.arrow.bounds
        self.indicator.frame.size.height = 200
        self.indicator.frame.size.width = 200
        self.indicator.autoresizingMask = self.arrow.autoresizingMask
        self.indicator.hidesWhenStopped = true
        self.indicator.color = options.indicatorColor
        self.pull = down
        
        super.init(frame: frame)
        self.addSubview(indicator)
        self.addSubview(backgroundView)
        self.addSubview(arrow)
        self.addSubview(refreshLabel)
        self.autoresizingMask = .flexibleWidth
        
    }
    
    
    
    
    //MARK: Set arrow and refreshLabel frame
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.arrow.center = CGPoint(x: self.screenWidth/4, y: self.frame.size.height/2)
        self.arrow.frame = arrow.frame.offsetBy(dx: 0, dy: 0)
        
        self.refreshLabel.center = CGPoint(x: self.screenWidth/4, y: self.frame.size.height/2)
        //与arrow的左侧离开5 30/2 + 15 = 30
        self.refreshLabel.frame = refreshLabel.frame.offsetBy(dx: self.screenWidth/4+30, dy: 0)
        
        self.indicator.center = self.arrow.center
    }
    
    open override func willMove(toSuperview superView: UIView!) {
        //superview NOT superView, DO NEED to call the following method
        //superview dealloc will call into this when my own dealloc run later!!
        self.removeRegister()
        guard let scrollView = superView as? UIScrollView else {
            return
        }
        scrollView.addObserver(self, forKeyPath: contentOffsetKeyPath, options: .initial, context: &kvoContext)
        if !pull {
            scrollView.addObserver(self, forKeyPath: contentSizeKeyPath, options: .initial, context: &kvoContext)
        }
    }
    
    
    fileprivate func removeRegister() {
        if let scrollView = superview as? UIScrollView {
            scrollView.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &kvoContext)
            if !pull {
                scrollView.removeObserver(self, forKeyPath: contentSizeKeyPath, context: &kvoContext)
            }
        }
    }
    
    deinit {
        self.removeRegister()
    }
    
    //MARK: KVO
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = object as? UIScrollView else {
            return
        }
        if keyPath == contentSizeKeyPath {
            self.positionY = scrollView.contentSize.height
            return
        }
        
        if !(context == &kvoContext && keyPath == contentOffsetKeyPath) {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        //Pulling state check
        let offsetY = scrollView.contentOffset.y
        
        //Alpha set
        if PullRefreshConst.alpha {
            var alpha = fabs(offsetY) / (self.frame.size.height + 40)
            if alpha > 0.8 {
                alpha = 0.8
            }
            self.arrow.alpha = alpha
        }
        
        if offsetY <= 0 {
            if !self.pull {
                return
            }
            
            if offsetY < -self.frame.size.height {
                //pulling or refreshing
                if scrollView.isDragging == false && self.state != .refreshing {
                    self.state       = .refreshing
                } else if self.state != .refreshing{
                    //starting point, start from pulling
                    self.state       = .triggered
                }
            } else if self.state == .triggered {
                self.state = .pulling
            }
            return
        }
        
        //push up
        let upHeight = offsetY + scrollView.frame.size.height - scrollView.contentSize.height
        if upHeight > 0 {
            if self.pull {
                return
            }
            
            if upHeight > self.frame.size.height {
                //pulling or refreshing
                if scrollView.isDragging == false && self.state != .refreshing {
                    self.state = .refreshing
                } else if self.state != .refreshing {
                    self.state = .triggered
                }
            } else if self.state == .triggered {
                self.state = .pulling
            }
        }
    }
    
    //MARK: Animate
    fileprivate func startAnimation() {
        self.indicator.startAnimating()
        self.arrow.isHidden = true
        self.refreshLabel.isHidden = false
        guard let scrollView = superview as? UIScrollView else {
            return
        }
        scrollViewInsets = scrollView.contentInset
        
        var insets = scrollView.contentInset
        if pull {
            insets.top += self.frame.size.height
        } else {
            insets.bottom += self.frame.size.height
        }
        scrollView.bounces = false
        
        UIView.animate(withDuration: PullRefreshConst.animationDuration,
                       delay: 0,
                       options:[],
                       animations: {
                        scrollView.contentInset = insets
        },
                       completion: { _ in
                        if self.options.autoStopTime != 0 {
                            let time = DispatchTime.now() + Double(Int64(self.options.autoStopTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: time) {
                                self.state = .stop
                            }
                        }
                        self.refreshCompletion?()
        })
        
    }
    
    fileprivate func stopAnimation() {
        self.indicator.stopAnimating()
        self.arrow.isHidden = false
        self.refreshLabel.isHidden = true
        guard let scrollView = superview as? UIScrollView else {
            return
        }
        scrollView.bounces = true
        let duration = PullRefreshConst.animationDuration
        UIView.animate(withDuration: duration,
                       animations: {
                        scrollView.contentInset = self.scrollViewInsets
                        self.arrow.transform = CGAffineTransform.identity
        }, completion: { _ in
            self.state = .pulling
        }
        )
    }
    
    fileprivate func arrowRotation() {
        UIView.animate(withDuration: PullRefreshConst.animationDuration*1.5, delay: 0, options:[], animations: {
            // -0.0000001 for the rotation direction control
            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        }, completion:nil)
    }
    
    fileprivate func arrowRotationBack() {
        UIView.animate(withDuration: 0.2, animations: {
            self.arrow.transform = CGAffineTransform.identity
        })
    }
}
