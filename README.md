# HXPullRefresh

[![CI Status](http://img.shields.io/travis/Insofan/HXPullRefresh.svg?style=flat)](https://travis-ci.org/Insofan/HXPullRefresh)
[![Version](https://img.shields.io/cocoapods/v/HXPullRefresh.svg?style=flat)](http://cocoapods.org/pods/HXPullRefresh)
[![License](https://img.shields.io/cocoapods/l/HXPullRefresh.svg?style=flat)](http://cocoapods.org/pods/HXPullRefresh)
[![Platform](https://img.shields.io/cocoapods/p/HXPullRefresh.svg?style=flat)](http://cocoapods.org/pods/HXPullRefresh)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Swift 3

## Screen Shot

![iMEDg.gif](http://storage1.imgchr.com/iMEDg.gif)



## Installation

#### Manual

Just drag HXPullRefresh folder to your project.

#### Cocoapod

HXPullRefresh is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "HXPullRefresh"
```

## Usage

#### 1.Import HXPullRefresh

`import HXPullRefresh`

#### 2.Custom HXPullRefresh

```
var options = PullRefreshOption()
options.refreshLabelText = "Anything you want"
```

##### There are more options if you need

```
options.backgroundColor: UIColor //The backgroundColor
options.indicatorColor: UIColor //The indicatorColor
options.autoStopTime: Double //0 is not auto stop
options.fixedSectionHeader: Bool //Update the content inset for fixed section headers    
//refreshLabel option
options.refreshLabelText: String //Label text
options.refreshLabelTextColor: UIColor//Label text color
options.refreshLabelTextFont: CGFloat//Label text font size
//You can also replace arrow image with yourself
```

#### 3.Call pull or push refresh

```
self.tableView.addPushRefresh(options: options) { [weak self] in
            sleep(1)
            self?.tableView.reloadData()
            //如果只刷新一次加true
            //if you want only refresh onece time add true
            //self?.tableView.stopPushRefreshEver(true)
            self?.tableView.stopPushRefreshEver()
}
```

More sample in example's ViewController.swift

## Author

Insofan, insofan3156@gmail.com

## License

HXPullRefresh is available under the MIT license. See the LICENSE file for more info.
