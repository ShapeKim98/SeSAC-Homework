//
//  ViewController.swift
//  RXSampleProject
//
//  Created by 김도형 on 2/18/25.
//

import UIKit

import SnapKit

class ViewController: UIViewController {
    private lazy var tableButton: UIButton = {
        let button = UIButton()
        button.setTitle("Simple Table", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addAction(
            UIAction { [weak self] _ in
                self?.pushTableViewController()
            },
            for: .touchUpInside
        )
        return button
    }()
    private lazy var validationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Simple Validation", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addAction(
            UIAction { [weak self] _ in
                self?.pushValidationViewController()
            },
            for: .touchUpInside
        )
        return button
    }()
    private lazy var numbersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Simple Numbers", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addAction(
            UIAction { [weak self] _ in
                self?.pushNumbersViewController()
            },
            for: .touchUpInside
        )
        return button
    }()
    private lazy var birthdayButton: UIButton = {
        let button = UIButton()
        button.setTitle("Simple Birthday", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addAction(
            UIAction { [weak self] _ in
                self?.pushBirthdayViewController()
            },
            for: .touchUpInside
        )
        return button
    }()
    private lazy var vstack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tableButton, validationButton, numbersButton, birthdayButton])
        stack.axis = .vertical
        stack.spacing = 32
        stack.distribution = .fillEqually
        view.addSubview(stack)
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        vstack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func pushTableViewController() {
        navigationController?.pushViewController(SimpleTableViewController(), animated: true)
    }
    
    private func pushValidationViewController() {
        navigationController?.pushViewController(SimpleValidationViewController(), animated: true)
    }
    
    private func pushNumbersViewController() {
        navigationController?.pushViewController(NumbersViewController(), animated: true)
    }
    
    private func pushBirthdayViewController() {
        navigationController?.pushViewController(BirthdayViewController(), animated: true)
    }
}

