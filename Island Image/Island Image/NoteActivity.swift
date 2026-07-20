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
    
    static func start(endDate: Date? = nil) throws {
        endAll()
        
        let content = ActivityContent(
            state: createContentState(),
            staleDate: endDate
        )
        
        _ = try Activity.request(
            attributes: NoteActivityAttributes(),
            content: content,
            pushType: nil
        )
    }
    
    static func endAll() {
        let activities = Activity<NoteActivityAttributes>.activities
        Task.detached(priority: .userInitiated) {
            for activity in activities {
                await activity.end(activity.content, dismissalPolicy: .immediate)
            }
        }
    }
    
    static func refresh() {
        let activities = Activity<NoteActivityAttributes>.activities
        
        Task {
            for activity in activities {
                let content = ActivityContent(
                    state: createContentState(),
                    staleDate: activity.content.staleDate
                )
                
                await activity.update(content)
            }
        }
    }
    
    private static func createContentState() -> NoteActivityAttributes.ContentState {
        let currentNote = NotesManager().getCurrentNote()
        
        let contentState = NoteActivityAttributes.ContentState(
            noteText: currentNote?.text ?? "",
            imageURL: currentNote?.getImageURL()
        )
        
        return contentState
    }
}
