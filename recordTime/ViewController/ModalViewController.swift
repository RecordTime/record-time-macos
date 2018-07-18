//
//  ModalViewController.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/10.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

//let   kServerBaseUrl = "https://1851343155697899.cn-hangzhou.fc.aliyuncs.com/2016-08-15/proxy/record_time/record/"
let saveRecordUrl = "https://1851343155697899.cn-hangzhou.fc.aliyuncs.com/2016-08-15/proxy/record_time_dev/record/"

class ModalViewController: NSWindowController, NSWindowDelegate {
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
    }
    func windowDidBecomeMain(_ notification: Notification) {
        print("window did load")
//        trackerModel.subscribe(onTimeUpdate: callback)
    }
    private func callback(seconds: TimeInterval) {
        print("rest tick", seconds)
        if trackerModel.isResting {
            if seconds == 1 {
                closeWindow("auto close")
            }
            time.stringValue = trackerModel.timeRemainingDisplay
        }
    }
    func sendRecord(_ content: String) {
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
        let url = URL(string: saveRecordUrl)!
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
        sendRecord(content)
        self.view.window?.close()
    }
    @IBAction func saveRecord(_ sender: Any) {
        let content = contentField.stringValue
        sendRecord(content)
    }
    @IBAction func exit(_ sender: Any) {
        closeWindow("click exit")
    }
}
