//
//  JackflixViewController.swift
//  SnapKitPractice
//
//  Created by 김도형 on 1/13/25.
//

import UIKit

import SnapKit

class JackflixViewController: UIViewController {
    private let titleLabel = UILabel()
    private let vstack = UIStackView()
    private var textFieldList = [UITextField]()
    private let signUpButton = UIButton()
    private let addInfoLabel = UILabel()
    private let addInfoSwitch = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .black
        
        configureTitleLabel()
        
        configureVStack()
        
        configureTextFieldList()
        
        configureSignUpButton()
        
        configureAddInfoLabel()
        
        configureAddInfoSwitch()
    }
}

private extension JackflixViewController {
    func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.text = "JACKFLIX"
        titleLabel.font = .systemFont(ofSize: 28, weight: .heavy)
        titleLabel.textColor = .red
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureVStack() {
        view.addSubview(vstack)
        vstack.axis = .vertical
        vstack.spacing = 16
        vstack.distribution = .fillEqually
        vstack.alignment = .center
        vstack.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
            make.centerY.lessThanOrEqualToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
        }
    }
    
    func configureSignUpButton() {
        view.addSubview(signUpButton)
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.backgroundColor = .white
        signUpButton.layer.cornerRadius = 8
        
        let buttonLabel = signUpButton.titleLabel
        buttonLabel?.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(32)
            make.top.equalTo(vstack.snp.bottom).offset(16)
        }
    }
    
    func configureTextFieldList() {
        let types = [
            "이메일 주소 또는 전화번호",
            "비밀번호",
            "닉네임",
            "위치",
            "추천 코드 입력"
        ]
        for type in types {
            let textField = configureTextField(type)
            textFieldList.append(textField)
            vstack.addArrangedSubview(textField)
            textField.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
            }
        }
    }
    
    func configureTextField(_ placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .darkGray
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.white]
        )
        
        return textField
    }
    
    func configureAddInfoLabel() {
        view.addSubview(addInfoLabel)
        addInfoLabel.text = "추가 정보 입력"
        addInfoLabel.textColor = .white
        addInfoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.top.equalTo(signUpButton.snp.bottom).offset(20)
        }
    }
    
    func configureAddInfoSwitch() {
        view.addSubview(addInfoSwitch)
        addInfoSwitch.isOn = true
        addInfoSwitch.onTintColor = .red
        addInfoSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(32)
            make.top.equalTo(signUpButton.snp.bottom).offset(20)
            make.bottom.lessThanOrEqualTo(view.keyboardLayoutGuide.snp.top)
        }
    }
}

#Preview {
    JackflixViewController()
}
