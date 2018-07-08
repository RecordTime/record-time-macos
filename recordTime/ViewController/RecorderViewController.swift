//
//  RecorderViewController.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/8.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

class RecorderViewController: NSViewController {

    @IBOutlet weak var trackerModel: TrackerController!
    @IBOutlet weak var startTime: NSTextField!
    @IBOutlet weak var endTime: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear() {
        print("hi?")
    }
    
    func refreshState() {
        print("refresh state")
        trackerModel.on(callback: callback)
    }
    func callback(content: TimeInterval) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm:ss"
        
        // print("当前日期时间：\(dateformatter.stringFromDate(now))")
        let start = dateformatter.string(from: trackerModel.startTime!)
        let now = dateformatter.string(from: Date())
        startTime.stringValue = start
        endTime.stringValue = now
    }
    
    @IBAction func submit(_ sender: Any) {
    }
}

extension RecorderViewController {
    
}
