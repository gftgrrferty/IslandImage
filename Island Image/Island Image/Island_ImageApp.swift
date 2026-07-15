//
//  Island_ImageApp.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/08.
//

import SwiftUI

#if DEBUG_DROPCAT
let appGroupID: String = "group.net.cizzuk.test.net.abidaze.Island-Image"
#else
let appGroupID: String = "group.net.abidaze.Island-Image"
#endif

@main
struct Island_ImageApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
