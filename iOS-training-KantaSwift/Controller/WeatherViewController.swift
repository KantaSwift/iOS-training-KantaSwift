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
    
    private let weatherDataManager = WeatherDataManager()
    
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
    
    private let reloadButton = CustomButton(title: "Reload", frame: .zero)
    private let closeButton = CustomButton(title: "Close", frame: .zero)
    
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
        for (index, button) in [reloadButton, closeButton].enumerated() {
            button.delegate = self
            button.tag = index
        }
        weatherDataManager.delegate = self
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
}

    // MARK: - DelegateMethods
extension WeatherViewController: CustomButtonDelegate {
    func buttonDidTap(_ button: CustomButton, didTapAtIndex: Int) {
        switch didTapAtIndex {
        case 0:
            weatherDataManager.requestWeather()
        case 1:
            dismiss(animated: true)
        default:
            print("error")
        }
    }
}

extension WeatherViewController: WeatherDelegate {
    func weatherDidUpdate(weather: String) {
        guard let weather = Weather(rawValue: weather) else { return }
        weatherImageView.image = weather.image
    }
}
