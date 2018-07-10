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
    
    @IBAction func submit(_ sender: Any) {
    }
}

extension RecorderViewController {
    
}
