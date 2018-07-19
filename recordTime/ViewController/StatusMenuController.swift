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
    let defaults = UserDefaults.standard
    // 提供数据源
    @IBOutlet weak var trackerModel: TrackerController!
    // MARK: IB
    @IBOutlet weak var countdownView: NSPanel!
    @IBOutlet weak var countdownBar: NSProgressIndicator!
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
    @IBAction func openBlockList(_ sender: Any) {
        let settingsWindowController = NSWindowController.init(window: blockedSettingsWindow)
        settingsWindowController.showWindow(sender)
        // bring settings window to front
        NSApp.activate(ignoringOtherApps: true)
    }
    @IBOutlet weak var settingsWindow: NSWindow!
    @IBOutlet weak var recorderWindow: NSWindow!
    @IBOutlet weak var blockedSettingsWindow: NSWindow!
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
        }
        statusItem.menu = statusMenu
        trackerModel.subscribe(onTimeUpdate: callback)
        trackerModel.statusChanged = updateMenu
        registerScreenStatusNotify()
    }
    // 监听息屏
    func registerScreenStatusNotify() {
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.recieveSleepNotification), name: NSWorkspace.screensDidSleepNotification, object:  nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.recieveSleepNotification), name: NSWorkspace.screensDidWakeNotification, object: nil)
    }
    @objc func recieveSleepNotification(notification: NSNotification) {
        if (notification.name == NSWorkspace.screensDidSleepNotification) {
            print("sleep")
            stopRest()
            stopWork()
            trackerModel.emit(event: "sleep")
        }
        if (notification.name == NSWorkspace.screensDidWakeNotification) {
            print("wakeup")
        }
    }
    // MARK: 恢复屏蔽状态
    func resetBlockSetting() {
        blockSetting = true
        cancelBlockMenuItem.title = "解除屏蔽"
    }
    // 隐藏应用
    func blockApplications() {
        if (blockSetting == false) {
            return
        }
        let blocked = defaults.array(forKey: "blocked") as! [String]
        let activeApplication = NSWorkspace.shared.menuBarOwningApplication
        let name = activeApplication?.localizedName
        if name != nil {
            let index = blocked.index(of: name!)
            if index != nil && activeApplication?.isHidden == false {
                activeApplication?.hide()
            }
        }
    }
    // 倒计时，最核心的事件，所有处理都是从这里判断
    private func callback(seconds: TimeInterval) {
        print("tick", seconds)
        if trackerModel.isWorking {
            blockApplications()
            if seconds <= 0 {
                stopWork()
                startRest()
            }
//            if seconds < 0 {
//                hideCountdown()
//            }
            if seconds == 10 {
                sendRestMessage()
//                showCountdown()
            }
//            if seconds < 10 {
//                updateCountdown(current: (10 - seconds) / 10 * 100)
//            }
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
    // 更新 StatusItem 上的时间
    private func updateMenuTitle(title: String) {
        let keys = SettingsKeys()
        let showSeconds = defaults.bool(forKey: keys.SHOW_TIME)
        if showSeconds == false {
            if statusItem.title != nil {
                statusItem.title = nil
            }
            return
        }
        let fontAttr = [ NSAttributedStringKey.font: NSFont(name: "Gill Sans", size: 14.0)!]
        let font = NSAttributedString(string: title, attributes: fontAttr)
        statusItem.attributedTitle = font
    }
    // 更新菜单上的文案
    func updateMenu() {
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
    // 进入番茄时间
    func startWork() {
        trackerModel.startWork()
        resetBlockSetting()
        statusItem.button?.image = workIcon
    }
    // 结束番茄时间
    func stopWork() {
        trackerModel.stopWork()
        statusItem.title = nil
    }
    // 开始休息
    func startRest() {
        trackerModel.startRest()
        restIcon?.isTemplate = true
        statusItem.button?.image = restIcon
        showModal()
        // openUrl()
    }
    // 结束休息
    func stopRest() {
        trackerModel.stopRest()
        statusItem.title = nil
    }
    // 打开指定网页
    func openUrl() {
        if let url = URL(string: "http://confluence.qunhequnhe.com/display/TB/NERV+2018.7.16"), NSWorkspace.shared.open(url) {
            print("default browser was successfully opened")
        }
    }
    // 显示休息时的模态框
    func showModal() {
        let modalViewController = NSWindowController.init(window: modalView)
        modalView.setIsZoomed(true)
        modalViewController.showWindow(nil)
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
    func showCountdown() {
        let settingsWindowController = NSWindowController.init(window: countdownView)
        settingsWindowController.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
        countdownBar.startAnimation(self)
    }
    func updateCountdown(current: Double) {
        countdownBar.doubleValue = current
//        countdownBar.increment(by: current)
        
        
    }
    func hideCountdown() {
        countdownView.close()
    }
    func toString(dateFormat:String, time: Date) -> String {
        
        let dateFormatter:DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = dateFormat
        
        let formattedDatetimeStr:String = dateFormatter.string(from: time)
        
        return formattedDatetimeStr
        
    }
    /**
     * 开始计时与结束计时
     */
    @IBAction func startWork(_ sender: Any) {
        if trackerModel.isWorking {
            stopWork()
            trackerModel.emit(event: "break")
            updateMenu()
//            statusItem.title = nil
            return
        }
        if trackerModel.isResting {
            stopRest()
            updateMenu()
//            statusItem.title = nil
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
