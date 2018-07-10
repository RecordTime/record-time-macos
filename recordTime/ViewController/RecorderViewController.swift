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
    
    var dateformatter: DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func refreshState() {
        print("refresh state")
    }
    func callback(content: TimeInterval) {
        dateformatter.dateFormat = "HH:mm:ss"
        if trackerModel.isStop {
            let start = dateformatter.string(from: trackerModel.startTime!)
            let end = dateformatter.string(from: trackerModel.endTime!)
            startTime.stringValue = start
            endTime.stringValue = end
        }
    }
    
    @IBAction func submit(_ sender: Any) {
    }
}

extension RecorderViewController {
    
}
