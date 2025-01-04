//
//  SignUpViewController.swift
//  MovieProject
//
//  Created by 김도형 on 12/26/24.
//

import UIKit

class SignUpViewController: UIViewController {
    enum TextFieldType: Int, CaseIterable {
        case emailOrPhoneNumber
        case password
        case nickname
        case location
        case code
        
        var placeholder: String {
            switch self {
            case .emailOrPhoneNumber: return "이메일 주소 또는 전화번호"
            case .password: return "비밀번호"
            case .nickname: return "닉네임"
            case .location: return "주소"
            case .code: return "추천 코드 입력"
            }
        }
    }
    
    @IBOutlet var textFieldList: [UITextField]!
    @IBOutlet var additionalSwitch: UISwitch!
    @IBOutlet var additionalLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setTextFields()
        
        setSignUpButton()
        
        setAdditionalLabel()
        
        setAdditionalSwitch()
    }
    
    private func setTextFields() {
        let textFieldTypeList = TextFieldType.allCases
        for (index, type) in textFieldTypeList.enumerated() {
            let textField = textFieldList[index]
            textField.backgroundColor = .gray
            textField.textColor = .white
            textField.placeholder = type.placeholder
            textField.textAlignment = .center
            textField.tag = type.rawValue
            
            if case .emailOrPhoneNumber = type {
                textField.keyboardType = .emailAddress
            }
            if case .code = type {
                textField.keyboardType = .numberPad
            }
            if case .password = type {
                textField.isSecureTextEntry = true
            }
        }
    }
    
    private func setSignUpButton() {
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.backgroundColor = .white
        signUpButton.layer.cornerRadius = 8
        signUpButton.clipsToBounds = true
    }
    
    private func setAdditionalLabel() {
        additionalLabel.textColor = .white
        additionalLabel.text = "추가 정보 입력"
    }
    
    private func setAdditionalSwitch() {
        additionalSwitch.setOn(true, animated: true)
        additionalSwitch.onTintColor = .red
        additionalSwitch.thumbTintColor = .white
    }
    
    @IBAction func signUpButtonTouchUpInside(_ sender: UIButton) {
        let passwordTextField = textFieldList.first { textField in
            TextFieldType(rawValue: textField.tag) == .password
        }
        let emailTextField = textFieldList.first { textField in
            TextFieldType(rawValue: textField.tag) == .emailOrPhoneNumber
        }
        let codeTextField = textFieldList.first { textField in
            TextFieldType(rawValue: textField.tag) == .code
        }
        guard
            let passwordText = passwordTextField?.text,
            passwordText.count >= 6,
            let emailText = emailTextField?.text,
            !emailText.isEmpty,
            let codeText = codeTextField?.text,
            Int(codeText) != nil
        else { return }
            
        view.endEditing(true)
    }
}
