//
//  WeatherData.swift
//  iOS-training-KantaSwift
//
//  Created by 上條 栞汰 on 2023/02/07.
//

import Foundation

struct WeatherData: Codable {
    var minTemperature: Int
    var weatherCondition: String
    var maxTemperature: Int
    var date: String
}
