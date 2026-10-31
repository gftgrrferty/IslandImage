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
    var color: UInt32?
    var subimage: String?
    
    #if !EXTENSION
    // 画像を保存する非同期関数
    static func saveImageToFile(_ item: PhotosPickerItem) async -> String? {
        // 画像をData型にする
        guard let data = try? await item.loadTransferable(type: Data.self) else { return nil }
        // Data型からUIImage型にする
        guard let uiimage = UIImage(data: data) else { return nil }
        // 画像をリサイズ
        let newimage = ImageSupport.resize(image: uiimage)
        // リサイズした画像をpngのData型にする
        guard let newdata = newimage.pngData() else { return nil }
        
        // App Groupの共有のディレクトリのパスを取得
        guard var itemURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupID
        ) else {
            return nil
        }
        
        // 画像を保存するディレクトリのパスを追加
        itemURL.appendPathComponent("note_image", isDirectory: true)
        // 画像を保存するディレクトリがなかったら作成する
        if !FileManager.default.fileExists(atPath: itemURL.path) {
            do {
                try FileManager.default.createDirectory(at: itemURL, withIntermediateDirectories: true)
            } catch {
                return nil
            }
        }
        // 画像のファイル名をノートのUUIDにする
        itemURL.appendPathComponent(UUID().uuidString)
        // 判断した拡張子をファイル名に追加
        itemURL.appendPathExtension("png")
        
        // ファイルを作成
        do {
            try newdata.write(to: itemURL)
            return itemURL.lastPathComponent
        } catch {
            return nil
        }
    }
    
    mutating func saveImage(_ item: String, subimage: Bool) {
        // ファイル名を保存
        if subimage == true {
            self.subimage = item
        } else {
            self.image = item
        }
    }
    #endif
    
    // 画像のURLを取得
    func getImageURL(subimage: Bool) -> URL? {
        guard let image = subimage == true ? self.subimage : self.image else { return nil }
        guard var itemURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupID
        ) else {
            return nil
        }
        itemURL.appendPathComponent("note_image", isDirectory: true)
        itemURL.appendPathComponent(image)
        return itemURL
    }
    
    // 画像削除
    mutating func deleteImage(subimage: Bool) {
        guard let image = subimage == true ? self.subimage : self.image else { return }
        guard var itemURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupID
        ) else {
            return
        }
        itemURL.appendPathComponent("note_image", isDirectory: true)
        itemURL.appendPathComponent(image)
        _ = try? FileManager.default.removeItem(at: itemURL)
        if subimage == true {
            self.subimage = nil
        } else {
            self.image = nil
        }
    }
}
