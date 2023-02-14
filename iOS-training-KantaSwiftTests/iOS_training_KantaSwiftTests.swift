//
//  iOS_training_KantaSwiftTests.swift
//  iOS-training-KantaSwiftTests
//
//  Created by 上條 栞汰 on 2023/02/02.
//

import XCTest
@testable import iOS_training_KantaSwift

final class WeatherModelMock: WeatherAPIClient {
    
    var delegate: WeatherAPIClientDelegate?
    private let weatherData: WeatherData
   
    
    init(delegate: WeatherAPIClientDelegate? = nil, weatherData: WeatherData) {
        self.delegate = delegate
        self.weatherData = weatherData
    }
    
    func requestWeather() {
        delegate?.didUpdateWeather(weatherData)
    }
}


final class iOS_training_KantaSwiftTests: XCTestCase {

    func test_天気予報がsunnyだったら画面に晴れ画像が表示されること() {
        let weatherModelMock = WeatherModelMock(weatherData: WeatherData(minTemperature: 20, weatherCondition: .sunny, maxTemperature: 30, date: Date()))
        let weatherVC = WeatherViewController(weatherAPIClient: weatherModelMock)
        weatherModelMock.delegate = weatherVC
        weatherModelMock.requestWeather()
        XCTAssertEqual(weatherVC.weatherImageView.image, UIImage(named: "sunny")?.withTintColor(.red))
    }
    
    func test_天気予報がcloudyだったら画面に曇り画像が表示されること() {
        let weatherModelMock = WeatherModelMock(weatherData: WeatherData(minTemperature: 20, weatherCondition: .cloudy, maxTemperature: 30, date: Date()))
        let weatherVC = WeatherViewController(weatherAPIClient: weatherModelMock)
        weatherModelMock.delegate = weatherVC
        weatherModelMock.requestWeather()
        XCTAssertEqual(weatherVC.weatherImageView.image, UIImage(named: "cloudy")?.withTintColor(.gray))
    }

    func test_天気予報がrainyだったら画面に雨画像が表示されること() {
        let weatherModelMock = WeatherModelMock(weatherData: WeatherData(minTemperature: 20, weatherCondition: .rainy, maxTemperature: 30, date: Date()))
        let weatherVC = WeatherViewController(weatherAPIClient: weatherModelMock)
        weatherModelMock.delegate = weatherVC
        weatherModelMock.requestWeather()
        XCTAssertEqual(weatherVC.weatherImageView.image, UIImage(named: "rainy")?.withTintColor(.blue))
    }

    func test_天気予報の最低気温がUILabelに反映されること() {
        let weatherModelMock = WeatherModelMock(weatherData: WeatherData(minTemperature: 20, weatherCondition: .rainy, maxTemperature: 30, date: Date()))
        let weatherVC = WeatherViewController(weatherAPIClient: weatherModelMock)
        weatherModelMock.delegate = weatherVC
        weatherModelMock.requestWeather()
        XCTAssertEqual(weatherVC.minTemperatureLabel.text, "20")
    }

    func test_天気予報の最高気温がUILabelに反映されること() {
        let weatherModelMock = WeatherModelMock(weatherData: WeatherData(minTemperature: 20, weatherCondition: .rainy, maxTemperature: 30, date: Date()))
        let weatherVC = WeatherViewController(weatherAPIClient: weatherModelMock)
        weatherModelMock.delegate = weatherVC
        weatherModelMock.requestWeather()
        XCTAssertEqual(weatherVC.maxTemperatureLabel.text, "30")
    }
}
