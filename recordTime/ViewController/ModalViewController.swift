//
//  ModalViewController.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/10.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

class ModalViewController: NSWindowController, NSWindowDelegate {
    private var panel: NSPanel! {
        get {
            return (self.window as! NSPanel)
        }
    }
    // MARK: Window lifecycle
    override func windowDidLoad() {
        super.windowDidLoad()
        print("window did load")
//        panel.isFloatingPanel = true
    }
    @IBAction func exit(_ sender: Any) {
        print("关闭自己")
    }
    //    override func windowWillEnterFullScreen() {
//        print("enter fail")
//    }
//    override func windowDidFailToExitFullScreen() {
//        print("fail")
//    }
}
