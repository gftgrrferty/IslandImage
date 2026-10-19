//
//  EditNoteView.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/10/19.
//

import SwiftUI

struct EditNoteView: View {
    @Binding var note: NoteData
    @State var tmpColor: Color = Color.clear
    
    var body: some View {
        
        List {
            Section("メイン画像") {
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
