//
//  SettingViewController.swift
//  Tamagotchi
//
//  Created by 김도형 on 1/1/25.
//

import UIKit

import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {
    @IBOutlet var captainTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    private let viewModel = NicknameViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindState()
        
        bindAction()

        setNavigationItem()
        
        setSaveButton()
        
        captainTextField.enablesReturnKeyAutomatically = true
    }

    private func setNavigationItem() {
        self.navigationController?.navigationBar.topItem?.title = "설정"
    }
    
    private func setSaveButton() {
        saveButton.setTitle("저장", for: .normal)
        saveButton.sizeToFit()
    }
    
    @IBAction func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: Bindings
private extension NicknameViewController {
    typealias Action = NicknameViewModel.Action
    
    func bindAction() {
        saveButton.rx.tap
            .withLatestFrom(captainTextField.rx.text.orEmpty)
            .map { Action.saveButtonTapped($0) }
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
        
        captainTextField.rx.text.orEmpty
            .map { Action.captainTextFieldTextOnChanged($0) }
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        bindCaptain()
        
        bindIsValidText()
    }
    
    func bindCaptain() {
        viewModel.observableState
            .map(\.captain)
            .distinctUntilChanged()
            .map { "\($0 ?? "대장")님 이름 정하기" }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.observableState
            .map(\.captain)
            .drive(captainTextField.rx.text)
            .dispose()
    }
    
    func bindIsValidText() {
        viewModel.observableState
            .map(\.isValidText)
            .distinctUntilChanged()
            .drive(saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
