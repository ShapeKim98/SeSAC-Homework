//
//  ViewController.swift
//  Tamagotchi
//
//  Created by 김도형 on 12/31/24.
//

import UIKit

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
    
    @UserDefault(
        forKey: .userDefault(.captain),
        defaultValue: "대장"
    )
    private var captain: String? {
        didSet { updateBubbleLabelRandomly() }
    }
    @UserDefault(
        forKey: .userDefault(.waterDrop),
        defaultValue: 0
    )
    private var waterDrop: Int? {
        didSet {
            updateBubbleLabelRandomly()
            updateTamagotchiInfoLabel()
        }
    }
    @UserDefault(
        forKey: .userDefault(.rice),
        defaultValue: 0
    )
    private var rice: Int? {
        didSet {
            updateBubbleLabelRandomly()
            updateTamagotchiInfoLabel()
        }
    }
    @UserDefault(
        forKey: .userDefault(.level),
        defaultValue: 1
    )
    private var level: Int? {
        didSet { updateTamagotchiInfoLabel() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setNavigationItem()
        updateTamagotchiImageView()
        updateBubbleLabelRandomly()
        updateTamagotchiInfoLabel()
        
        setFeedButton(riceButton)
        setFeedButton(waterDropButton)
        
        riceTextField.keyboardType = .numberPad
        waterDropTextField.keyboardType = .numberPad
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateBubbleLabelRandomly()
        self.navigationItem.title = "\(captain ?? "대장")님의 다마고치"
    }
    
    private func setNavigationItem() {
        self.navigationItem.title = "\(captain ?? "대장")님의 다마고치"
        settingButton.setTitle("", for: .normal)
        settingButton.setImage(UIImage(systemName: "person.circle"), for: .normal)
        settingButton.sizeToFit()
    }
    
    private func updateBubbleLabelRandomly() {
        let message = Message.allCases.filter {
            $0 != .밥과_물을_잘먹었더니_레벨업_했어여_고마워요_대장님
        }.randomElement()
        guard
            let captain,
            let text = message?.text(captain)
        else { return }
        bubbleLabel.text = text
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
    
    private func updateLevel() {
        guard let rice, let waterDrop else { return }
        let score = (Double(rice) / 5) + (Double(waterDrop) / 2)
        let oldLevel = level ?? 1
        switch score {
        case ..<20: level = 1
        case 20..<30 where oldLevel < 2:
            levelUpBubbleLabel(newLevel: 2)
        case 30..<40 where oldLevel < 3:
            levelUpBubbleLabel(newLevel: 3)
        case 40..<50 where oldLevel < 4:
            levelUpBubbleLabel(newLevel: 4)
        case 50..<60 where oldLevel < 5:
            levelUpBubbleLabel(newLevel: 5)
        case 60..<70 where oldLevel < 6:
            levelUpBubbleLabel(newLevel: 6)
        case 70..<80 where oldLevel < 7:
            levelUpBubbleLabel(newLevel: 7)
        case 80..<90 where oldLevel < 8:
            levelUpBubbleLabel(newLevel: 8)
        case 90..<100 where oldLevel < 9:
            levelUpBubbleLabel(newLevel: 9)
        case 100... where oldLevel < 10:
            levelUpBubbleLabel(newLevel: 10)
        default: break
        }
        updateTamagotchiImageView()
    }
    
    private func levelUpBubbleLabel(newLevel: Int) {
        level = newLevel
        bubbleLabel.text = Message.밥과_물을_잘먹었더니_레벨업_했어여_고마워요_대장님.text(captain ?? "대장")
    }
    
    private func updateTamagotchiInfoLabel() {
        tamagotchiInfoLabel.text = "LV\(level ?? 1) ∙ 밥알 \(rice ?? 0)개 ∙ 물방울 \(waterDrop ?? 0)개"
    }
    
    private func setFeedButton(_ button: UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        button.layer.borderWidth = 1
    }
    
    private func updateTamagotchiImageView() {
        var imageName: String = "2-1"
        switch level {
        case .none, 1: imageName = "2-1"
        case 2: imageName = "2-2"
        case 3: imageName = "2-3"
        case 4: imageName = "2-4"
        case 5: imageName = "2-5"
        case 6: imageName = "2-6"
        case 7: imageName = "2-7"
        case 8: imageName = "2-8"
        case 9, 10: imageName = "2-9"
        default: break
        }
        tamagotchiImageView.image = .init(named: imageName)
    }
    
    @IBAction func riceButtonTouchUpInside(_ sender: UIButton) {
        guard let riceText = riceTextField.text else { return }
        guard !riceText.isEmpty else {
            rice += 1
            updateLevel()
            return
        }
        guard let riceInt = Int(riceText) else {
            presentAlert(title: "밥먹기 오류", message: "숫자만 입력해주세요")
            return
        }
        guard riceInt < 100 else {
            presentAlert(title: "밥먹기 오류", message: "한 번에 최대 99개까지 먹을 수 있어요")
            return
        }
        rice += riceInt
        riceTextField.text = ""
        view.endEditing(true)
        updateLevel()
    }
    
    @IBAction func waterDropButtonTouchUpInside(_ sender: UIButton) {
        guard let waterDropText = waterDropTextField.text else { return }
        guard !waterDropText.isEmpty else {
            waterDrop += 1
            updateLevel()
            return
        }
        guard let waterDropInt = Int(waterDropText) else {
            presentAlert(title: "물먹기 오류", message: "숫자만 입력해주세요")
            return
        }
        guard waterDropInt < 50 else {
            presentAlert(title: "물먹기 오류", message: "한 번에 최대 49개까지 먹을 수 있어요")
            return
        }
        waterDrop += waterDropInt
        waterDropTextField.text = ""
        view.endEditing(true)
        updateLevel()
    }
    
    @IBAction func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
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

extension Optional<Int> {
    static func += (lhs: inout Int?, rhs: Int?) {
        lhs = (lhs ?? 0) + (rhs ?? 0)
    }
}
