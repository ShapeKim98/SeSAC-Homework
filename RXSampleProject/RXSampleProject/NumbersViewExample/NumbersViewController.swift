//
//  NumbersViewController.swift
//  RXSampleProject
//
//  Created by 김도형 on 2/18/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class NumbersViewController: UIViewController {
    private lazy var firstTextField: UITextField = {
        configureTextField()
    }()
    private lazy var secondTextField: UITextField = {
        configureTextField()
    }()
    private lazy var thirdTextField: UITextField = {
        configureTextField()
    }()
    private lazy var plusLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        view.addSubview(label)
        return label
    }()
    private lazy var separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .label
        self.view.addSubview(view)
        return view
    }()
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        view.addSubview(label)
        return label
    }()
    private lazy var vstack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            firstTextField,
            secondTextField,
            thirdTextField
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        view.addSubview(stack)
        return stack
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureLayout()
        
        bind()
    }
    
    private func configureLayout() {
        vstack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
        }
        
        plusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(thirdTextField)
            make.trailing.equalTo(thirdTextField.snp.leading).inset(-8)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(vstack.snp.bottom).offset(8)
            make.leading.equalTo(plusLabel.snp.leading)
            make.trailing.equalTo(vstack.snp.trailing)
            make.height.equalTo(1)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(separatorView)
        }
    }
    
    private func configureTextField() -> UITextField {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.borderStyle = .roundedRect
        return textField
    }
    
    private func bind() {
        Observable.combineLatest(
            firstTextField.rx.text.orEmpty.compactMap { Int($0) },
            secondTextField.rx.text.orEmpty.compactMap { Int($0) },
            thirdTextField.rx.text.orEmpty.compactMap { Int($0) }
        ) { first, second, third -> Int in
            return first + second + third
        }
        .debug()
        .map { "\($0)" }
        .bind(to: resultLabel.rx.text)
        .disposed(by: disposeBag)
    }
}

#Preview {
    NumbersViewController()
}
