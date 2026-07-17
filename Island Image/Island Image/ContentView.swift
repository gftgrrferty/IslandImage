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
    @Environment(\.scenePhase) private var scenePhase
    @State private var pickerItem: PhotosPickerItem?
    @State private var notes: [NoteData] = []
    @State var isShowSettingsView = false
    @State var isShowShortcutHintView = false
    @State var isActivityActive = false
    @AppStorage("currentNote", store: userDefaults) var currentNote: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                if notes.isEmpty {
                    Section {} footer: {
                        VStack {
                            Text("画像を追加してください。")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                
                Section {
                    ForEach($notes, id: \.id) { $note in
                        HStack(spacing: 20) {
                            // 画像を表示
                            if let imageURL = note.getImageURL() {
                                // 画像を非同期で表示する
                                AsyncImage(url: imageURL) { image in
                                    //
                                    image.image?
                                        .resizable()
                                        .interpolation(.none)
                                        .scaledToFit()
                                        .frame(width: 50)
                                }
                            }
                            TextField("ノートを入力", text: $note.text)
                                .submitLabel(.done)
                                .onSubmit {
                                    manager.saveNotes(notes)
                                    if manager.getCurrentNote()?.id == note.id {
                                        NoteActivityManager.refresh()
                                    }
                                }
                        }
                        .frame(minHeight: 50)
                        // Live Activityを開始するためのボタン
                        .swipeActions(edge: .leading) {
                            if isActivityActive && note.id.uuidString == currentNote {
                                Button {
                                    NoteActivityManager.endAll()
                                    isActivityActive = false
                                } label: {
                                    Label("アクティビティ停止", systemImage: "stop")
                                }
                                .tint(.red)
                            } else {
                                Button {
                                    manager.setCurrentNote(note)
                                    NoteActivityManager.start()
                                    isActivityActive = true
                                } label: {
                                    Label("アクティビティ開始", systemImage: "play")
                                }
                                .tint(.blue)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            // 削除ボタン
                            Button(role: .destructive) {
                                if manager.getCurrentNote()?.id == note.id {
                                    NoteActivityManager.endAll()
                                }
                                note.deleteImage()
                                notes.removeAll { $0.id == note.id }
                                manager.saveNotes(notes)
                            } label: {
                                Label("削除", systemImage: "trash")
                            }
                        }
                    }
                } footer: {
                    if !notes.isEmpty {
                        VStack(spacing: 10) {
                            Text("ノートを横にスワイプしてアクティビティを開始。")
                                .frame(maxWidth: .infinity, alignment: .center)
                            Button {
                                isShowShortcutHintView = true
                            } label: {
                                Text("ショートカットでライブアクティビティを永続化する方法はこちら")
                                    .font(.caption)
                            }
                            .sheet(isPresented: $isShowShortcutHintView) {
                                ShortcutHintView()
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        Label("追加", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isShowSettingsView = true
                    } label: {
                        Label("設定", systemImage: "gearshape")
                    }
                    .sheet(isPresented: $isShowSettingsView) {
                        SettingsView()
                    }
                }
            }
        }
        // バックグラウンドに行ったら保存してリフレッシュ
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .background:
                manager.saveNotes(notes)
                NoteActivityManager.refresh()
            case .inactive:
                break
            case .active:
                // NoteActivityManagerのisActiveからLive Activityがオンかオフかを取得して、isActivityActiveに返り値を入れる
                isActivityActive = NoteActivityManager.isActive()
            @unknown default:
                break
            }
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
                manager.saveNotes(notes)
            }
            self.pickerItem = nil
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
