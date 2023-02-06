//
//  CustomButton.swift
//  iOS-training-KantaSwift
//  Created by 上條 栞汰 on 2023/02/06.


import UIKit

protocol CustomButtonDelegate: AnyObject {
    func buttonDidTap(_ button: CustomButton)
}

final class CustomButton: UIButton {
    
    weak var delegate: CustomButtonDelegate?
    
    init(title: String, frame: CGRect) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        addTarget(self, action: #selector(getWeatherData), for: .touchUpInside)
        setTitleColor(.systemBlue, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CustomButton {
    @objc private func getWeatherData() {
        delegate?.buttonDidTap(self)
    }
}

