//
//  ViewController.swift
//  UpDownGame
//
//  Created by 김도형 on 1/9/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet
    private var numberTextField: UITextField!
    @IBOutlet
    private var gameImageView: UIImageView!
    @IBOutlet
    private var gameLabel: UILabel!
    @IBOutlet
    private var resultLabel: UILabel!
    @IBOutlet
    private var startButton: UIButton!
    @IBOutlet
    private var numberTextFieldBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .accent
        
        configureResultLabel()
        
        configureGameLabel()
        
        configureGameImageView()
        
        configureNumberTextField()
        
        configureStartButton()
    }
    
    @IBAction
    private func startButtonTouchUpInside(_ sender: UIButton) {
        guard
            let text = numberTextField.text,
            let number = Int(text)
        else { return }
        presentInGameViewController(number)
    }
    
    @IBAction
    private func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: View
private extension ViewController {
    func configureResultLabel() {
        resultLabel.text = "UP DOWN"
        resultLabel.font = .udLargeTitle
        resultLabel.textAlignment = .center
    }
    
    func configureGameLabel() {
        gameLabel.text = "GAME"
        gameLabel.font = .udTitle
        gameLabel.textAlignment = .center
    }
    
    func configureGameImageView() {
        gameImageView.image = UIImage(named: "emotion1")
        gameImageView.contentMode = .scaleAspectFit
    }
    
    func configureNumberTextField() {
        numberTextField.font = .boldSystemFont(ofSize: 16)
        numberTextField.borderStyle = .none
        numberTextField.textAlignment = .center
        
        numberTextFieldBackgroundView.backgroundColor = .white
    }
    
    func configureStartButton() {
        startButton.setUDButtonStyle(title: "시작하기")
    }
}

// MARK: Functions
private extension ViewController {
    func presentInGameViewController(_ number: Int) {
        let viewController = storyboard?.instantiateViewController(
            withIdentifier: .inGameViewController
        ) as? InGameViewController
        guard
            let viewController,
            let text = numberTextField.text,
            let number = Int(text)
        else { return }
        
        viewController.setMaxNumber(number)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true) { [weak self] in
            guard let `self` else { return }
            self.numberTextField.text = ""
        }
    }
}
