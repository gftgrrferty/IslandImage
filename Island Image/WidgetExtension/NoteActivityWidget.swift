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
        var note: NoteData?
        var size: CGFloat? = nil
        
        var body: some View {
            if let note,
               let imageData = try? Data(contentsOf: note.getImageURL()!),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
    
    struct NoteText: View {
        var note: NoteData?
        
        var body: some View {
            if let note {
                Text(note.text)
                    .font(.headline)
                    .bold()
                    .foregroundStyle(.white)
            }
        }
    }
    
    struct MainActivityView: View {
        @Environment(\.activityFamily) var activityFamily
        let note = NotesManager().getCurrentNote()
        
        var body: some View {
            if let note {
                switch activityFamily {
                case .small:
                    HStack(spacing: 10) {
                        NoteImage(note: note, size: 30)
                        NoteText(note: note)
                    }
                case .medium:
                    HStack(spacing: 10) {
                        NoteImage(note: note, size: 40)
                            .padding(.leading, 10)
                        NoteText(note: note)
                    }
                    .padding()
                @unknown default:
                    EmptyView()
                }
            } else {
                EmptyView()
            }
        }
    }
    
    var body: some WidgetConfiguration {
        let note = NotesManager().getCurrentNote()
        
        return ActivityConfiguration(for: NoteActivityAttributes.self) { context in
            MainActivityView()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    NoteImage(note: note, size: 30)
                }
                DynamicIslandExpandedRegion(.center) {
                    NoteText(note: note)
                }
            } compactLeading: {
                NoteImage(note: note)
            } compactTrailing: {
            } minimal: {
                NoteImage(note: note)
            }
        }
    }
}
