//
//  TrackerController.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/8.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

enum TRACK_STATUS: NSNumber {
    case STOP = 0
    case WORKING = 1
    case RESTING = 2
}

class TrackerController: NSObject {
    let formatter = DateFormatter()
    // MARK: 番茄钟相关属性
    var startTime: Date?
    var endTime: Date?
    var workTimer: Timer? = nil
    var duration: TimeInterval = 1500
//    var duration: TimeInterval = 10
    // MARK: 休息相关属性
    var startRestTime: Date?
    var endRestTime: Date?
    var restTimer: Timer? = nil
    var restDuration: TimeInterval = 300
//    var restDuration: TimeInterval = 6
    
    // 过去的秒数
    var elapsedTime: TimeInterval = 0
    // 剩余的秒数
    var secondsRemaining: TimeInterval = 0
    var events: [String: (String) -> ()] = [:]
    var timeRemainingDisplay: String {
        get {
            return formatTimeString(for: secondsRemaining)
        }
    }
    // 时间变化回调
    var onTimeUpdate: ((TimeInterval) -> ())? = nil
    var listeners: [(TimeInterval) -> ()] = []
    var statusChanged: (() -> ())? = nil
    
    var isWorking: Bool {
        return workTimer != nil
    }
    var isResting: Bool {
        return restTimer != nil
    }
    var isStop: Bool {
        return workTimer == nil && restTimer == nil
    }
    func on(event: String, cb: @escaping (String) -> ()) {
        events[event] = cb
    }
    func emit(event: String) {
        let cb = events[event]
        cb!(event)
    }
    // 开始番茄钟
    func startWork() {
        // todo: 如果正在跑一个，就不能开始
        stopRest()
        let now = Date()
        startTime = now
        workTimer?.invalidate()
        workTimer = Timer(fire: now, interval: 1, repeats: true, block: onTick)
        // 靠这个走计时器，
        RunLoop.main.add(workTimer!, forMode: RunLoopMode.commonModes)
        onTick(timer: workTimer!)
        statusChanged?()
    }
    private func onTick(timer: Timer) {
        guard let startTime = startTime else { return }
        
        elapsedTime = -startTime.timeIntervalSinceNow
        secondsRemaining = (duration - elapsedTime).rounded()
        for listener in self.listeners {
            listener(secondsRemaining)
        }
    }
    func stopWork() {
        if workTimer != nil {
            workTimer?.invalidate()
            workTimer = nil
        }
        endTime = Date()
        statusChanged?()
    }
    /**
     * 开始休息
     */
    func startRest() {
        stopWork()
        let now = Date()
        startRestTime = now
        restTimer?.invalidate()
        restTimer = Timer(fire: now, interval: 1, repeats: true, block: onRestTick)
        // 靠这个走计时器，
        RunLoop.main.add(restTimer!, forMode: RunLoopMode.commonModes)
        onRestTick(timer: restTimer!)
        statusChanged?()
    }
    private func onRestTick(timer: Timer) {
        guard let startTime = startRestTime else { return }
        
        elapsedTime = -startTime.timeIntervalSinceNow
        secondsRemaining = (restDuration - elapsedTime).rounded()
        for listener in self.listeners {
            listener(secondsRemaining)
        }
    }
    func stopRest() {
        if restTimer != nil {
            restTimer?.invalidate()
            restTimer = nil
        }
        endRestTime = Date()
        statusChanged?()
    }
    /**
     * 格式化时间
     */
    private func formatTimeString(for timeRemaining: TimeInterval) -> String {
        var timeRemainingDisplay: String = ""
        if timeRemaining == 0 {
            return timeRemainingDisplay
        }
        let minutesRemaining = floor(timeRemaining / 60)
        let secondsRemaining = timeRemaining - (minutesRemaining * 60)
        let minutesDisplay = String(format: "%02d", Int(minutesRemaining))
        let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
        timeRemainingDisplay = "\(minutesDisplay):\(secondsDisplay)"
        
        return timeRemainingDisplay
    }
    /**
     * 暴露给外部用以订阅的方法
     */
    func subscribe(onTimeUpdate: @escaping (TimeInterval) -> ()) {
        self.listeners.append(onTimeUpdate)
    }
}
