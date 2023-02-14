//
//  WeatherAPIClient.swift
//  iOS-training-KantaSwift
//
//  Created by 上條 栞汰 on 2023/02/06.
//

import YumemiWeather

protocol WeatherAPIClientDelegate: AnyObject {
    func didUpdateWeather(_ weather: String)
}

final class WeatherAPIClient {
    
    weak var delegate: WeatherAPIClientDelegate?

    func requestWeather() {
        let weatherString = YumemiWeather.fetchWeatherCondition()
        delegate?.didUpdateWeather(weatherString)
    }
}
