//
//  EditNoteView.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/10/19.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct EditNoteView: View {
    @Binding var note: NoteData
    @State var tmpColor: Color = Color.clear
    @State private var pickerItem: PhotosPickerItem?
    
    var body: some View {
        
        List {
            Section("メイン画像") {
                // 画像を表示
                if let imageURL = note.getImageURL(subimage: false) {
                    // 画像を非同期で表示する
                    AsyncImage(url: imageURL) { image in
                        image.image?
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 50)
                    }
                }
            }
            Section("サブ画像") {
                // サブ画像を表示
                if let imageURL = note.getImageURL(subimage: true) {
                    // 画像を非同期で表示する
                    AsyncImage(url: imageURL) { image in
                        image.image?
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 50)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            note.deleteImage(subimage: true)
                        } label: {
                            Label("削除", systemImage: "trash")
                        }
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            note.deleteImage(subimage: true)
                        } label: {
                            Label("削除", systemImage: "trash")
                        }
                    }
                } else {
                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        Label("追加", systemImage: "plus")
                    }
                }
            }
            .onChange(of: pickerItem) {
                // ここでpickerItemがnilでないことを確定させる
                guard let pickerItem else { return }
                // 画像の保存を待ってからノートを保存する非同期処理。
                Task { 
                    guard let imageName = await NoteData.saveImageToFile(pickerItem) else { return }
                    note.saveImage(imageName, subimage: true)
                }
                self.pickerItem = nil
            }
            
            Section("ノート") {
                TextField("ノートを入力", text: $note.text)
                    .submitLabel(.done)
            }
            
            Section("Dynamic Islandの色") {
                ColorPicker(
                    "Dynamic Islandの色",
                    selection: $tmpColor,
                    supportsOpacity: false
                )
            }
            .onChange(of: tmpColor) {
                note.color = ColorHelper.uiColorToUInt32(UIColor(tmpColor))
            }
        }
        .onAppear() {
            tmpColor = ColorHelper.uInt32ToColor(note.color ?? 0x000000FF)
        }
        // 画面を閉じた時に実行される
        .onDisappear() {
            NoteActivityManager.refresh()
        }
    }
}

//#Preview {
//    EditNoteView()
//}
