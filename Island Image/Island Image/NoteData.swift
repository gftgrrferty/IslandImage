//
//  NoteData.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/13.
//

import Foundation

struct NoteData: Codable, Equatable, Identifiable {
    var id: UUID = UUID()
    var text = ""
    var image: Data?
}
