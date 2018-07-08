//
//  StatusMenuController.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/8.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

class StatusMenuController: NSViewController {
    // model
    var timer = Tracker()
    // 增加状态栏图标
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBOutlet weak var statusMenu: NSMenu!
    
    override func awakeFromNib() {
//        let icon = NSImage(named: "statusBarIcon")
//        icon?.template = true // best for dark mode
//        statusItem.image = icon
//        statusItem.menu = statusMenu
        // 在应用启动后，给图标一个图片显示
        if let button = statusItem.button {
            
            button.image = NSImage(named: NSImage.Name(rawValue: "icon"))
        }
        statusItem.title = "25:00"
        statusItem.menu = statusMenu
    }
    
    @IBAction func startRecord(_ sender: Any) {
        
        print("hello swift, let us start!")
        timer.start()
    }
    @IBAction func exit(_ sender: Any) {
        
        NSApplication.shared.terminate(self)
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
//    func showMainView() {
//        mainWindowController?.showWindow(nil)
//        let current = Date()
//        timer.endTime = current
//        let dformatter = DateFormatter()
//
//        dformatter.dateFormat="yyyy年MM月dd日HH:mm:ss"
//        let currentStr = dformatter.string(from: current)
//        let startStr = dformatter.string(from: timer.startTime!)
//        print(startStr, currentStr)
//    }
    func render(for timeRemaining: TimeInterval) {
        let time = formatTimeString(for: timeRemaining)
        print("invoke render", time)
        //        remainingLabel.stringValue = time
        let fontAttr = [ NSAttributedStringKey.font: NSFont(name: "Helvetica Neue", size: 14.0)!]
        let font = NSAttributedString(string: time, attributes: fontAttr)
        statusItem.attributedTitle = font
    }
    
}

extension StatusMenuController: TrackerProtocol {
    func update(_ timer: Tracker, timeRemaining: TimeInterval) {
        render(for: timeRemaining)
    }
    func hasFinished(_ timer: Tracker) {
        render(for: 0)
        // 弹出窗口填写记录
//        showMainView()
    }
}
