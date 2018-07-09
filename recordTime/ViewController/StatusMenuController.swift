//
//  StatusMenuController.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/8.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa


protocol UpdateMainViewProtocol {
    func updateView()
}

class StatusMenuController: NSViewController {
    // 增加状态栏图标
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    // 提供数据源
    @IBOutlet weak var trackerModel: TrackerController!
    // MARK: IB
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var contentMenuItem: NSMenuItem!
    @IBOutlet weak var settingsWindow: NSWindow!
    @IBOutlet weak var recorderWindow: NSWindow!
    @IBAction func startRecord(_ sender: Any) {
        trackerModel.initTiming()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    override func awakeFromNib() {
        if let button = statusItem.button {
            let icon = NSImage(named: NSImage.Name(rawValue: "icon"))
            icon?.isTemplate = true
            button.image = icon
        }
//        let fontAttr = [ NSAttributedStringKey.font: NSFont(name: "Gill Sans", size: 14.0)!]
//        let font = NSAttributedString(string: "23:14", attributes: fontAttr)
//        statusItem.attributedTitle = font
        statusItem.menu = statusMenu
        trackerModel.subscribe(onTimeUpdate: callback)
    }
    func refreshState() {
        print("refresh state")
    }
    private func callback(title: String) {
        updateMenuTitle(title: trackerModel.timeRemainingDisplay)
        if trackerModel.secondsRemaining == 0 {
//            let recorderWindowController = NSWindowController.init(window: recorderWindow)
//            recorderWindowController.showWindow(nil)
            
            // bring settings window to front
//            NSApp.activate(ignoringOtherApps: true)
        }
    }
    private func updateMenuTitle(title: String) {
//        let fontAttr = [ NSAttributedStringKey.font: NSFont(name: "Herculanum", size: 12.0)!]
        let fontAttr = [ NSAttributedStringKey.font: NSFont(name: "Gill Sans", size: 14.0)!]
        let font = NSAttributedString(string: title, attributes: fontAttr)
        statusItem.attributedTitle = font
        
    }
}
