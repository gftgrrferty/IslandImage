//
//  ShortcutHintView.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/17.
//

import SwiftUI

struct ShortcutHintView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("ライブアクティビティは最大8時間経過するとシステムに強制終了されてしまいます。")
                    Text("そのため、ショートカットを使用して8時間ごとに自動で再開することで永続化することができます。")
                } header: {
                    Text("なぜ必要か")
                }
                Section {
                    Text("ショートカットのオートメーションで8時間ごとにアクティビティを開始するショートカットを設定してください。")
                    HStack(spacing: 10) {
                        Image("ShortcutHint1")
                            .resizable()
                            .scaledToFit()
                            .accessibilityLabel("オートメーションの作成画面。毎日8時すぐに実行に設定されている。")
                        Image("ShortcutHint2")
                            .resizable()
                            .scaledToFit()
                            .accessibilityLabel("Island Imageのライブアクティビティを開始ショートカットが設定されている")
                        Image("ShortcutHint3")
                            .resizable()
                            .scaledToFit()
                            .accessibilityLabel("0時,8時,16時にオートメーションが設定されている画像")
                    }
                } header: {
                    Text("設定方法")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Label("閉じる", systemImage: "xmark")
                    }
                }
            }
            .navigationTitle("ショートカットのヒント")
        }
    }
}

#Preview {
    ShortcutHintView()
}
