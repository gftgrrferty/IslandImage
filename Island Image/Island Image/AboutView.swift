//
//  AboutView.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/15.
//
import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Section {
                HStack {
                    let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                    let currentBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
                    Label("バージョン", systemImage: "info.circle")
                        .foregroundStyle(.primary)
                    Spacer()
                    Text("\(currentVersion ?? "Unknown") (\(currentBuild ?? "Unknown"))")
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                }
                .accessibilityElement(children: .combine)
                HStack {
                    Label("デベロッパー", systemImage: "hammer")
                        .foregroundStyle(.primary)
                    Spacer()
                    Link(destination:URL(string: "https://abidaze.net/")!, label: {
                        Text("あび")
                    })
                }
                Link(destination:URL(string: "https://github.com/gftgrrferty/ImageIsland")!, label: {
                    Label("ソースコード", systemImage: "ladybug")
                })
                Link(destination:URL(string: "https://gftgrrferty.net/privacypolicy/")!, label: {
                    Label("プライバシーポリシー", systemImage: "hand.raised")
                })
            } header: {
                Text("Island Image")
            }
            
            Section {} header: {
                Text("ライセンス")
            } footer: {
                Text("MIT License\n\nCopyright (c) 2026 gftgrrferty\n\nPermission is hereby granted, free of charge, to any person obtaining a copy\nof this software and associated documentation files (the \"Software\"), to deal\nin the Software without restriction, including without limitation the rights\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell\ncopies of the Software, and to permit persons to whom the Software is\nfurnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\nSOFTWARE.")
                    .environment(\.layoutDirection, .leftToRight)
                    .textSelection(.enabled)
                    .padding(.bottom, 40)
            }
        }
        .navigationTitle("情報")
        .navigationBarTitleDisplayMode(.inline)
    }
}
