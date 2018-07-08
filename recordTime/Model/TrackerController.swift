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
    let monthFormatter = DateFormatter()
    var locale: Locale!
    
    var startTime: Date?
    var endTime: Date?
    
    var duration: TimeInterval = 3
    var elapsedTime: TimeInterval = 0
    var onTimeUpdate: (() -> ())? = nil
    var onCalendarUpdate: (() -> ())? = nil
    
    var timer: Timer?
    var tick: Date? = nil
    var tickInterval: Double = 60
    
    var isStop: Bool {
        return timer == nil && elapsedTime == 0
    }
    var isPause: Bool {
        return timer == nil && elapsedTime > 0
    }
    
//    func start() {
//        startTime = Date()
//        // 初始化定时器
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(callback), userInfo: nil, repeats: true)
//        callback()
//    }
    func initTiming(useSeconds: Bool) {
        tickInterval = (useSeconds) ? 1 : 60
        let now = Date()
        timer = Timer(fire: now, interval: tickInterval, repeats: true, block: onTick)
    }
    private func onTick(timer: Timer) {
        self.onTimeUpdate?()
    }
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
//    @objc
//    dynamic func callback() {
//        // print("setInterval", Date())
//        // guard 类似于 if 吧？所以如果 startTime 以及存在，表示已经开始了一个定时器，直接退出
//        guard let startTime = startTime else { return }
//
//        elapsedTime = -startTime.timeIntervalSinceNow
//        let secondsRemaining = (duration - elapsedTime).rounded()
//        self.onTimeUpdate!()
//    }
    /**
     * 将时间格式化
     */
    func setDateFormat() {
        let defaults = UserDefaults.standard
        let keys = SettingsKeys()
        
        let showSeconds = defaults.bool(forKey: keys.SHOW_SECONDS_KEY)
        let use24Hours = defaults.bool(forKey: keys.USE_HOURS_24_KEY)
        let showAMPM = defaults.bool(forKey: keys.SHOW_AM_PM_KEY)
        let showDate = defaults.bool(forKey: keys.SHOW_DATE_KEY)
        let showDayOfWeek = defaults.bool(forKey: keys.SHOW_DAY_OF_WEEK_KEY)
        let showAnyDateInfo = showDayOfWeek || showDate
        
        formatter.locale = locale
        
        var dateTemplate = ""
        dateTemplate += (showDayOfWeek) ? "EEE" : ""
        dateTemplate += (showDate) ? "dMMM" : ""
        
        formatter.setLocalizedDateFormatFromTemplate(dateTemplate)
        let dateFormat = (showAnyDateInfo) ? formatter.dateFormat!.replacingOccurrences(of: ",", with: "") + "  " : ""
        
        var timeTemplate = "mm"
        timeTemplate += (showSeconds) ? "ss" : ""
        timeTemplate += (use24Hours) ? "H" : "h"
        
        formatter.setLocalizedDateFormatFromTemplate(timeTemplate)
        var timeFormat = formatter.dateFormat!
        
        if (use24Hours || !showAMPM) {
            timeFormat = timeFormat.replacingOccurrences(of: "a", with: "")
        }
        
        formatter.dateFormat = String(format: "%@%@", dateFormat, timeFormat)
//        initTiming(useSeconds: showSeconds)
    }
    /**
     * 格式化时间
     */
    private func formatTimeString(for timeRemaining: TimeInterval) -> String {
        if timeRemaining == 0 {
            return "Done!"
        }
        let minutesRemaining = floor(timeRemaining / 60)
        let secondsRemaining = timeRemaining - (minutesRemaining * 60)
        
        let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
        let timeRemainingDisplay = "\(Int(minutesRemaining)):\(secondsDisplay)"
        
        return timeRemainingDisplay
    }
    func getCurrentTime() -> String {
        return "00:00"
    }
    /**
     * 暴露给外部用以订阅的方法
     */
    func subscribe(onTimeUpdate: @escaping () -> ()) {
        self.onTimeUpdate = onTimeUpdate
//        self.onCalendarUpdate = onCalendarUpdate
        
        if (tick == nil) {
//            onCalendarUpdate()
            setDateFormat()
        }
    }
}
