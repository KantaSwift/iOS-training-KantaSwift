//
//  WeatherCondition.swift
//  iOS-training-KantaSwift
//
//  Created by 上條 栞汰 on 2023/02/03.
//

import UIKit

enum WeatherCondition: String {
    case sunny
    case cloudy
    case rainy
    
    private var color: UIColor {
        switch self {
        case .sunny:
            return .red
        case .cloudy:
            return .gray
        case .rainy:
            return .blue
        }
    }
    
    var image: UIImage {
        return UIImage(named: self.rawValue)!
            .withTintColor(color)
    }
}
