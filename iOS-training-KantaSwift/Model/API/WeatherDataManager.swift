//
//  WeatherDataManager.swift
//  iOS-training-KantaSwift
//
//  Created by 上條 栞汰 on 2023/02/06.
//

import UIKit
import YumemiWeather

protocol WeatherDelegate: AnyObject {
    func weatherDidUpdate(weather: String)
}

final class WeatherDataManager {
    
    weak var delegate: WeatherDelegate?

    func requestWeather() {
        let weatherString = YumemiWeather.fetchWeatherCondition()
        delegate?.weatherDidUpdate(weather: weatherString)
    }
}
