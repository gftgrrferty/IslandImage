//
//  NotesManager.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/13.
//

import Foundation

class NotesManager {
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
        userDefaults.set(note.id.uuidString, forKey: "currentNote")
    }
    
    func getCurrentNote() -> NoteData? {
        let idString = userDefaults.string(forKey: "currentNote")
        let notes = getNotes()
        
        if let idString, let id = UUID(uuidString: idString) {
            return notes.first(where: { $0.id == id }) ?? nil
        }
        
        return nil
    }
}
