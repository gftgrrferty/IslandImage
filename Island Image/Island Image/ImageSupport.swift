//
//  ImageSupport.swift
//  Island Image
//
//  Created by gftgrrferty on 2026/07/16.
//

import UIKit

class ImageSupport {
    static func resize(image: UIImage, target: CGSize = CGSize(width: 135, height: 110)) -> UIImage {
        let w = image.size.width
        let h = image.size.height

        // どちらかでもターゲットより大きい場合だけリサイズ（＝両方が小さいならそのまま）
        guard w > target.width || h > target.height else { return image }

        let scale = min(target.width / w, target.height / h) // 縦横比維持
        let newSize = CGSize(width: w * scale, height: h * scale)

        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale

        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
