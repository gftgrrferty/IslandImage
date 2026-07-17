//
//  ChangeIconView.swift
//  Island Image
//
//  Created by Cizzuk on 2026/01/25.
//


import SwiftUI

struct ChangeIconView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    iconItem(iconName: "デフォルト", iconID: "AppIcon")
                    iconItem(iconName: "青", iconID: "Blue")
                    iconItem(iconName: "緑", iconID: "Green")
                    iconItem(iconName: "白", iconID: "White")
                }
            }
            .navigationTitle("アイコン変更")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func iconItem(iconName: String, iconID: String) -> some View {
        HStack {
            Image(iconID + "-pre")
                .resizable()
                .frame(width: 64, height: 64)
                .accessibilityHidden(true)
                .padding(8)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            Text(iconName)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            // Change App Icon
            if iconID == "AppIcon" {
                UIApplication.shared.setAlternateIconName(nil)
            } else {
                UIApplication.shared.setAlternateIconName(iconID)
            }
        }
    }
}
