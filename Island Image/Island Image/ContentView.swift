//
//  ContentView.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/08.
//

import SwiftUI

struct ContentView: View {
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
    }
}

#Preview {
    ContentView()
}
