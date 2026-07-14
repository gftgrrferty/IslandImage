//
//  NoteData.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/13.
//

import Foundation
import PhotosUI
import SwiftUI

struct NoteData: Codable, Equatable, Identifiable {
    var id: UUID = UUID()
    var text = ""
    var image: String?
    
    // 画像を保存する非同期関数
    mutating func saveImage(_ item: PhotosPickerItem) async {
        // 画像をData型にする
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        // App Groupの共有のディレクトリのパスを取得
        guard var itemURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.net.abidaze.Island-Image"
        ) else {
            return
        }
        
        // 画像を保存するディレクトリのパスを追加
        itemURL.appendPathComponent("note_image", isDirectory: true)
        // 画像を保存するディレクトリがなかったら作成する
        if !FileManager.default.fileExists(atPath: itemURL.path) {
            do {
                try FileManager.default.createDirectory(at: itemURL, withIntermediateDirectories: true)
            } catch {
                return
            }
        }
        // 画像のファイル名をノートのUUIDにする
        itemURL.appendPathComponent(self.id.uuidString)
        
        // 画像の拡張子を判断する
        let ext: String
        switch item.supportedContentTypes.first {
        case .png:
            ext = "png"
        case .jpeg:
            ext = "jpg"
        case .heic:
            ext = "heic"
        default:
            return
        }
        // 判断した拡張子をファイル名に追加
        itemURL.appendPathExtension(ext)
        // ファイルを作成
        do {
            try data.write(to: itemURL)
        } catch {
            return
        }
        // ファイル名を保存
        self.image = itemURL.lastPathComponent
        print(itemURL)
    }
    
    func getImageURL() -> URL? {
        guard let image = self.image else { return nil }
        guard var itemURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.net.abidaze.Island-Image"
        ) else {
            return nil
        }
        itemURL.appendPathComponent("note_image", isDirectory: true)
        itemURL.appendPathComponent(image)
        return itemURL
    }
    
//    func uiImage() -> UIImage? {
//    }
}
