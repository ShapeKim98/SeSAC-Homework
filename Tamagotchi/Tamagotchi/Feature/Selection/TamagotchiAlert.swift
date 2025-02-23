//
//  TamagotchAlert.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/23/25.
//

import UIKit

import SnapKit

final class TamagotchiAlert: UIView {
    private let imageView = UIImageView()
    private let nameLabel = NameLabel()
    private let separatorView = UIView()
    private let introduceLabel = UILabel()
    lazy var cancelButton = {
        let button = configureButton("취소")
        button.configuration?.background.backgroundColor = .black.withAlphaComponent(0.1)
        return button
    }()
    lazy var startButton = { configureButton("시작하기") }()
    private let buttonSeparatorView = UIView()
    private let hstack = UIStackView()
    
    private let tamagotchi: Tamagotchi
    
    init(tamagotchi: Tamagotchi) {
        self.tamagotchi = tamagotchi
        
        super.init(frame: .zero)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Configure Views
private extension TamagotchiAlert {
    func configureUI() {
        backgroundColor = .tgBackground
        layer.cornerRadius = 8
        clipsToBounds = true
        
        configureImageView()
        
        configureNameLabel()
        
        configureSeparatorView()
        
        configureIntroduceLabel()
        
        configureButtonSeparatorView()
        
        configureHStack()
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.size.equalTo(150)
            make.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.width.equalTo(introduceLabel)
            make.height.equalTo(1)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        introduceLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
        }
        
        buttonSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(introduceLabel.snp.bottom).offset(36)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
        }
        
        hstack.snp.makeConstraints { make in
            make.top.equalTo(buttonSeparatorView.snp.bottom)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        [cancelButton, startButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalToSuperview()
            }
        }
    }
    
    func configureImageView() {
        if let id = tamagotchi.id {
            imageView.image = UIImage(named: "\(id)-6")
        } else {
            imageView.image = UIImage(resource: .no)
        }
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }
    
    func configureNameLabel() {
        if let name = tamagotchi.name {
            nameLabel.setName(name)
        } else {
            nameLabel.setName("준비중이에요")
        }
        addSubview(nameLabel)
    }
    
    func configureSeparatorView() {
        separatorView.backgroundColor = .accent
        addSubview(separatorView)
    }
    
    func configureIntroduceLabel() {
        introduceLabel.text = tamagotchi.introduce
        introduceLabel.textColor = .accent
        introduceLabel.numberOfLines = 0
        introduceLabel.textAlignment = .center
        introduceLabel.font = .systemFont(ofSize: 14)
        addSubview(introduceLabel)
    }
    
    func configureButtonSeparatorView() {
        buttonSeparatorView.backgroundColor = .separator
        addSubview(buttonSeparatorView)
    }
    
    func configureHStack() {
        hstack.axis = .horizontal
        hstack.distribution = .fillEqually
        hstack.spacing = 0
        addSubview(hstack)
    }
    
    func configureButton(_ title: String) -> UIButton {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = .clear
        configuration.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([.foregroundColor: UIColor.accent ])
        )
        configuration.background.cornerRadius = 0
        configuration.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
        button.configuration = configuration
        hstack.addArrangedSubview(button)
        return button
    }
}

#Preview {
    TamagotchiAlert(tamagotchi: .방실방실)
}
