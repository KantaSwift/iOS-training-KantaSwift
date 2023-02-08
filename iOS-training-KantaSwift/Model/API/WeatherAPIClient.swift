//
//  WeatherAPIClient.swift
//  iOS-training-KantaSwift
//
//  Created by 上條 栞汰 on 2023/02/06.
//

import YumemiWeather


protocol WeatherAPIClientDelegate: AnyObject {
    func didUpdateWeather(_ weather: String)
    func weatherDidFail(error: YumemiWeatherError)
}

final class WeatherAPIClient {
    
    weak var delegate: WeatherAPIClientDelegate?

    func requestWeather() {
        do {
            let weatherString = try YumemiWeather.fetchWeatherCondition(at: "tokyo")
            delegate?.didUpdateWeather(weatherString)
        } catch let error as YumemiWeatherError {
            delegate?.weatherDidFail(error: error)
        } catch {}
    }
}
