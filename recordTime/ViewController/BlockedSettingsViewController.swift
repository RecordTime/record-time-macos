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
        for app in NSWorkspace.shared.runningApplications {
            self.datas.append(["blocked": 0, "application": app.localizedName, "icon": app.icon])
        }
//        self.datas = [
//            ["blocked": "hello", "application": "企业微信"]
//        ]
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
        //        print(tableColumn, tableView.tableColumns[1])
        if tableColumn == tableView.tableColumns[1] {
//            image = data.value(forKey: "icon") as! NSImage
//            text = data.value(forKey: "application") as! String
//            identifier = (tableColumn?.identifier)!.rawValue
            view.imageView?.image = data.value(forKey: "icon") as! NSImage
            view.textField?.stringValue = data.value(forKey: "application") as! String
        }
        if tableColumn == tableView.tableColumns[0] {
            print("blocked", data)
        }
//        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: nil) as? NSTableCellView {
//            cell.textField?.stringValue = text
//            cell.imageView?.image = image ?? nil
//            return cell
//        }
        return view
        // 表格列的标识
//        let key = tableColumn?.identifier
//        // 单元格数据
//        let value = data[key!]
//        let view = tableView.makeView(withIdentifier: key!, owner: self) as? NSTableCellView
//        let subviews = view?.subviews
//
//        print(key, key?.rawValue, value, subviews)
//        if (subviews?.count)! <= 0 {
//            return nil
//        }
//        if key?.rawValue == "application" {
//            let textField = subviews?[1] as! NSTextField
//            print(textField)
//            textField.stringValue = value as! String
//        }
//        if key?.rawValue == "blocked" {
//            let textField = subviews?[0] as! NSTextField
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
//        view?.imageView?.image = value
//        view?.textField?.stringValue = value as! String
        return view
    }
}
