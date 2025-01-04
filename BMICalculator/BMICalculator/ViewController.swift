//
//  ViewController.swift
//  BMICalculator
//
//  Created by 김도형 on 12/30/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var resultButton: UIButton!
    @IBOutlet var randomButton: UIButton!
    @IBOutlet var weightHiddenButton: UIButton!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var tallTextField: UITextField!
    @IBOutlet var textFieldBackgroundView: [UIView]!
    @IBOutlet var nicknameTitleLabel: UILabel!
    @IBOutlet var weightTitleLabel: UILabel!
    @IBOutlet var tallTitleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var mainTitleLabel: UILabel!
    
    private var isWeightHidden: Bool = false
    
    @UserDefault(forKey: .tall)
    private var tall: String?
    @UserDefault(forKey: .weight)
    private var weight: String?
    @UserDefault(forKey: .nickname)
    private var nickname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setMainTitleLabel()
        
        setSubTitleLabel()
        
        setImageView()
        
        setTitleLabel(
            label: tallTitleLabel,
            text: "키가 어떻게 되시나요?"
        )
        
        setTitleLabel(
            label: weightTitleLabel,
            text: "몸무게는 어떻게 되시나요?"
        )
        
        setTitleLabel(
            label: nicknameTitleLabel,
            text: "닉네임은 어떻게 되시나요?"
        )
        
        setTextFieldBackgroundViews()
        
        setTallTextField()
        
        setWeightTextField()
        
        setTextField(textField: nicknameTextField)
        nicknameTextField.text = nickname
        
        setWeightHiddenButton()
        
        setRandomButton()
        
        setResultButton()
        
        setSaveButton()
        
        setResetButton()
    }
    
    private func setMainTitleLabel() {
        mainTitleLabel.text = "BMI Calculator"
        mainTitleLabel.font = .boldSystemFont(ofSize: 20)
        mainTitleLabel.textColor = .black
    }
    
    private func setSubTitleLabel() {
        subTitleLabel.text = "당신의 BMI 지수를\n알려드릴게요"
        subTitleLabel.font = .systemFont(ofSize: 14)
        subTitleLabel.textColor = .black
        subTitleLabel.numberOfLines = 0
    }
    
    private func setImageView() {
        imageView.image = .image
        imageView.contentMode = .scaleAspectFit
    }
    
    private func setTitleLabel(label: UILabel, text: String) {
        label.text = text
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
    }
    
    private func setTextFieldBackgroundViews() {
        for background in textFieldBackgroundView {
            background.backgroundColor = .white
            background.layer.cornerRadius = 16
            background.layer.borderWidth = 2
            background.layer.borderColor = UIColor.darkGray.cgColor
            background.clipsToBounds = true
        }
    }
    
    private func setTallTextField() {
        setTextField(textField: tallTextField)
        tallTextField.keyboardType = .numberPad
        tallTextField.placeholder = "숫자만 입력해주세요"
        tallTextField.text = tall
    }
    
    private func setWeightTextField() {
        setTextField(textField: weightTextField)
        weightTextField.keyboardType = .numberPad
        weightTextField.placeholder = "숫자만 입력해주세요"
        weightTextField.text = weight
    }
    
    private func setTextField(textField: UITextField) {
        textField.backgroundColor = .clear
        textField.borderStyle = .none
    }
    
    private func setWeightHiddenButton() {
        weightHiddenButton.setTitle("", for: .normal)
        weightHiddenButton.setImage(
            UIImage(systemName: isWeightHidden ? "eye.slash" : "eye"),
            for: .normal
        )
        weightHiddenButton.tintColor = .lightGray
    }
    
    private func setRandomButton() {
        randomButton.setTitle("랜덤으로 BMI 계산하기", for: .normal)
        randomButton.setTitleColor(.red, for: .normal)
        // ???: UIButton의 titleLabel은 get 프로퍼티라 다른 폰트 적용 방법이 있을까요?
        randomButton.titleLabel?.font = .systemFont(ofSize: 12)
        randomButton.titleLabel?.textAlignment = .right
        randomButton.contentHorizontalAlignment = .right
    }
    
    private func setResultButton() {
        setBottomButton(button: resultButton, title: "결과확인")
        resultButton.setTitleColor(.white, for: .normal)
        resultButton.backgroundColor = .purple
    }
    
    private func setSaveButton() {
        setBottomButton(button: saveButton, title: "저장")
        saveButton.setTitleColor(.purple, for: .normal)
        saveButton.backgroundColor = .white
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor.purple.cgColor
    }
    
    private func setResetButton() {
        setBottomButton(button: resetButton, title: "리셋")
        resetButton.setTitleColor(.red, for: .normal)
        resetButton.backgroundColor = .white
        resetButton.layer.borderWidth = 2
        resetButton.layer.borderColor = UIColor.red.cgColor
    }
    
    private func setBottomButton(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
    }
    
    private func presentAlert(title: String?, message: String? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    @IBAction func resultButtonTouchUpInside(_ sender: UIButton) {
        guard
            let tallText = tallTextField.text,
            let tall = Int(tallText),
            /// 기네스북 최고 키 251cm
            (0...251).contains(tall)
        else {
            presentAlert(
                title: "키 입력 오류",
                message: "키가 잘못 입력되었어요"
            )
            return
        }
        
        guard
            let weightText = weightTextField.text,
            let weight = Int(weightText),
            /// 기네스북 최고 몸무게 635kg
            (0...635).contains(weight)
        else {
            presentAlert(
                title: "몸무게 입력 오류",
                message: "몸무게가 잘못 입력되었어요"
            )
            return
        }
        
        let meterTall = Double(tall) / 100
        let bmi = Double(weight) / Double(meterTall * meterTall)
        presentAlert(
            title: "BMI 계산 결과",
            message: "BMI는 \(bmi) 입니다."
        )
    }
    
    @IBAction func saveButtonTouchUpInside(_ sender: UIButton) {
        tall = tallTextField.text
        weight = weightTextField.text
        nickname = nicknameTextField.text
        
        presentAlert(title: "저장완료")
    }
    
    @IBAction func resetButtonTouchUpInside(_ sender: UIButton) {
        tallTextField.text = ""
        weightTextField.text = ""
        nicknameTextField.text = ""
        
        tall = nil
        weight = nil
        nickname = nil
        
        presentAlert(title: "리셋완료")
    }
    
    @IBAction func randomButtonTouchUpInside(_ sender: UIButton) {
        let tall = Int.random(in: 0...251)
        let weight = Int.random(in: 0...635)
        tallTextField.text = "\(tall)"
        weightTextField.text = "\(weight)"
    }
}
