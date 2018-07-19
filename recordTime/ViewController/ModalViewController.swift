//
//  ModalViewController.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/10.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

let saveRecordUrl = "https://1851343155697899.cn-hangzhou.fc.aliyuncs.com/2016-08-15/proxy/record_time/record/"
let dev_saveRecordUrl = "https://1851343155697899.cn-hangzhou.fc.aliyuncs.com/2016-08-15/proxy/record_time_dev/record/"

class ModalViewController: NSWindowController, NSWindowDelegate {
    let defaults: UserDefaults = UserDefaults.standard
    
    @IBOutlet weak var view: NSView!
    @IBOutlet weak var time: NSTextField!
    @IBOutlet weak var trackerModel: TrackerController!
    @IBOutlet weak var contentField: NSTextField!
    
    private var panel: NSPanel! {
        get {
            return (self.window as! NSPanel)
        }
    }
    // MARK: Window lifecycle
    override func awakeFromNib() {
        print("awake")
        trackerModel.subscribe(onTimeUpdate: callback)
        trackerModel.on(event: "sleep", cb: closeWindow)
        trackerModel.on(event: "break", cb: closeWindow)
        // 如果 webhook 不存在，就不显示输入框
//        let webhook = defaults.string(forKey: "webhook")!
//        if webhook != nil && webhook != "" {
//        }
    }
    func windowDidBecomeMain(_ notification: Notification) {
        print("window did load")
//        trackerModel.subscribe(onTimeUpdate: callback)
    }
    private func callback(seconds: TimeInterval) {
        print("rest tick", seconds, trackerModel.isResting)
        if trackerModel.isResting {
            time.stringValue = trackerModel.timeRemainingDisplay
            if seconds == 0 {
                closeWindow("auto close")
            }
        }
    }
    func sendRecord(_ content: String) {
        let webhook = defaults.string(forKey: "webhook")!
        print("web hook", webhook)
        let startTime = String(
            CLongLong(
                round(
                    (trackerModel.startTime?.timeIntervalSince1970)! * 1000
                )
            )
        )
        let endTime = String(
            CLongLong(
                round(
                    (trackerModel.endTime?.timeIntervalSince1970)! * 1000
                )
            )
        )
        //使⽤缺省对配置
        let defaultConfigObject = URLSessionConfiguration.default
        //创建 session
        let session = URLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: webhook)!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = ["starttime": startTime, "endtime": endTime, "content": content] as [String : Any]
        print(data);
        request.httpBody = try! JSONSerialization.data(withJSONObject: data, options: [])
        let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
        task.resume()
    }
    func completionHandler(data: Data?, response: URLResponse?, err: Error?) {
        print("post success", data, response, err)
    }
    func closeWindow(_ content: String) {
        let webhook = defaults.string(forKey: "webhook")!
        if webhook != nil && webhook != "" {
            sendRecord(content)
        }
//        sendRecord(content)
        self.view.window?.close()
    }
    @IBAction func saveRecord(_ sender: Any) {
        let content = contentField.stringValue
        closeWindow(content)
    }
    @IBAction func exit(_ sender: Any) {
        closeWindow("click exit")
    }
}
