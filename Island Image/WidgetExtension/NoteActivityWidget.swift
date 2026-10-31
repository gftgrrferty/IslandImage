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
        @Environment(\.isDynamicIslandLimitedInWidth) var isDynamicIslandLimitedInWidth
        var imageURL: URL?
        var islandMode: DynamicIslandMode?
        
        var paddings: EdgeInsets {
            if let islandMode,
               userDefaults.bool(forKey: "autoPaddingDynamicIsland") {
                switch islandMode {
                case .compactLeading:
                    if isDynamicIslandLimitedInWidth {
                        return EdgeInsets(top: 4.5, leading: 0, bottom: 2, trailing: 0)
                    } else {
                        return EdgeInsets(top: 0, leading: 4.5, bottom: 0, trailing: 0)
                    }
                case .compactTrailing:
                    if isDynamicIslandLimitedInWidth {
                        return EdgeInsets(top: 2, leading: 0, bottom: 4.5, trailing: 0)
                    } else {
                        return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4.5)
                    }
                case .minimal:
                    if isDynamicIslandLimitedInWidth {
                        return EdgeInsets(top: 1.5, leading: 0, bottom: 1.5, trailing: 0)
                    } else {
                        return EdgeInsets(top: 0, leading: 1.5, bottom: 0, trailing: 1.5)
                    }
                default: return EdgeInsets()
                }
            } else {
                return EdgeInsets()
            }
        }
        
        var body: some View {
            if let imageURL,
               let imageData = try? Data(contentsOf: imageURL),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .interpolation(shouldPixelate(uiImage) ? .none : .medium)
                    .scaledToFit()
                    .frame(maxWidth: 45, maxHeight: 110/3)
                    .padding(paddings)
            } else {
                EmptyView().frame(width: 0, height: 0)
            }
        }
        
        private func shouldPixelate(_ image: UIImage) -> Bool {
            image.size.width <= 64 && image.size.height <= 64
        }
    }
    
    struct NoteText: View {
        var noteText: String
        let foregroundColorBlack = userDefaults.bool(forKey: "foregroundColorBlack")
        
        var body: some View {
            Text(noteText)
                .font(.title3)
                .foregroundStyle(foregroundColorBlack ? .black : .white)
        }
    }
    
    struct MainActivityView: View {
        let context: ActivityViewContext<NoteActivityAttributes>
        
        var body: some View {
            HStack(alignment: .center, spacing: 10) {
                if context.state.subimageURL != nil { Spacer() }
                
                if !userDefaults.bool(forKey: "trailingImage") {
                    NoteImage(imageURL: context.state.imageURL)
                } else {
                    NoteImage(imageURL: context.state.subimageURL)
                }
                
                if context.state.subimageURL != nil { Spacer() }
                
                if !context.state.noteText.isEmpty {
                    NoteText(noteText: context.state.noteText)
                }
                
                if context.state.subimageURL != nil { Spacer() }
                
                if userDefaults.bool(forKey: "trailingImage") {
                    NoteImage(imageURL: context.state.imageURL)
                } else {
                    NoteImage(imageURL: context.state.subimageURL)
                }
                
                if context.state.subimageURL != nil { Spacer() }
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
            DynamicIsland {
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
                DynamicIslandExpandedRegion(
                    userDefaults.bool(forKey: "trailingImage") ? .leading : .trailing
                ) {
                    VStack(alignment: .center) {
                        Spacer()
                        NoteImage(imageURL: context.state.subimageURL)
                        Spacer()
                    }
                    .frame(height: .infinity)
                }
                DynamicIslandExpandedRegion(.center) {
                    NoteText(noteText: context.state.noteText)
                }
            } compactLeading: {
                if !userDefaults.bool(forKey: "trailingImage") {
                    NoteImage(
                        imageURL: context.state.imageURL,
                        islandMode: .compactLeading
                    )
                } else {
                    NoteImage(
                        imageURL: context.state.subimageURL,
                        islandMode: .compactLeading
                    )
                }
            } compactTrailing: {
                if userDefaults.bool(forKey: "trailingImage") {
                    NoteImage(
                        imageURL: context.state.imageURL,
                        islandMode: .compactTrailing
                    )
                } else {
                    NoteImage(
                        imageURL: context.state.subimageURL,
                        islandMode: .compactTrailing
                    )
                }
            } minimal: {
                NoteImage(
                    imageURL: context.state.imageURL,
                    islandMode: .minimal
                )
                .aspectRatio(45/49, contentMode: .fit)
            }
            .keylineTint(ColorHelper.uInt32ToColor(context.state.color))
        }
    }
}
