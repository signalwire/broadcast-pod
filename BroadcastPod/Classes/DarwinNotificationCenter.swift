//
//  DarwinNotificationCenter.swift
//  BroadcastPod
//
//  Created by Zeeshan Saiyed on 15/09/21.
//

import Foundation

public enum DarwinNotification: String {
    case broadcastStarted = "iOS_BroadcastStarted"
    case broadcastStopped = "iOS_BroadcastStopped"
}

public class DarwinNotificationCenter {
    
    public static let shared = DarwinNotificationCenter()
    
    private let notificationCenter: CFNotificationCenter
    
    init() {
        notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
    }
    
    public func postNotification(_ name: DarwinNotification) {
        CFNotificationCenterPostNotification(notificationCenter, CFNotificationName(rawValue: name.rawValue as CFString), nil, nil, true)
    }
}
