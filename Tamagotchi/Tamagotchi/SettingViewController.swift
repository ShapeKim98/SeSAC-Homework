//
//  SettingViewController.swift
//  Tamagotchi
//
//  Created by 김도형 on 1/1/25.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet var captainTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    @Shared(.userDefaults(.captain, defaultValue: "대장"))
    private var captain: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationItem()
        
        setSaveButton()
        
        setCaptainTextField()
    }

    private func setNavigationItem() {
        self.navigationItem.title = "\(captain ?? "대장")님 이름 정하기"
        self.navigationController?.navigationBar.topItem?.title = "설정"
    }
    
    private func setSaveButton() {
        saveButton.setTitle("저장", for: .normal)
        saveButton.sizeToFit()
    }
    
    private func setCaptainTextField() {
        captainTextField.text = captain
    }
    
    @IBAction func saveButtonTouchUpInside(_ sender: UIButton) {
        captain = captainTextField.text
        self.navigationItem.title = "\(captain ?? "대장")님 이름 정하기"
        view.endEditing(true)
    }
    
    @IBAction func captainTextFieldEditingChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        let isValidText = (2...6).contains(text.count)
        saveButton.isEnabled = isValidText
    }
    
    @IBAction func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
