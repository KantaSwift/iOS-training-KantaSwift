//
//  WeatherModelMock.swift
//  iOS-training-KantaSwift
//
//  Created by 上條 栞汰 on 2023/02/09.
//

import Foundation

final class WeatherModelMock: WeatherAPIClient {
    
    var delegate: WeatherAPIClientDelegate?
    
    func requestWeather() {
        delegate?.didUpdateWeather(WeatherData(minTemperature: 30, weatherCondition: WeatherData.Condition.sunny, maxTemperature: 20, date: Date()))
    }
}
