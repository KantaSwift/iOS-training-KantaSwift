//
//  CustomButton.swift
//  iOS-training-KantaSwift
//
//  Created by 上條 栞汰 on 2023/02/06.
//

import UIKit

final class CustomButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.systemBlue, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
