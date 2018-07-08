//
//  RecorderView.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/8.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

class RecorderView: NSView {

    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var contentField: NSTextField!
    @IBOutlet weak var submitBtn: NSButton!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    func formatTimeString(for timeRemaining: TimeInterval) -> String {
        if timeRemaining == 0 {
            return "Done!"
        }
        let minutesRemaining = floor(timeRemaining / 60)
        let secondsRemaining = timeRemaining - (minutesRemaining * 60)
        
        let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
        let timeRemainingDisplay = "\(Int(minutesRemaining)):\(secondsDisplay)"
        
        return timeRemainingDisplay
    }
    
    func update(tracker: Tracker) {
        // 在主线程更新 UI
        DispatchQueue.main.async() {
            let current = Date()
            tracker.endTime = current
            let dformatter = DateFormatter()
            
            dformatter.dateFormat="yyyy年MM月dd日HH:mm:ss"
            let currentStr = dformatter.string(from: current)
            let startStr = dformatter.string(from: tracker.startTime!)
            self.timeLabel.stringValue = startStr + currentStr
        }
    }
    
}
