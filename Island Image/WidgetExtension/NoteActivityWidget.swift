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
                NoteImage(imageURL: context.state.imageURL)
                    .padding(10)
                    .frame(height: 80)
                NoteText(noteText: context.state.noteText)
            }
        }
    }
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NoteActivityAttributes.self) { context in
            MainActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    NoteImage(imageURL: context.state.imageURL)
                        .padding(5)
                }
                DynamicIslandExpandedRegion(.center) {
                    NoteText(noteText: context.state.noteText)
                }
            } compactLeading: {
                NoteImage(imageURL: context.state.imageURL)
            } compactTrailing: {
            } minimal: {
                NoteImage(imageURL: context.state.imageURL)
            }
        }
    }
}
