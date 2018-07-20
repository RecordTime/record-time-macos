//
//  RecordController.swift
//  recordTime
//
//  Created by ltaoo on 2018/7/8.
//  Copyright © 2018年 ltaoo. All rights reserved.
//

import Cocoa

struct Record {
    let startTime: Date
    let endTime: Date
    let content: String
    
    var description: String {
        get {
            return "\"\(startTime) ~ \(endTime)\" — \(content)"
        }
    }
}

class RecordController: NSObject {
    var records: [Record] = []
    
    func save(item: Record) {
        records.append(item)
    }
    func show() -> [Record] {
        return records
    }
}
