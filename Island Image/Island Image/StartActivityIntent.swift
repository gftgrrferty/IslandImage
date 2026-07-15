//
//  StartActivityIntent.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/16.
//

import AppIntents

struct StartActivityIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "ライブアクティビティを開始"
    
    // ショートカットが実行されたらperformが実行される
    @MainActor
    func perform() async throws -> some IntentResult {
        NoteActivityManager.start()
        return .result()
    }
}
