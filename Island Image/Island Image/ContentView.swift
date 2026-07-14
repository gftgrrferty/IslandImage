//
//  ContentView.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/08.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    private let manager = NotesManager()
    @State private var pickerItem: PhotosPickerItem?
    @State private var notes: [NoteData] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($notes, id: \.id) { $note in
                    VStack {
                        TextField("ノートを入力", text: $note.text)
                        // 画像を表示
                        if let imageURL = note.getImageURL() {
                            // 画像を非同期で表示する
                            AsyncImage(url: imageURL) { image in
                                //
                                image.image?
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                    }
                }
            }
            .toolbar {
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    Label("追加", systemImage: "plus")
                }
            }
        }
        .onChange(of: notes) {
            manager.saveNotes(notes)
        }
        // 画像が選択されたら新しいノートを作成して画像を保存する。
        .onChange(of: pickerItem) {
            // ここでpickerItemがnilでないことを確定させる
            guard let pickerItem else { return }
            var newNote = NoteData()
            // 画像の保存を待ってからノートを保存する非同期処理。
            Task {
                await newNote.saveImage(pickerItem)
                notes.append(newNote)
            }
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
