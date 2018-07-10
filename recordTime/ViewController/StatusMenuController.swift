//
//  StatusMenuController.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/8.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

class StatusMenuController: NSViewController, NSUserNotificationCenterDelegate, NSWindowDelegate {
    // 增加状态栏图标
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let userNotificationCenter = NSUserNotificationCenter.default
    // 提供数据源
    @IBOutlet weak var trackerModel: TrackerController!
    // MARK: IB
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var startMenuItem: NSMenuItem!
    
    @IBAction func exitRest(_ sender: Any) {
    }
    @IBOutlet weak var settingsWindow: NSWindow!
    @IBOutlet weak var recorderWindow: NSWindow!
    
    @IBOutlet weak var modalView: NSPanel!
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
        print("tick", seconds)
        if trackerModel.isWorking {
            if seconds <= 0 {
                stopWork()
                startRest()
            }
            if seconds == 10 {
                sendRestMessage()
            }
        } else {
            if seconds <= 0 {
                stopRest()
                startWork()
            }
            if seconds == 3 {
                sendWorkMessage()
            }
        }
        updateMenuTitle(title: trackerModel.timeRemainingDisplay)
    }
    private func updateMenuTitle(title: String) {
        let fontAttr = [ NSAttributedStringKey.font: NSFont(name: "Gill Sans", size: 14.0)!]
        let font = NSAttributedString(string: title, attributes: fontAttr)
        statusItem.attributedTitle = font
    }
    func updateMenu(isWorking: Bool) {
        if isWorking {
            startMenuItem.title = "停止计时"
        } else {
            startMenuItem.title = "开始计时"
        }
    }
    @IBAction func menuItemClick(sender: AnyObject) {
        print("click")
    }
    func refreshState() {
        print("refresh state")
    }
    func startWork() {
        updateMenu(isWorking: true)
        trackerModel.startWork()
    }
    func stopWork() {
        trackerModel.stopWork()
    }
    func startRest() {
        trackerModel.startRest()
        showModal()
    }
    func showModal() {
        let settingsWindowController = NSWindowController.init(window: modalView)
//        settingsWindowController.center()
//        settingsWindowController.toggleFullScreen(nil)
        modalView.setIsZoomed(true)
//        modalView.isFloatingPanel = true
//        modalView.worksWhenModal = true
//        modalView.frame = NSRect(dictionaryRepresentation: <#T##CFDictionary#>)
        settingsWindowController.showWindow(nil)
//        settingsWindowController.toggleFullScreen(nil)
//        settingsWindowController.makeKey()
//
//        modalView.toggleFullScreen(nil)
        // bring settings window to front
//        let frame = CGRect(x: 0, y: 0, width: 400, height: 280)
//        let style: NSWindow.StyleMask = [.titled,.closable,.resizable,.hudWindow,.fullScreen]
//        //创建window
//        myWindow = NSWindow(contentRect:frame, styleMask:style, backing:.buffered, defer:false)
//        myWindow.title = "New Create Window"
//        //显示window
//        myWindow.makeKeyAndOrderFront(self);
//        //居中
//        myWindow.center()
        NSApp.activate(ignoringOtherApps: true)
    }
    func stopRest() {
        trackerModel.stopRest()
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
    @objc func sendRestMessage() {
        notify(title: "TimeTracker", description: "欢乐时光就要开始了~", stayCenter: true)
    }
    func sendWorkMessage() {
        notify(title: "TimeTracker", description: "开打开打!", stayCenter: true)
    }
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    @IBAction func startWork(_ sender: Any) {
        if trackerModel.isWorking {
            stopWork()
            updateMenu(isWorking: false)
            statusItem.title = nil
        } else {
            startWork()
        }
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
