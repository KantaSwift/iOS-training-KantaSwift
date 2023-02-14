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
    
    private var weatherAPIClient: WeatherAPIClient
    
    init(weatherAPIClient: WeatherAPIClient) {
        self.weatherAPIClient = weatherAPIClient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    
    let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = LabelFontDefinition.middleSize
        label.text = "--"
        label.textAlignment = .center
        return label
    }()
    
    let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = LabelFontDefinition.middleSize
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
        let stackView = UIStackView(arrangedSubviews: [minTemperatureLabel, maxTemperatureLabel])
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
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
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
        labelStackView.addSubview(activityIndicatorView)
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
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc func reloadButtonDidTap() {
        self.activityIndicatorView.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            self?.weatherAPIClient.requestWeather { result in
                switch result {
                case .success(let weatherData):
                    self?.updateUI(weatherData)
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }
    
    @objc func closeButtonDidTap() {
        dismiss(animated: true)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateUI(_ weather: WeatherData) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicatorView.stopAnimating()
            self?.weatherImageView.image = weather.weatherCondition.image
            self?.minTemperatureLabel.text = String(weather.minTemperature)
            self?.maxTemperatureLabel.text = String(weather.maxTemperature)
        }
    }
    
    func showError(_ didFailWithError: APIClientError) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicatorView.stopAnimating()
            switch didFailWithError {
            case .encodingError:
                self?.showErrorAlert(message: "encodingError")
            case .decodingError:
                self?.showErrorAlert(message: "decodingError")
            case .yumemiWeatherError(.unknownError):
                self?.showErrorAlert(message: "unknownError")
            case .yumemiWeatherError(.invalidParameterError):
                self?.showErrorAlert(message: "invalidParameterError")
            }
        }
    }
    
    @objc func  didBecomeActive() {
        activityIndicatorView.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            self?.weatherAPIClient.requestWeather { result in
                switch result {
                case .success(let weatherData):
                    self?.updateUI(weatherData)
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }
}

private extension WeatherData.Condition {
    var color: UIColor {
        switch self {
        case .sunny:
            return .red
        case .cloudy:
            return .gray
        case .rainy:
            return .blue
        }
    }
    
    var image: UIImage {
        return UIImage(named: self.rawValue)!
            .withTintColor(color)
    }
}
