//
//  AppDelegate.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/8.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var appController: StatusMenuController!
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        appController.refreshState()
    }
    /**
     * 当什么什么发生改变会调用？
     */
    func applicationDidChangeOcclusionState(_ notification: Notification) {
        if (NSApp.occlusionState.contains(.visible)) {
            // the app now became visible
            appController.refreshState()
        } else {
            // none of the app is visible anymore, so pause everything
//            appController.deactivate()
        }
    }

}

