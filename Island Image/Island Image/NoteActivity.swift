//
//  NoteActivity.swift
//  Island Image
//
//  Created by Cizzuk on 2026/07/15.
//

import ActivityKit
import Foundation

nonisolated struct NoteActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var noteText: String
        var imageURL: URL?
    }
}

class NoteActivityManager {
    static func isActive() -> Bool {
        return !Activity<NoteActivityAttributes>.activities.isEmpty
    }
    
    static func start(endDate: Date? = nil) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activityが有効ではありません。")
            return
        }
        
        endAll()
        
        let currentNote = NotesManager().getCurrentNote()
        
        let attributes = NoteActivityAttributes()
        let contentState = NoteActivityAttributes.ContentState(
            noteText: currentNote?.text ?? "",
            imageURL: currentNote?.getImageURL()
        )
        
        let content = ActivityContent(
            state: contentState,
            staleDate: endDate
        )
        
        do {
            _ = try Activity.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
        } catch {
            print("Live Activityの開始に失敗しました: \(error)")
        }
    }
    
    static func endAll() {
        let activities = Activity<NoteActivityAttributes>.activities
        Task.detached(priority: .userInitiated) {
            for activity in activities {
                await activity.end(activity.content, dismissalPolicy: .immediate)
            }
        }
    }
}
