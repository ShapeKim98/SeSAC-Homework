//
//  SimpleValidationViewController.swift
//  RXSampleProject
//
//  Created by 김도형 on 2/18/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SimpleValidationViewController: UIViewController {
    private lazy var usernameLabel: UILabel = {
        configureLabel("Username")
    }()
    private lazy var passwordLabel: UILabel = {
        configureLabel("Password")
    }()
    private let usernameTextField = UITextField()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    private lazy var usernameMessageLabel: UILabel = {
        configureMessageLabel("Username has to be at least \(minUsernameLength) characters")
    }()
    private lazy var passwordMessageLabel: UILabel = {
        configureMessageLabel("Password has to be at least \(minPasswordLength) characters")
    }()
    private let doSomethingButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
    private let minUsernameLength = 5
    private let minPasswordLength = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
        
        bind()
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: Configure Views
private extension SimpleValidationViewController {
    func configureUI() {
        usernameTextField.borderStyle = .roundedRect
        view.addSubview(usernameTextField)
        
        view.addSubview(passwordTextField)
        
        configureDoSomethingButton()
    }
    
    func configureLayout() {
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        usernameMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameMessageLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        passwordMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        doSomethingButton.snp.makeConstraints { make in
            make.top.equalTo(passwordMessageLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func configureLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        view.addSubview(label)
        return label
    }
    
    func configureMessageLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .systemRed
        view.addSubview(label)
        return label
    }
    
    func configureDoSomethingButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Do something"
        configuration.background.backgroundColor = .systemGreen
        doSomethingButton.configuration = configuration
        view.addSubview(doSomethingButton)
    }
}

// MARK: Data Bindings
private extension SimpleValidationViewController {
    func bind() {
        let validUsernameObservable = usernameTextField.rx.text.orEmpty
            .withUnretained(self)
            .map { this, value in
                value.count >= this.minUsernameLength
            }
            .debug("username")
            .share(replay: 1)
        
        let validPasswordObservable = passwordTextField.rx.text.orEmpty
            .withUnretained(self)
            .map { this, value in
                value.count >= this.minPasswordLength
            }
            .debug("password")
            .share(replay: 1)
        
        validUsernameObservable
            .bind(to: usernameMessageLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        validUsernameObservable
            .bind(to: passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        validPasswordObservable
            .bind(to: passwordMessageLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            validUsernameObservable,
            validPasswordObservable
        )
        .map { $0 && $1 }
        .bind(to: doSomethingButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        doSomethingButton.rx.tap
            .bind(with: self) { this, _ in
                this.showAlert()
            }
            .disposed(by: disposeBag)
    }
}

#Preview {
    SimpleValidationViewController()
}
