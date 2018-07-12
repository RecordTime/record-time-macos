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
    var frontmostApplication: NSRunningApplication?
    let restIcon = NSImage(named: NSImage.Name(rawValue: "rest"))
    let workIcon = NSImage(named: NSImage.Name(rawValue: "work"))
    var blockSetting = true
    // 提供数据源
    @IBOutlet weak var trackerModel: TrackerController!
    // MARK: IB
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var startMenuItem: NSMenuItem!
    @IBOutlet weak var cancelBlockMenuItem: NSMenuItem!
    @IBAction func cancelBlock(_ sender: Any) {
        if blockSetting == true {
            blockSetting = false
        } else {
            blockSetting = true
        }
        cancelBlockMenuItem.title = "恢复屏蔽"
    }
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
            
            workIcon?.isTemplate = true
            button.image = workIcon
//            button.action = #selector(test)
        }
        statusItem.menu = statusMenu
        trackerModel.subscribe(onTimeUpdate: callback)
        trackerModel.statusChanged = updateMenu
//        print(NSWorkspace.shared.runningApplications)
    }
//    @objc func test() {
//        print("click btn")
//    }
    override func viewWillLayout() {
        self.viewWillLayout()
        print("will layout")
    }
    override func viewWillAppear() {
        self.viewWillAppear()
        print("will appear")
    }
    func windowDidBecomeMain(_ notification: Notification) {
        self.windowDidBecomeMain(notification)
        print("becom main")
    }
    func resetBlockSetting() {
        blockSetting = true
        cancelBlockMenuItem.title = "解除屏蔽"
    }
    func blockApplications() {
        print(blockSetting)
        if (blockSetting == false) {
            return
        }
        let activeApplication = NSWorkspace.shared.menuBarOwningApplication
        if activeApplication?.localizedName == "企业微信" && !(activeApplication?.isHidden)! {
            activeApplication?.hide()
        }
    }
    private func callback(seconds: TimeInterval) {
        print("tick", seconds)
        if trackerModel.isWorking {
            blockApplications()
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
    func updateMenu() {
        print("update menu", trackerModel.isWorking, trackerModel.isResting, trackerModel.isStop)
        if trackerModel.isWorking {
            startMenuItem.title = "结束番茄钟"
            return
        }
        if trackerModel.isResting {
            startMenuItem.title = "结束休息"
            return
        }
        if trackerModel.isStop {
            startMenuItem.title = "开始番茄钟"
            return
        }
    }
    @IBAction func menuItemClick(sender: AnyObject) {
        print("click")
    }
    func startWork() {
        trackerModel.startWork()
        resetBlockSetting()
        statusItem.button?.image = workIcon
    }
    func stopWork() {
        trackerModel.stopWork()
    }
    func startRest() {
        trackerModel.startRest()
        restIcon?.isTemplate = true
        statusItem.button?.image = restIcon
//        showModal()
        openUrl()
    }
    func stopRest() {
        trackerModel.stopRest()
    }
    func openUrl() {
        if let url = URL(string: "http://confluence.qunhequnhe.com/display/TB/NERV+2018.7.13"), NSWorkspace.shared.open(url) {
            print("default browser was successfully opened")
        }
    }
    func showModal() {
        let settingsWindowController = NSWindowController.init(window: modalView)
        modalView.setIsZoomed(true)
        settingsWindowController.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
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
    /**
     * 开始计时与结束计时
     */
    @IBAction func startWork(_ sender: Any) {
        if trackerModel.isWorking {
            stopWork()
            updateMenu()
            statusItem.title = nil
            return
        }
        if trackerModel.isResting {
            stopRest()
            updateMenu()
            statusItem.title = nil
            return
        }
        if trackerModel.isStop {
            startWork()
            return
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
