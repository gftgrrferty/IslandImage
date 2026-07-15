//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by Cizzuk on 2026/07/15.
//

import WidgetKit
import SwiftUI

#if DEBUG_DROPCAT
let appGroupID: String = "group.net.cizzuk.test.net.abidaze.Island-Image"
#else
let appGroupID: String = "group.net.abidaze.Island-Image"
#endif

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        NoteActivityWidget()
    }
}
