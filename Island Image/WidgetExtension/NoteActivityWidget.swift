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
                if context.state.imageURL != nil {
                    NoteImage(imageURL: context.state.imageURL)
                }
                if !context.state.noteText.isEmpty {
                    NoteText(noteText: context.state.noteText)
                }
            }
            .activityBackgroundTint(.clear)
        }
    }
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NoteActivityAttributes.self) { context in
            MainActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
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
                NoteImage(imageURL: context.state.imageURL)
//                    .padding(.leading, 4.5)
            } compactTrailing: {
//                NoteImage(imageURL: context.state.imageURL)
//                    .padding(.trailing, 4.5)
            } minimal: {
                NoteImage(imageURL: context.state.imageURL)
//                    .padding(1.5)
                    .aspectRatio(45/49, contentMode: .fit)
            }
        }
    }
}
