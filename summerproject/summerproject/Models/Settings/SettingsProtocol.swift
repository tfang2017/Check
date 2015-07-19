//
//  SettingsProtocol.swift
//  summerproject
//
//  Created by Zheng Hao Tan on 7/13/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation

protocol SettingsProtocol {
    
    var notificationSettings: NotificationSettings? { get set }
    var privacySettings: PrivacySettings? { get set }

}