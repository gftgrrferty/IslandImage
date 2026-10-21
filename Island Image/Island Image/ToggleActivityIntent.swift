//
//  ToggleActivityIntent.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/10/21.
//

import AppIntents

struct ToggleActivityIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "ライブアクティビティを切り替える"
    
    // ショートカットが実行されたらperformが実行される
    @MainActor
    func perform() async throws -> some IntentResult {
        // ライブアクティビティを切り替える
        if NoteActivityManager.isActive() {
            NoteActivityManager.endAll()
        } else {
            try NoteActivityManager.start()
        }
        return .result()
    }
}
