//
//  BlockedSettingsViewController.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/14.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

class BlockedSettingsViewController: NSViewController, NSWindowDelegate {
    let defaults: UserDefaults! = UserDefaults.standard
    
    var datas = [NSDictionary]()
    var selectedApplication = [String]()
    var hasChangedSettings: Bool = false
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var settingsSaved: NSButton!
    
    func windowDidBecomeMain(_ notification: Notification) {
        self.datas = []
        selectedApplication = defaults.array(forKey: "blocked") as! [String]
        self.updateData()
        tableView.reloadData()
    }
    @IBAction func saveBlockSettings(_ sender: Any) {
        defaults.set(self.selectedApplication, forKey: "blocked")
        defaults.synchronize()
        settingsSaved.isEnabled = false
    }
    @IBAction func applicationSelected(_ sender: NSButton) {
        let index = tableView.row(for: sender)
        let state = sender.state
        let item = self.datas[index]
        let name = item.value(forKey: "application")
        let appIndex = self.selectedApplication.index(of: name as! String)
        // 保存
        if state.rawValue == 1 && appIndex == nil {
            self.selectedApplication.append(name as! String)
        }
        // 移除
        if state.rawValue == 0 && appIndex != nil {
            self.selectedApplication.remove(at: appIndex!)
        }
        settingsSaved.isEnabled = true
    }
    func updateData() {
//        try! print(FileManager().contentsOfDirectory(atPath: "/Applications"))
        for app in NSWorkspace.shared.runningApplications {
            let index = self.selectedApplication.index(of: app.localizedName!)
            let blocked = index != nil ? 1 : 0
            self.datas.append(["blocked": blocked, "application": app.localizedName, "icon": app.icon])
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
