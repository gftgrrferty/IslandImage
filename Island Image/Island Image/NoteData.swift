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
    
    #if !EXTENSION
    // 画像を保存する非同期関数
    mutating func saveImage(_ item: PhotosPickerItem) async {
        // 画像をData型にする
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        // Data型からUIImage型にする
        guard let uiimage = UIImage(data: data) else { return }
        // 画像をリサイズ
        let newimage = ImageSupport.resize(image: uiimage)
        // リサイズした画像をpngのData型にする
        guard let newdata = newimage.pngData() else { return }
        
        // App Groupの共有のディレクトリのパスを取得
        guard var itemURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupID
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
        // 判断した拡張子をファイル名に追加
        itemURL.appendPathExtension("png")
        
        // ファイルを作成
        do {
            try newdata.write(to: itemURL)
        } catch {
            return
        }
        
        // ファイル名を保存
        self.image = itemURL.lastPathComponent
        print(itemURL)
    }
    #endif
    
    // 画像のURLを取得
    func getImageURL() -> URL? {
        guard let image = self.image else { return nil }
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
    func deleteImage() {
        guard let image = self.image else { return }
        guard var itemURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupID
        ) else {
            return
        }
        itemURL.appendPathComponent("note_image", isDirectory: true)
        itemURL.appendPathComponent(image)
        _ = try? FileManager.default.removeItem(at: itemURL)
    }
//    func uiImage() -> UIImage? {
//    }
}
