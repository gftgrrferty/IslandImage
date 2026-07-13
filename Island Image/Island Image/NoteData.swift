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
    var image: Data?
    
    func saveImage(_ target: PhotosPickerItem?) {
        // targetから画像データを取り出す
        // 最大128pxくらいにリサイズする
        // self.imageに取り込む
        // self.image = ???
    }
    
//    func uiImage() -> UIImage? {
//    }
}
