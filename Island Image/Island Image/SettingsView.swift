//
//  SettingsView.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/15.
//
import SwiftUI

struct SettingsView: View {
    @AppStorage("hideLockScreenNote", store: userDefaults) var hideLockScreenNote: Bool = false
    @AppStorage("autoPaddingDynamicIsland", store: userDefaults) var autoPaddingDynamicIsland: Bool = false
    @AppStorage("trailingImage", store: userDefaults) var trailingImage: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: $hideLockScreenNote) {
                        Text("ロック画面でノートを非表示")
                    }
                    .onChange(of: hideLockScreenNote) {
                        NoteActivityManager.refresh()
                    }
                } footer: {
                    Text("ロック画面で表示されるノートを非表示にします。ただし枠は表示されます。")
                }
                Section {
                    Toggle(isOn: $autoPaddingDynamicIsland) {
                        Text("画像の周りに余白を追加")
                    }
                    .onChange(of: autoPaddingDynamicIsland) {
                        NoteActivityManager.refresh()
                    }
                } footer: {
                    Text("Dynamic Islandで画像が見切れないように余白を追加します。")
                }
                Section {
                    Toggle(isOn: $trailingImage) {
                        Text("画像を右側に表示")
                    }
                    .onChange(of: trailingImage) {
                        NoteActivityManager.refresh()
                    }
                } footer: {
                    Text("Dynamic Islandで画像を右側に表示します。")
                }
                NavigationLink(destination: AboutView()) {
                    Text("情報")
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    ContentView()
}
