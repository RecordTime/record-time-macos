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
    
    func updateData() {
//        try! print(FileManager().contentsOfDirectory(atPath: "/Applications"))
//        print(NSWorkspace.shared.runningApplications)
        for app in NSWorkspace.shared.runningApplications {
            print(app.icon)
        }
        self.datas = [
            ["blocked": false, "application": "企业微信"]
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
    }
}
