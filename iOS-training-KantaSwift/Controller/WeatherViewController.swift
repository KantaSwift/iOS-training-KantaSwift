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
    
    // MARK: - UI
    private let wheatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    
    private let blueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.text = "--"
        label.textAlignment = .center
        return label
    }()
    
    private let redLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "--"
        label.textAlignment = .center
        return label
    }()
    
    private let reloadButton = CustomButton(title: "Reload", frame: .zero)
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("close", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - UIStackViews
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [blueLabel, redLabel])
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
    private func setupView() {
        view.addSubview(wheatherImageView)
        view.addSubview(labelStackView)
        view.addSubview(buttonStackView)
        reloadButton.delegate = self
    }
    
    private func setupConstraint() {
        wheatherImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalTo(wheatherImageView.snp.width)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(wheatherImageView.snp.bottom)
            $0.width.equalTo(wheatherImageView.snp.width)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(wheatherImageView.snp.width)
        }
    }
    
    @objc private func closeButtonDidTap() {
        dismiss(animated: true)
    }
}

extension WeatherViewController: CustomButtonDelegate {
    func buttonDidTap(_ button: CustomButton) {
        let weatherString = YumemiWeather.fetchWeatherCondition()
        guard let weather = Weather(rawValue: weatherString) else { return }
        wheatherImageView.image = weather.image
    }
}
