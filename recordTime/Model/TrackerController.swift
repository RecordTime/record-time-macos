//
//  TrackerController.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/8.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

class TrackerController: NSObject {
    let formatter = DateFormatter()
    // MARK: 番茄钟相关属性
    var startTime: Date?
    var endTime: Date?
    var timer: Timer? = nil
//    var duration: TimeInterval = 1500
    var duration: TimeInterval = 10
    // MARK: 休息相关属性
    var startRestTime: Date?
    var endRestTime: Date?
    var restTimer: Timer? = nil
    var restDuration: TimeInterval = 300
//    var restDuration: TimeInterval = 3
    
    var tick: Date? = nil
    // 过去的秒数
    var elapsedTime: TimeInterval = 0
    // 剩余的秒数
    var secondsRemaining: TimeInterval = 0
    var timeRemainingDisplay: String {
        get {
            return formatTimeString(for: secondsRemaining)
        }
    }
    // 时间变化回调
    var onTimeUpdate: ((TimeInterval) -> ())? = nil
    
    @IBOutlet weak var modalWindow: NSWindow!
    @IBAction func stopModal(_ sender: Any) {
        NSApplication.shared.stopModal()
    }
    var isStop: Bool {
        return timer == nil
    }
    var isPause: Bool {
        return timer == nil && elapsedTime > 0
    }
    // 开始番茄钟
    func startWork() {
        // todo: 如果正在跑一个，就不能开始
        let now = Date()
        startTime = now
        timer?.invalidate()
        timer = Timer(fire: now, interval: 1, repeats: true, block: onTick)
        // 靠这个走计时器，
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        onTick(timer: timer!)
    }
    private func onTick(timer: Timer) {
        guard let startTime = startTime else { return }
        
        elapsedTime = -startTime.timeIntervalSinceNow
        secondsRemaining = (duration - elapsedTime).rounded()
        self.onTimeUpdate?(secondsRemaining)
    }
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    /**
     * 开始休息
     */
    func startRest() {
//        NSApplication.shared.runModal(for: self.modalWindow)
        let now = Date()
        startRestTime = now
        restTimer?.invalidate()
        restTimer = Timer(fire: now, interval: 1, repeats: true, block: onRestTick)
        // 靠这个走计时器，
        RunLoop.main.add(restTimer!, forMode: RunLoopMode.commonModes)
        onRestTick(timer: restTimer!)
    }
    private func onRestTick(timer: Timer) {
        guard let startTime = startRestTime else { return }
        
        elapsedTime = -startTime.timeIntervalSinceNow
        secondsRemaining = (restDuration - elapsedTime).rounded()
        self.onTimeUpdate?(secondsRemaining)
    }
    private func stopRest() {
        restTimer?.invalidate()
        restTimer = nil
    }
    /**
     * 格式化时间
     */
    private func formatTimeString(for timeRemaining: TimeInterval) -> String {
        // print(timeRemaining == 0, timeRemaining == -0)
        var timeRemainingDisplay: String = ""
        if timeRemaining == 0 {
            return timeRemainingDisplay
        }
        let minutesRemaining = floor(timeRemaining / 60)
        let secondsRemaining = timeRemaining - (minutesRemaining * 60)
        
        let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
        timeRemainingDisplay = "\(Int(minutesRemaining)):\(secondsDisplay)"
        
        return timeRemainingDisplay
    }
    /**
     * 暴露给外部用以订阅的方法
     */
    func subscribe(onTimeUpdate: @escaping (TimeInterval) -> ()) {
        self.onTimeUpdate = onTimeUpdate
    }
}
