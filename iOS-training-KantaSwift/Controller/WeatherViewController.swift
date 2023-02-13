//
//  WeatherViewController.swift
//  iOS-training-KantaSwift
//
//  Created by 上條 栞汰 on 2023/02/02.
//

import UIKit
import SnapKit
import YumemiWeather

final class WeatherViewController: UIViewController{
    
    private let weatherAPIClient = WeatherAPIClient()
    
    // MARK: - UI
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.text = "--"
        label.textAlignment = .center
        return label
    }()
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "--"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var reloadButton: CustomButton = {
        let button = CustomButton(title: "Reload", frame: .zero)
        button.addTarget(self, action: #selector(reloadButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: CustomButton = {
        let button = CustomButton(title: "Close", frame: .zero)
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - UIStackViews
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftLabel, rightLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [reloadButton, closeButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - LifeCycleMethod
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        setupConstraint()
    }
    
    deinit {
        print("delegate deinit")
    }
}

private extension WeatherViewController {
    func setupView() {
        view.addSubview(weatherImageView)
        view.addSubview(labelStackView)
        view.addSubview(buttonStackView)
        weatherAPIClient.delegate = self
    }
    
    func setupConstraint() {
        weatherImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalTo(weatherImageView.snp.width)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(weatherImageView.snp.bottom)
            $0.width.equalTo(weatherImageView.snp.width)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(weatherImageView.snp.width)
        }
    }
    
    @objc func reloadButtonDidTap() {
        weatherAPIClient.requestWeather()
    }
    
    @objc func closeButtonDidTap() {
        dismiss(animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


    // MARK: - DelegateMethods
extension WeatherViewController: WeatherAPIClientDelegate {
    func weatherAPIClient(didFailWithError: YumemiWeatherError) {
        switch didFailWithError {
        case .unknownError:
            showErrorAlert(message: "unknownError")
        case .invalidParameterError:
            showErrorAlert(message: "invalidParameterError")
        }
    }
    
    func didUpdateWeather(_ weather: String) {
        guard let weather = Weather(rawValue: weather) else { return }
        weatherImageView.image = weather.image
    }
}


