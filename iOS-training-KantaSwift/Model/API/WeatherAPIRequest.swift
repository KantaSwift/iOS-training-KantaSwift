//
//  WeatherAPIRequest.swift
//  iOS-training-KantaSwift
//
//  Created by 上條 栞汰 on 2023/02/08.
//

import Foundation

struct WeatherAPIRequest: Encodable {
    let area: String
    let date: String
}
