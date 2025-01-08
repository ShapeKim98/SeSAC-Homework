//
//  ViewController.swift
//  Game369
//
//  Created by 김도형 on 1/8/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var numberTextFieldBackgroundView: UIView!
    @IBOutlet
    private var resultLabel: UILabel!
    @IBOutlet
    private var processLabel: UILabel!
    @IBOutlet
    private var numberTextField: UITextField!
    @IBOutlet
    private var titleLabel: UILabel!
    
    private let numberPickerView = UIPickerView()
    
    private var max: Int = 100
    private var numberList: [String] {
        (1...(max)).reversed().map { String($0) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTitleLabel()
        
        configureNumberTextField()
        
        configureProcessLabel()
        
        configureResultLabel()
    }
    
    private func configureTitleLabel() {
        titleLabel.text = "369게임"
        titleLabel.font = .boldSystemFont(ofSize: 36)
        titleLabel.textAlignment = .center
    }
    
    private func configureNumberTextField() {
        numberTextField.placeholder = "최대 숫자를 입력하세요"
        numberTextField.font = .systemFont(ofSize: 28)
        numberTextField.borderStyle = .none
        numberTextFieldBackgroundView.layer.borderColor = UIColor.label.cgColor
        numberTextFieldBackgroundView.layer.borderWidth = 1
    }
    
    private func configureProcessLabel() {
        processLabel.text = ""
        processLabel.textColor = .secondaryLabel
        processLabel.font = .systemFont(ofSize: 28)
        processLabel.textAlignment = .center
        processLabel.numberOfLines = 0
    }
    
    private func configureResultLabel() {
        resultLabel.text = ""
        resultLabel.font = .boldSystemFont(ofSize: 36)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numberList[component]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let selectedNumber = Int(numberList[component]) else { return }
        
    }
}
