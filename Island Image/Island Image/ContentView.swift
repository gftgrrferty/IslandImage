//
//  ContentView.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/08.
//

import PhotosUI
import SwiftUI
import ActivityKit

struct ContentView: View {
    private let manager = NotesManager()
    @State private var isNotesLoaded = false
    @Environment(\.scenePhase) private var scenePhase
    @State private var pickerItem: PhotosPickerItem?
    @State private var notes: [NoteData] = []
    @State var isShowSettingsView = false
    @State var isShowShortcutHintView = false
    @State var isActivityActive = false
    @State var isShowAlert = false
    @State var errorMessage = ""
    @AppStorage("currentNote", store: userDefaults) var currentNote: String = ""
    
    @Namespace private var ns_settingsView
    private let id_settingsViewButton = "id_settingsViewButton"
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
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
                            NavigationLink(destination: EditNoteView(note: $note)) {
                                HStack(spacing:20) {
                                    if let imageURL = note.getImageURL() {
                                        // 画像を非同期で表示する
                                        AsyncImage(url: imageURL) { image in
                                            image.image?
                                                .resizable()
                                                .interpolation(.none)
                                                .scaledToFit()
                                                .frame(width: 50)
                                        }
                                    }
                                    Text(note.text)
                                }
                            }
                            .id(note.id.uuidString)
                            .listRowBackground(
                                isActivityActive && note.id.uuidString == currentNote
                                ? Color(red:0.5,green:0.6,blue:1,opacity:0.3)
                                : nil
                            )
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
                                        do {
                                            try NoteActivityManager.start()
                                            isActivityActive = true
                                        } catch let error as ActivityAuthorizationError {
                                            switch error {
                                            case .denied:
                                                errorMessage = "ライブアクティビティが許可されていません。設定で許可してください。"
                                            case .globalMaximumExceeded:
                                                errorMessage = "ライブアクティビティの最大数に達したため、開始できません。"
                                            default:
                                                errorMessage = "エラーが発生したため開始できません。"
                                            }
                                            isShowAlert = true
                                        } catch {
                                            errorMessage = "エラーが発生したため開始できません。"
                                            isShowAlert = true
                                        }
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
                } // List
                .alert("エラー", isPresented: $isShowAlert) {
                    Button("OK") {
                    }
                } message: {
                    Text(errorMessage)
                }
                .navigationTitle("Island Image")
                .navigationBarTitleDisplayMode(.inline)
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
                        .matchedTransitionSource(id: id_settingsViewButton, in: ns_settingsView)
                        .sheet(isPresented: $isShowSettingsView) {
                            SettingsView()
                                .navigationTransition(.zoom(
                                    sourceID: id_settingsViewButton,
                                    in: ns_settingsView
                                ))
                        }
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
                        DispatchQueue.main.async {
                            withAnimation {
                                proxy.scrollTo("\(newNote.id.uuidString)")
                            }
                        }
                    }
                    self.pickerItem = nil
                }
            } // ScrollViewReader
        } // NavigationStack
        // バックグラウンドに行ったら保存してリフレッシュ
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .background:
                // データがある時かデータが確実に読み込めてる時
                if !notes.isEmpty || isNotesLoaded {
                    manager.saveNotes(notes) // データ保存
                    isNotesLoaded = true // 保存した時点で確定
                }
                NoteActivityManager.refresh()
            case .inactive:
                break
            case .active:
                // 起動時にノートが読み込めなかった時にもう一度読み込む
                // ノートが空の時且つ読み込みが確定してない時
                if notes.isEmpty && !isNotesLoaded {
                    notes = manager.getNotes() // データを読み込む
                    // データがある時
                    if !notes.isEmpty {
                        isNotesLoaded = true // 確実に読み込めたのが確定
                    }
                }
                // NoteActivityManagerのisActiveからLive Activityがオンかオフかを取得して、isActivityActiveに返り値を入れる
                isActivityActive = NoteActivityManager.isActive()
            @unknown default:
                break
            }
        }
        // NavigationStackが表示された時に実行される。
        .onAppear {
            notes = manager.getNotes() // データを読み込む
            // データがある時
            if !notes.isEmpty {
                isNotesLoaded = true // 確実に読み込めたのが確定
            }
        }
    }
}

#Preview {
    ContentView()
}
