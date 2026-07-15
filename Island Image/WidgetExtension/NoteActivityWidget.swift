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
        var size: CGFloat? = nil
        
        var body: some View {
            if let imageURL,
               let imageData = try? Data(contentsOf: imageURL),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
    
    struct NoteText: View {
        var noteText: String
        
        var body: some View {
            Text(noteText)
                .font(.headline)
                .bold()
                .foregroundStyle(.white)
        }
    }
    
    struct MainActivityView: View {
        @Environment(\.activityFamily) var activityFamily
        let context: ActivityViewContext<NoteActivityAttributes>
        
        var body: some View {
            switch activityFamily {
            case .small:
                HStack(spacing: 10) {
                    NoteImage(imageURL: context.state.imageURL, size: 30)
                    NoteText(noteText: context.state.noteText)
                }
            case .medium:
                HStack(spacing: 10) {
                    NoteImage(imageURL: context.state.imageURL, size: 40)
                        .padding(.leading, 10)
                    NoteText(noteText: context.state.noteText)
                }
                .padding()
            @unknown default:
                EmptyView()
            }
        }
    }
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NoteActivityAttributes.self) { context in
            MainActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    NoteImage(imageURL: context.state.imageURL, size: 30)
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
