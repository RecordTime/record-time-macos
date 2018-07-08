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
    
    var duration: TimeInterval = 60
    var elapsedTime: TimeInterval = 0
    var secondsRemaining: TimeInterval = 0
    var onTimeUpdate: ((String) -> ())? = nil
    var onCalendarUpdate: (() -> ())? = nil
    var onRemaining: ((TimeInterval) -> ())? = nil
    
    var timer: Timer? = nil
    var tick: Date? = nil
    var tickInterval: Double = 60
    
    var timeRemainingDisplay: String = "00:00"
    
    var isStop: Bool {
        return timer == nil && elapsedTime == 0
    }
    var isPause: Bool {
        return timer == nil && elapsedTime > 0
    }
    func initTiming(useSeconds: Bool) {
        
        tickInterval = (useSeconds) ? 1 : 60
        let now = Date()
        startTime = now
        timer?.invalidate()
        timer = Timer(fire: now, interval: tickInterval, repeats: true, block: onTick)
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
        if secondsRemaining <= 0 {
            stop()
        }
    }
    func stop() {
        timer?.invalidate()
        timer = nil
    }
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
        // print(timeRemaining == 0, timeRemaining == -0)
        if timeRemaining == 0 {
            timeRemainingDisplay = "Done!"
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
    /**
     * 暴露给外部用以订阅的方法
     */
    func subscribe(onTimeUpdate: @escaping (String) -> ()) {
        self.onTimeUpdate = onTimeUpdate
//        self.onCalendarUpdate = onCalendarUpdate
        
        if (tick == nil) {
//            onCalendarUpdate()
            setDateFormat()
        }
    }
    func on(callback: @escaping (TimeInterval) -> ()) {
        self.onRemaining = callback
    }
}
