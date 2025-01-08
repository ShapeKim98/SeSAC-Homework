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
    
    private var numberList: [String] = (1...100).reversed().map { String($0) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTitleLabel()
        
        configureNumberTextField()
        
        configureProcessLabel()
        
        configureResultLabel()
        
        numberPickerView.delegate = self
        numberPickerView.dataSource = self
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
        numberTextField.inputView = numberPickerView
        numberTextField.tintColor = .clear
        numberTextFieldBackgroundView.layer.borderColor = UIColor.label.cgColor
        numberTextFieldBackgroundView.layer.borderWidth = 1
    }
    
    private func configureProcessLabel() {
        processLabel.text = ""
        processLabel.textColor = .secondaryLabel
        processLabel.font = .systemFont(ofSize: 18)
        processLabel.textAlignment = .center
        processLabel.numberOfLines = 0
    }
    
    private func configureResultLabel() {
        resultLabel.text = ""
        resultLabel.font = .boldSystemFont(ofSize: 36)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
    }
    
    private func makeProcess(_ max: Int) -> String {
        let numbers = (1...max).map { String($0) }
        let result = numbers.map { number in
            number
                .replacingOccurrences(of: "3", with: "👏")
                .replacingOccurrences(of: "6", with: "👏")
                .replacingOccurrences(of: "9", with: "👏")
        }.joined(separator: ", ")
        return result
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberList.count
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numberList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberTextField.text = numberList[row]
        guard let selectedNumber = Int(numberList[row]) else { return }
        processLabel.text = makeProcess(selectedNumber)
        print(selectedNumber)
    }
}
