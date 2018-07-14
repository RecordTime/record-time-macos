//
//  BlockedSettingsViewController.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/14.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

class BlockedSettingsViewController: NSViewController {
    @IBOutlet weak var table: NSWindow!
    
    @IBOutlet weak var tableView: NSTableView!
    var datas = [NSDictionary]()
    override func awakeFromNib() {
        super.viewDidLoad()
        // Do view setup here.
        print("did load")
        self.updateData()
    }
    override func viewWillAppear() {
        print("will appeare")
    }
    
    func updateData() {
//        try! print(FileManager().contentsOfDirectory(atPath: "/Applications"))
//        print(NSWorkspace.shared.runningApplications)
//        for app in NSWorkspace.shared.runningApplications {
//            self.datas.append(["blocked": 0, "application": app.localizedName, "icon": app.icon])
//        }
        self.datas = [
            ["blocked": "hello", "application": "企业微信"]
        ]
    }
    
}

extension BlockedSettingsViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.datas.count
    }
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let data = self.datas[row]
        // 表格列的标识
        let key = tableColumn?.identifier
        // 单元格数据
        let value = data[key!]
        return value
//        let view = tableView.makeView(withIdentifier: key!, owner: self)
//        let subviews = view?.subviews
//        if (subviews?.count)! <= 0 {
//            return nil
//        }
//        print(key?.rawValue, value, subviews)
//        if key?.rawValue == "application" {
//            let textField = subviews?[1] as! NSTextField
//            if value != nil {
//                textField.stringValue = value as! String
//            }
//        }
//        if key?.rawValue == "blocked" {
//            let textField = subviews?[1] as! NSTextField
//            if value != nil {
//                textField.stringValue = value as! String
//            }
//        }
//        if key?.rawValue == "icon" {
//            let imgView = subviews?[0] as! NSImageView
//            if value != nil {
//                imgView.image = value as! NSImage
//            }
//        }
//        if key?.rawValue == "blocked" {
//            let checkBoxField = subviews?[0] as! NSButton
//            checkBoxField.state = NSControl.StateValue(rawValue: value as! Int)
//        }
        return view
    }
}
