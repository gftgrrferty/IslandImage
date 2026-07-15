//
//  NotesManager.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/13.
//

import Foundation

class NotesManager {
    let userDefaults = UserDefaults(suiteName: appGroupID)!
    
    func getNotes() -> [NoteData] {
        if let data = userDefaults.data(forKey: "noteData"), // dataがあるかを確認する
           let notes = try? JSONDecoder().decode([NoteData].self, from: data) { // jsonからnoteDataにできるか
            return notes
        }
        
        return []
    }
    
    func saveNotes(_ notes: [NoteData]) {
        if let data = try? JSONEncoder().encode(notes) { // jsonにできるか
            userDefaults.set(data, forKey: "noteData")
        }
    }
    
    func setCurrentNote(_ note: NoteData) {
        userDefaults.set(note.id, forKey: "currentNote")
    }
}
