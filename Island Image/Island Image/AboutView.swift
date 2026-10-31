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
                Link(destination:URL(string: "https://github.com/gftgrrferty/IslandImage")!, label: {
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
            Section {} header: {
                Text("Deflector (ColorHelper.swift)")
            } footer: {
                Text("MIT License\n\nCopyright (c) 2026 Cizzuk\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: \n \nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. \n \nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.")
                    .environment(\.layoutDirection, .leftToRight)
                    .textSelection(.enabled)
                    .padding(.bottom, 40)
            }
        }
        .navigationTitle("情報")
        .navigationBarTitleDisplayMode(.inline)
    }
}
