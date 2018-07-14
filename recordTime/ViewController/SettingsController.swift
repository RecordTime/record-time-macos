//
//  SettingsController.swift
//  CornerCal
//
//  Created by Emil Kreutzman on 21/10/2017.
//  Copyright © 2017 Emil Kreutzman. All rights reserved.
//

import Cocoa
struct SettingsKeys {
    // 是否显示时间
    let SHOW_TIME = "SHOW_TIME"
}

class SettingsController: NSObject, NSWindowDelegate {
    
    let defaults: UserDefaults!
    let keysToViewMap: [String]!
    let keys = SettingsKeys()
    
    @IBOutlet weak var trackerController: TrackerController!
    override init() {
        // 用户配置
        defaults = UserDefaults.standard
        defaults.synchronize()
        // 和设置面板上的顺序关联
        keysToViewMap = [
            keys.SHOW_TIME,
        ]
        
        super.init()
    }
    
    func windowDidBecomeMain(_ notification: Notification) {
        let boxMap: [NSButton] = [
            showSecondsBox,
        ]
        
        // read values of checkboxes from the settings, and apply!
        for i in 0...(boxMap.count - 1) {
            boxMap[i].state = defaults.bool(forKey: keysToViewMap[i]) ? .on : .off
        }
        
        updateAMPMEnabled()
    }
    
    func updateAMPMEnabled() {
//        showAMPMBox.isEnabled = use24HoursBox.state == .off
    }
    
    @IBOutlet weak var showSecondsBox: NSButton!
    
    @IBAction func checkBoxClicked(_ sender: NSButton) {
        // we use tags defined for views to recognize the right checkbox
        // checkboxes use tags starting from 1
        if (sender.tag > 0 && sender.tag <= keysToViewMap.count) {
            let key = keysToViewMap[sender.tag - 1]
            defaults.set(sender.state == .on, forKey: key)
            defaults.synchronize()
            
            updateAMPMEnabled()
            // 配置用户设置
//            calendarController.setDateFormat()
        }
    }
    
    
}
