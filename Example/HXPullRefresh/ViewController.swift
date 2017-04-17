//
//  ViewController.swift
//  HXPullRefresh
//
//  Created by Insofan on 04/17/2017.
//  Copyright (c) 2017 Insofan. All rights reserved.
//

import UIKit
import SnapKit
import HXPullRefresh

fileprivate let reuseCell = "reuseCell"
class ViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: reuseCell)
        //        tableView.backgroundColor = .red
        return tableView
    }()
    
    fileprivate func setupTableView() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
    }
    
    //Const
    fileprivate var languageArray = ["Swift", "ObjC", "Go", "Html", "JavaScript", "Java", "C", "Ruby", "C#", "C++", "Bootstrap", "Django", "PHP", "Python", "Scala"]
    
    //Table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: reuseCell)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.textLabel?.text = languageArray[(indexPath as NSIndexPath).row]
        return cell
        
    }
    
    //Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Example"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupTableView()
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        var pullOptions = PullRefreshOption()
        
        //Now time
        let now = NSDate()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "HH:mm:ss"
        
        pullOptions.refreshLabelText = dformatter.string(from: now as Date)
        pullOptions.indicatorColor = .black
        pullOptions.refreshLabelTextColor = .black
        pullOptions.refreshLabelTextFont = 18
        self.tableView.addPullRefresh(options:pullOptions) { [weak self] in
            sleep(1)
            self?.languageArray.random()
            self?.tableView.reloadData()
            self?.tableView.stopPullRefreshEver()
        }
        
        var options = PullRefreshOption()
        options.refreshLabelText = "Anything you want"
        self.tableView.addPushRefresh(options: options) { [weak self] in
            sleep(1)
            self?.languageArray.random()
            self?.tableView.reloadData()
            //如果只刷新一次加true
            //self?.tableView.stopPushRefreshEver(true)
            self?.tableView.stopPushRefreshEver()
        }
    }
}

