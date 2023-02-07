//
//  WeatherAPIClient.swift
//  iOS-training-KantaSwift
//
//  Created by 上條 栞汰 on 2023/02/06.
//

import YumemiWeather

protocol WeatherDelegate: AnyObject {
    func weatherDidUpdate(weather: String)
}

final class WeatherAPIClient {
    
    weak var delegate: WeatherDelegate?

    func requestWeather() {
        let weatherString = YumemiWeather.fetchWeatherCondition()
        delegate?.weatherDidUpdate(weather: weatherString)
    }
}
