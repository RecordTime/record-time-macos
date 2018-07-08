//
//  Timer.swift
//  TimeTracker
//
//  Created by ltaoo on 2018/7/7.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Foundation

protocol TrackerProtocol {
    func update(_ timer: Tracker, timeRemaining: TimeInterval)
    func hasFinished(_ timer: Tracker)
}

class Tracker {
    var startTime: Date?
    var endTime: Date?
    
    var duration: TimeInterval = 3
    var elapsedTime: TimeInterval = 0
    
    var timer: Timer?
    
    var delegate: TrackerProtocol?
    
    var isStop: Bool {
        return timer == nil && elapsedTime == 0
    }
    var isPause: Bool {
        return timer == nil && elapsedTime > 0
    }
    
    func start() {
        startTime = Date()
        // 初始化定时器
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(callback), userInfo: nil, repeats: true)
        callback()
    }
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc
    dynamic func callback() {
        // print("setInterval", Date())
        // guard 类似于 if 吧？所以如果 startTime 以及存在，表示已经开始了一个定时器，直接退出
        guard let startTime = startTime else { return }
        
        elapsedTime = -startTime.timeIntervalSinceNow
        let secondsRemaining = (duration - elapsedTime).rounded()
        // 结束了该次时间
        if secondsRemaining <= 0 {
            delegate?.hasFinished(self)
            stop()
        } else {
            delegate?.update(self, timeRemaining: secondsRemaining)
        }
    }
}
