//
//  WeatherAPIClient.swift
//  iOS-training-KantaSwift
//
//  Created by 上條 栞汰 on 2023/02/06.
//

import YumemiWeather
import Foundation


protocol WeatherAPIClientDelegate: AnyObject {
    func didUpdateWeather(_ weather: WeatherData)
    func weatherAPIClient(didFailWithError error: YumemiWeatherError)
}

final class WeatherAPIClient {
    
    private var sampleJson = """
                            {
                                "area": "tokyo",
                                "date": "2020-04-01T12:00:00+09:00"
                            }
                            """
    private let decoder  = JSONDecoder()
    weak var delegate: WeatherAPIClientDelegate?

    func requestWeather() {
        do {
            let jsonString = try YumemiWeather.fetchWeather(sampleJson)
            guard let data = jsonString.data(using: .utf8) else { return }
            let weather = try decoder.decode(WeatherData.self, from: data)
            delegate?.didUpdateWeather(weather)
        } catch let error as YumemiWeatherError {
            delegate?.weatherAPIClient(didFailWithError: error)
        } catch {}
    }
}
