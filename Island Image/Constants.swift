//
//  Constants.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/15.
//

import Foundation

#if DEBUG_DROPCAT
let appGroupID: String = "group.net.cizzuk.test.net.abidaze.Island-Image"
#else
let appGroupID: String = "group.net.abidaze.Island-Image"
#endif

let userDefaults = UserDefaults(suiteName: appGroupID)!
