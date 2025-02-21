//
//  ViewController.swift
//  Tamagotchi
//
//  Created by 김도형 on 12/31/24.
//

import UIKit

import RxSwift
import RxCocoa

class InGameViewController: UIViewController {
    @IBOutlet var settingButton: UIButton!
    @IBOutlet var waterDropButton: UIButton!
    @IBOutlet var riceButton: UIButton!
    @IBOutlet var waterDropTextField: UITextField!
    @IBOutlet var riceTextField: UITextField!
    @IBOutlet var tamagotchiInfoLabel: UILabel!
    @IBOutlet var tamagotchiNameLabel: UILabel!
    @IBOutlet var tamagotchiImageView: UIImageView!
    @IBOutlet var bubbleLabel: UILabel!
    
    private let viewModel = InGameViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItem()
        
        setFeedButton(riceButton)
        setFeedButton(waterDropButton)
        
        riceTextField.keyboardType = .numberPad
        waterDropTextField.keyboardType = .numberPad
        
        bindState()
        
        bindAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.send.accept(.viewDidAppear)
    }
    
    private func setNavigationItem() {
        settingButton.setTitle("", for: .normal)
        settingButton.setImage(UIImage(systemName: "person.circle"), for: .normal)
        settingButton.sizeToFit()
    }
    
    private func presentAlert(title: String?, message: String? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(
            title: "확인",
            style: .default
        ) { [weak self] action in
            action.isEnabled = false
            self?.viewModel.send.accept(.alertConfirmButtonTapped)
        }
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    private func setFeedButton(_ button: UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        button.layer.borderWidth = 1
    }
    
    @IBAction func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: Bidings
private extension InGameViewController {
    typealias Action = InGameViewModel.Action
    
    func bindAction() {
        riceButton.rx.tap
            .withLatestFrom(riceTextField.rx.text.orEmpty)
            .map { Action.riceButtonTapped($0) }
            .debug()
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
        
        waterDropButton.rx.tap
            .withLatestFrom(waterDropTextField.rx.text.orEmpty)
            .map { Action.waterDropButtonTapped($0) }
            .debug()
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        bindCaptain()
        
        bindTamagotchiState()
        
        bindLevel()
        
        bindMessage()
        
        bindAlertMessage()
    }
    
    func bindCaptain() {
        viewModel.observableState
            .map { "\($0.captain ?? "대장")님의 다마고치" }
            .distinctUntilChanged()
            .debug()
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    func bindTamagotchiState() {
        viewModel.observableState
            .map {
                "LV\($0.level ?? 1) ∙ 밥알 \($0.rice ?? 0)개 ∙ 물방울 \($0.waterDrop ?? 0)개"
            }
            .distinctUntilChanged()
            .debug()
            .drive(tamagotchiInfoLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindLevel() {
        viewModel.observableState
            .compactMap(\.level)
            .distinctUntilChanged()
            .debug()
            .map { UIImage(named: "2-\($0 >= 9 ? 9 : $0)") }
            .drive(tamagotchiImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    func bindMessage() {
        viewModel.observableState
            .map { $0.message.text($0.captain ?? "대장") }
            .distinctUntilChanged()
            .debug()
            .drive(bubbleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindAlertMessage() {
        viewModel.observableState
            .compactMap(\.alertMessage)
            .debug()
            .drive(with: self) { this, message in
                this.presentAlert(title: "밥먹기 오류", message: message)
            }
            .disposed(by: disposeBag)
    }
}
