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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
//    天気予報がsunnyだったら、画面に晴れ画像が表示されること
//    天気予報がcloudyだったら、画面に曇り画像が表示されること
//    天気予報がrainyだったら、画面に雨画像が表示されること
//    天気予報の最高気温がUILabelに反映されること
//    天気予報の最低気温がUILabelに反映されること
    
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

    func test_天気予報の最高気温がUILabelに反映されること() {
        let test_minTemperatureLabel: UILabel = {
            let label = UILabel()
            label.textColor = .blue
            label.font = LabelFontDefinition.middleSize
            label.text = "20"
            label.textAlignment = .center
            return label
        }()
        let weatherModelMock = WeatherModelMock(weatherData: WeatherData(minTemperature: 20, weatherCondition: .rainy, maxTemperature: 30, date: Date()))
        let weatherVC = WeatherViewController(weatherAPIClient: weatherModelMock)
        weatherModelMock.delegate = weatherVC
        weatherModelMock.requestWeather()
        
        XCTAssertEqual(weatherVC.minTemperatureLabel.text, test_minTemperatureLabel.text)
    }

    func test_天気予報の最低気温がUILabelに反映されること() {
        let test_maxTemperatureLabel: UILabel = {
            let label = UILabel()
            label.textColor = .red
            label.font = LabelFontDefinition.middleSize
            label.text = "30"
            label.textAlignment = .center
            return label
        }()
        let weatherModelMock = WeatherModelMock(weatherData: WeatherData(minTemperature: 20, weatherCondition: .rainy, maxTemperature: 30, date: Date()))
        let weatherVC = WeatherViewController(weatherAPIClient: weatherModelMock)
        weatherModelMock.delegate = weatherVC
        weatherModelMock.requestWeather()
        
        XCTAssertEqual(weatherVC.maxTemperatureLabel.text, test_maxTemperatureLabel.text)
    }
    
}
