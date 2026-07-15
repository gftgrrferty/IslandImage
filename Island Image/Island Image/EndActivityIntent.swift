//
//  EndActivityIntent.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/16.
//

import AppIntents

struct EndActivityIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "ライブアクティビティを終了"
    
    // ショートカットが実行されたらperformが実行される
    @MainActor
    func perform() async throws -> some IntentResult {
        NoteActivityManager.endAll()
        return .result()
    }
}
