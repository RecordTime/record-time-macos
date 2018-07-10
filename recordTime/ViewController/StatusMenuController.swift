//
//  StatusMenuController.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/8.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

class StatusMenuController: NSViewController, NSUserNotificationCenterDelegate {
    // 增加状态栏图标
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let userNotificationCenter = NSUserNotificationCenter.default
    // 提供数据源
    @IBOutlet weak var trackerModel: TrackerController!
    // MARK: IB
    @IBOutlet weak var statusMenu: NSMenu!
    
    @IBOutlet weak var settingsWindow: NSWindow!
    @IBOutlet weak var recorderWindow: NSWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    override func awakeFromNib() {
        userNotificationCenter.delegate = self
        
        if let button = statusItem.button {
            let icon = NSImage(named: NSImage.Name(rawValue: "icon"))
            icon?.isTemplate = true
            button.image = icon
        }
        statusItem.menu = statusMenu
        trackerModel.subscribe(onTimeUpdate: callback)
    }
    private func callback(seconds: TimeInterval) {
        updateMenuTitle(title: trackerModel.timeRemainingDisplay)
    }
    private func updateMenuTitle(title: String) {
        let fontAttr = [ NSAttributedStringKey.font: NSFont(name: "Gill Sans", size: 14.0)!]
        let font = NSAttributedString(string: title, attributes: fontAttr)
        statusItem.attributedTitle = font
    }
    func refreshState() {
        print("refresh state")
    }
    private func notify(title: String, description: String, stayCenter: Bool) {
        let userNotification = NSUserNotification()
        userNotification.title = title
        userNotification.informativeText = description
        userNotification.soundName = NSUserNotificationDefaultSoundName
        userNotificationCenter.scheduleNotification(userNotification)
        if !stayCenter {
            NSUserNotificationCenter.default.removeDeliveredNotification(userNotification)
        }
    }
    func sendRestMessage() {
        notify(title: "TimeTracker", description: "欢乐时光就要开始了~", stayCenter: true)
    }
    func workMessage() {
        notify(title: "TimeTracker", description: "开打开打!", stayCenter: true)
    }
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}

extension StatusMenuController {
    @IBAction func startWrok(_ sender: Any) {
        trackerModel.startWork()
    }
    @IBAction func openSettings(_ sender: Any) {
        let settingsWindowController = NSWindowController.init(window: settingsWindow)
        settingsWindowController.showWindow(sender)
        // bring settings window to front
        NSApp.activate(ignoringOtherApps: true)
    }
    @IBAction func exit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
}
