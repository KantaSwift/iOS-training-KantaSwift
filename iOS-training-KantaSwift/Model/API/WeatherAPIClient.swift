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
    func weatherAPIClient(didFailWithError error: APIClientError)
}

enum APIClientError: Error {
    case decodingError
    case encodingError
    case yumemiWeatherError(YumemiWeatherError)
}

protocol WeatherAPIClient {
    var delegate: WeatherAPIClientDelegate? {get set}
    func requestWeather()
}

final class WeatherAPIClientImpl: WeatherAPIClient {
    
    private let weatherAPIRequest = WeatherAPIRequest(area: "tokyo", date: Date())
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    weak var delegate: WeatherAPIClientDelegate?

    func requestWeather() {
        do {
            let data  = try encoder.encode(weatherAPIRequest)
            guard let parameter = String(data: data, encoding: .utf8) else { return }
            let jsonString = try YumemiWeather.fetchWeather(parameter)
            guard let data = jsonString.data(using: .utf8) else { return }
            let weather = try decoder.decode(WeatherData.self, from: data)
            delegate?.didUpdateWeather(weather)
        } catch let error as YumemiWeatherError {
            delegate?.weatherAPIClient(didFailWithError: .yumemiWeatherError(error))
        } catch _ as DecodingError {
            delegate?.weatherAPIClient(didFailWithError: .decodingError)
        } catch _ as EncodingError {
            delegate?.weatherAPIClient(didFailWithError: .encodingError)
        } catch {}
    }
}
