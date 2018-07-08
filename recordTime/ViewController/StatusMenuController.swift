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
    @IBOutlet weak var recordView: RecorderView!
    @IBAction func startRecord(_ sender: Any) {
        print("hello swift, let us start!")
        trackerModel.initTiming(useSeconds: true)
    }
    @IBAction func exit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    override func awakeFromNib() {
        print("status awake from nib")
        if let button = statusItem.button {
            let icon = NSImage(named: NSImage.Name(rawValue: "icon"))
            icon?.isTemplate = true
            button.image = icon
        }
        statusItem.title = "Start"
        statusItem.menu = statusMenu
        trackerModel.subscribe(onTimeUpdate: updateMenuTitle)
    }
    func refreshState() {
        print("refresh state")
    }
    private func updateMenuTitle() {
        statusItem.title = trackerModel.getCurrentTime()
    }
    func render(for content: String) {
        print("invoke render", content)
        let fontAttr = [ NSAttributedStringKey.font: NSFont(name: "Helvetica Neue", size: 14.0)!]
        let font = NSAttributedString(string: content, attributes: fontAttr)
        statusItem.attributedTitle = font
    }
}
