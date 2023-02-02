//
//  UIImage.swift
//  iOS-training-KantaSwift
//
//  Created by 上條 栞汰 on 2023/02/02.
//

import UIKit

extension UIImage {
    func tinted(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
