//
//  WeatherData.swift
//  iOS-training-KantaSwift
//
//  Created by 上條 栞汰 on 2023/02/07.
//

import Foundation

struct WeatherData: Decodable {
    var minTemperature: Int
    var weatherCondition: Condition
    var maxTemperature: Int
    var date: Date
    
    enum Condition: String, Decodable {
        case sunny
        case cloudy
        case rainy
    }
}
