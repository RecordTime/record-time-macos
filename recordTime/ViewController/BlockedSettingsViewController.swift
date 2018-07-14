//
//  BlockedSettingsViewController.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/14.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

class BlockedSettingsViewController: NSViewController, NSWindowDelegate {
    @IBOutlet weak var table: NSWindow!
    
    @IBOutlet weak var tableView: NSTableView!
    var datas = [NSDictionary]()
    func windowDidBecomeMain(_ notification: Notification) {
        // print("once")
        self.updateData()
        tableView.reloadData()
    }
    @IBAction func applicationSelected(_ sender: NSButton) {
        let index = tableView.row(for: sender)
        let state = sender.state
        let item = self.datas[index]
        print(item, state)
    }
    func updateData() {
//        try! print(FileManager().contentsOfDirectory(atPath: "/Applications"))
        for app in NSWorkspace.shared.runningApplications {
            self.datas.append(["blocked": 0, "application": app.localizedName, "icon": app.icon])
        }
    }
    
}

extension BlockedSettingsViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.datas.count
    }
}
extension BlockedSettingsViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let data = self.datas[row]
        let key = (tableColumn?.identifier)!
        let view = tableView.makeView(withIdentifier: key, owner: self) as! NSTableCellView
        if tableColumn == tableView.tableColumns[1] {
            view.imageView?.image = data.value(forKey: "icon") as? NSImage
            view.textField?.stringValue = data.value(forKey: "application") as! String
        }
        if tableColumn == tableView.tableColumns[0] {
            let checkBoxField = view.subviews[0] as! NSButton
            checkBoxField.state = NSControl.StateValue(rawValue: data.value(forKey: "blocked") as! Int)
        }
        return view
    }
}
