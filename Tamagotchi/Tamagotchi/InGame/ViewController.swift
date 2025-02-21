//
//  ViewController.swift
//  Tamagotchi
//
//  Created by 김도형 on 12/31/24.
//

import UIKit

import RxSwift
import RxCocoa

class ViewController: UIViewController {
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
        let confirm = UIAlertAction(title: "확인", style: .default)
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
private extension ViewController {
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
        viewModel.observableState
            .map { "\($0.captain ?? "대장")님의 다마고치" }
            .distinctUntilChanged()
            .debug()
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.observableState
            .map {
                "LV\($0.level ?? 1) ∙ 밥알 \($0.rice ?? 0)개 ∙ 물방울 \($0.waterDrop ?? 0)개"
            }
            .debug()
            .drive(tamagotchiInfoLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.observableState
            .compactMap(\.level)
            .distinctUntilChanged()
            .debug()
            .map { level in
                if level >= 9 {
                    UIImage(named: "2-9")
                } else {
                    UIImage(named: "2-\(level)")
                }
            }
            .drive(tamagotchiImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.observableState
            .map { $0.message.text($0.captain ?? "대장") }
            .distinctUntilChanged()
            .debug()
            .drive(bubbleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension ViewController {
    enum Message: CaseIterable {
        case 복습_아직_안하셨다구요_지금_잠이_오세여_대장님
        case 대장님_오늘_깃허브_푸시_하셨어영
        case 대장님_밥주세여
        case 밥과_물을_잘먹었더니_레벨업_했어여_고마워요_대장님
        
        func text(_ captain: String) -> String {
            switch self {
            case .복습_아직_안하셨다구요_지금_잠이_오세여_대장님:
                return "복습 아직 안하셨다구요? 지금 잠이 오세여? \(captain)님?"
            case .대장님_오늘_깃허브_푸시_하셨어영:
                return "\(captain)님 오늘 깃허브 푸시 하셨어영?"
            case .대장님_밥주세여:
                return "\(captain)님, 밥주세여"
            case .밥과_물을_잘먹었더니_레벨업_했어여_고마워요_대장님:
                return "밥과 물을 잘먹었더니 레벨업 했어여 고마워요 \(captain)님"
            }
        }
    }
}
