//
//  ContentView.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/08.
//

import SwiftUI

struct ContentView: View {
    let manager = NotesManager()
    @State var notes: [NoteData] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($notes, id: \.id) { $note in
                    TextField("ノートを入力", text: $note.text)
                }
            }
            .toolbar {
                Button(action: {
                    notes.append(NoteData())
                }) {
                    Label("追加", systemImage: "plus")
                }
            }
        }
        .onChange(of: notes) {
            manager.saveNotes(notes)
        }
        // NavigationStackが表示された時に実行される。
        .onAppear {
            notes = manager.getNotes()
        }
    }
}

#Preview {
    ContentView()
}
