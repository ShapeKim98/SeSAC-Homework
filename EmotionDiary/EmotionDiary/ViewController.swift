//
//  ViewController.swift
//  EmotionDiary
//
//  Created by 김도형 on 12/27/24.
//

import UIKit

class ViewController: UIViewController {
    enum EmotionType: Int, CaseIterable {
        case happy
        case love
        case favorite
        case embarrassment
        case upset
        case melancholy
        case bored
        case happy2
        case happy3
        
        var labelText: String {
            switch self {
            case .happy, .happy2, .happy3: return "행복해"
            case .love: return "사랑해"
            case .favorite: return "좋아해"
            case .embarrassment: return "당황해"
            case .upset: return "속상해"
            case .melancholy: return "우울해"
            case .bored: return "지루해"
            }
        }
        
        var userDefaultKey: String {
            switch self {
            case .happy: return "happy"
            case .love: return "love"
            case .favorite: return "favorite"
            case .embarrassment: return "embarrassment"
            case .upset: return "upset"
            case .melancholy: return "melancholy"
            case .bored: return "bored"
            case .happy2: return "happy2"
            case .happy3: return "happy3"
            }
        }
    }
    
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var emotionLabelList: [UILabel]!
    @IBOutlet var emotionButtonList: [UIButton]!
    
    @UserDefault(forKey: .emotion)
    private var emotionCounts: [String: Int]?
    
    private var cachedCount: [EmotionType: Int] = [:]
    private var cachedLabel: [UIButton: UILabel] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonAndLabel()
        
        setResetButton()
    }
    
    private func setButtonAndLabel() {
        let emotionList = EmotionType.allCases
        for (index, type) in emotionList.enumerated() {
            let button = emotionButtonList[index]
            button.setImage(
                UIImage(named: "mono_slime\(type.rawValue + 1)"),
                for: .normal
            )
            button.tag = type.rawValue
            
            let label = emotionLabelList[index]
            let count = emotionCounts?[type.userDefaultKey] ?? 0
            label.text = type.labelText + " \(count)"
            label.font = .systemFont(ofSize: 12)
            label.textAlignment = .center
            label.tag = type.rawValue
            
            cachedCount[type] = count
            cachedLabel[button] = label
        }
    }
    
    private func setResetButton() {
        resetButton.setTitle("리셋", for: .normal)
        resetButton.setTitleColor(.red, for: .normal)
    }
    
    @IBAction func emotionButtonTouchUpInside(_ sender: UIButton) {
        guard
            let type = EmotionType(rawValue: sender.tag),
            let count = cachedCount[type]
        else { return }
        
        let result = count + 1
        cachedCount[type] = result
        var newEmotionCounts: [String: Int] = [:]
        cachedCount.forEach { key, value in
            newEmotionCounts[key.userDefaultKey] = value
        }
        emotionCounts = newEmotionCounts
        
        let label = cachedLabel[sender]
        label?.text = type.labelText + " \(result)"
    }
    
    @IBAction func resetButtonTouchUpInside(_ sender: UIButton) {
        emotionCounts = nil
        let emotionList = EmotionType.allCases
        for (index, type) in emotionList.enumerated() {
            let label = emotionLabelList[index]
            let count = emotionCounts?[type.userDefaultKey] ?? 0
            cachedCount[type] = count
            label.text = type.labelText + " \(count)"
        }
    }
}

