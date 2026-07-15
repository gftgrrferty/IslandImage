//
//  NoteActivityWidget.swift
//  Island Image
//
//  Created by Cizzuk on 2026/07/15.
//

import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

struct NoteActivityWidget: Widget {
    static let kind = "net.abidaze.Island-Image.WidgetExtension.NoteActivityWidget"
    
    struct NoteImage: View {
        var imageURL: URL?
        
        var body: some View {
            if let imageURL,
               let imageData = try? Data(contentsOf: imageURL),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .interpolation(shouldPixelate(uiImage) ? .none : .medium)
                    .scaledToFit()
                    .frame(maxWidth: 45, maxHeight: 110/3)
            }
        }
        
        private func shouldPixelate(_ image: UIImage) -> Bool {
            image.size.width <= 64 && image.size.height <= 64
        }
    }
    
    struct NoteText: View {
        var noteText: String
        
        var body: some View {
            Text(noteText)
                .font(.title3)
                .foregroundStyle(.white)
        }
    }
    
    struct MainActivityView: View {
        let context: ActivityViewContext<NoteActivityAttributes>
        
        var body: some View {
            HStack(alignment: .center, spacing: 10) {
                if !userDefaults.bool(forKey: "trailingImage") {
                    NoteImage(imageURL: context.state.imageURL)
                }
                if !context.state.noteText.isEmpty {
                    NoteText(noteText: context.state.noteText)
                }
                if userDefaults.bool(forKey: "trailingImage") {
                    NoteImage(imageURL: context.state.imageURL)
                }
            }
        }
    }
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NoteActivityAttributes.self) { context in
            Group {
                if !userDefaults.bool(forKey: "hideLockScreenNote") {
                    MainActivityView(context: context)
                }
            }
            .activityBackgroundTint(.clear)
        } dynamicIsland: { context in
            let autoPadding = userDefaults.bool(forKey: "autoPaddingDynamicIsland")
            
            return DynamicIsland {
                DynamicIslandExpandedRegion(
                    userDefaults.bool(forKey: "trailingImage") ? .trailing : .leading
                ) {
                    VStack(alignment: .center) {
                        Spacer()
                        NoteImage(imageURL: context.state.imageURL)
                        Spacer()
                    }
                    .frame(height: .infinity)
                }
                DynamicIslandExpandedRegion(.center) {
                    NoteText(noteText: context.state.noteText)
                }
            } compactLeading: {
                if !userDefaults.bool(forKey: "trailingImage") {
                    NoteImage(imageURL: context.state.imageURL)
                        .padding(.leading, autoPadding ? 4.5 : 0)
                }
            } compactTrailing: {
                if userDefaults.bool(forKey: "trailingImage") {
                    NoteImage(imageURL: context.state.imageURL)
                        .padding(.trailing, autoPadding ? 4.5 : 0)
                }
            } minimal: {
                NoteImage(imageURL: context.state.imageURL)
                    .padding(autoPadding ? 1.5 : 0)
                    .aspectRatio(45/49, contentMode: .fit)
            }
        }
    }
}
