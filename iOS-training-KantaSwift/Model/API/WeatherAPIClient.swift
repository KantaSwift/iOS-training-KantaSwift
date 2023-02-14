//
//  WeatherAPIClient.swift
//  iOS-training-KantaSwift
//
//  Created by 上條 栞汰 on 2023/02/06.
//

import YumemiWeather
import Foundation

enum APIClientError: Error {
    case decodingError
    case encodingError
    case yumemiWeatherError(YumemiWeatherError)
}

protocol WeatherAPIClient {
    func requestWeather(completion: @escaping (Result<WeatherData, APIClientError>) -> ())
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

    func requestWeather(completion: @escaping (Result<WeatherData, APIClientError>) -> ()) {
        do {
            let data  = try encoder.encode(weatherAPIRequest)
            guard let parameter = String(data: data, encoding: .utf8) else {
                completion(.failure(.encodingError))
                return
            }
            let jsonString = try YumemiWeather.syncFetchWeather(parameter)
            guard let data = jsonString.data(using: .utf8) else {
                completion(.failure(.decodingError))
                return
            }
            let weather = try decoder.decode(WeatherData.self, from: data)
            completion(.success(weather))
        } catch let error as YumemiWeatherError {
            completion(.failure(.yumemiWeatherError(error)))
        } catch {}
    }
}
