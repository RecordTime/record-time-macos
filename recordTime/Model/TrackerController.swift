//
//  TrackerController.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/8.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

class TrackerController: NSObject, NSUserNotificationCenterDelegate {
    let formatter = DateFormatter()
    // MARK: 番茄钟相关属性
    var startTime: Date?
    var endTime: Date?
    var timer: Timer? = nil
    var duration: TimeInterval = 1500
    // MARK: 休息相关属性
    var startRestTime: Date?
    var endRestTime: Date?
    var restTimer: Timer? = nil
    var restDuration: TimeInterval = 300
    
    var tick: Date? = nil
    var timeRemainingDisplay: String = "00:00"
    // 过去的秒数
    var elapsedTime: TimeInterval = 0
    // 剩余的秒数
    var secondsRemaining: TimeInterval = 0
    // 时间变化回调
    var onTimeUpdate: ((String) -> ())? = nil
    // 时间变化回调
    var onRemaining: ((TimeInterval) -> ())? = nil
    
    var isStop: Bool {
        return timer == nil
    }
    var isPause: Bool {
        return timer == nil && elapsedTime > 0
    }
    // 开始番茄钟
    func initTiming() {
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
        // print(secondsRemaining, secondsRemaining < 0, secondsRemaining < -0, secondsRemaining == 0, secondsRemaining == -0)
        self.onTimeUpdate?(formatTimeString(for: secondsRemaining))
        self.onRemaining?(secondsRemaining)
        if secondsRemaining == 3 {
            restMessage()
        }
        if secondsRemaining <= 0 {
            elapsedTime = 0
            endTime = Date()
            stop()
            startRest()
        }
    }
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    /**
     * 开始休息
     */
    func startRest() {
//        if let url = URL(string: "https://www.google.com"), NSWorkspace.shared.open(url) {
//            print("default browser was successfully opened")
//        }
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
        self.onTimeUpdate?(formatTimeString(for: secondsRemaining))
        self.onRemaining?(secondsRemaining)
        if secondsRemaining == 3 {
            workMessage()
        }
        if secondsRemaining <= 0 {
            stopRest()
        }
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
        if timeRemaining == 0 {
            timeRemainingDisplay = ""
            return timeRemainingDisplay
        }
        let minutesRemaining = floor(timeRemaining / 60)
        let secondsRemaining = timeRemaining - (minutesRemaining * 60)
        
        let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
        timeRemainingDisplay = "\(Int(minutesRemaining)):\(secondsDisplay)"
        
        return timeRemainingDisplay
    }
    func getStrTime() -> String {
        return timeRemainingDisplay
    }
    func restMessage() {
        let userNotification = NSUserNotification()
        userNotification.title = "提示"
        userNotification.informativeText = "欢乐时光就要开始了"
        userNotification.soundName = NSUserNotificationDefaultSoundName
        // 使用 NSUserNotificationCenter 发送 NSUserNotification
        let userNotificationCenter = NSUserNotificationCenter.default
        
        userNotificationCenter.delegate = self
        userNotificationCenter.scheduleNotification(userNotification)
        // 将消息从消息中心移除
        NSUserNotificationCenter.default.removeDeliveredNotification(userNotification)
    }
    func workMessage() {
        let userNotification = NSUserNotification()
        userNotification.title = "提示"
        userNotification.informativeText = "准备工作了"
        userNotification.soundName = NSUserNotificationDefaultSoundName
        // 使用 NSUserNotificationCenter 发送 NSUserNotification
        let userNotificationCenter = NSUserNotificationCenter.default
        
        userNotificationCenter.delegate = self
        userNotificationCenter.scheduleNotification(userNotification)
        // 将消息从消息中心移除
        NSUserNotificationCenter.default.removeDeliveredNotification(userNotification)
    }
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    /**
     * 暴露给外部用以订阅的方法
     */
    func subscribe(onTimeUpdate: @escaping (String) -> ()) {
        self.onTimeUpdate = onTimeUpdate
    }
    /**
     * 暴露给外部用以订阅的方法
     */
    func on(callback: @escaping (TimeInterval) -> ()) {
        self.onRemaining = callback
    }
}
