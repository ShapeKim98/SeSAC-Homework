//
//  ViewController.swift
//  NewWordSearcher
//
//  Created by 김도형 on 12/29/24.
//

import UIKit

class ViewController: UIViewController {
    struct NewWord: Hashable {
        let value: String
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(value.lowercased())
        }
        
        static func == (lhs: NewWord, rhs: NewWord) -> Bool {
            lhs.value.lowercased() == rhs.value.lowercased()
        }
        
        init(_ value: String) {
            self.value = value
        }
    }
    
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var resultBackgourndImageView: UIImageView!
    @IBOutlet var recommendedButtonList: [UIButton]!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
    
    private let newWordDictionary: [NewWord: String] = [
        NewWord("디토합니다"): "라틴어로 '동의'라는 뜻",
        NewWord("오우예시몬"): "C'mon(커몬)을 씨몬이라 읽으며 생긴 신조어",
        NewWord("중꺾그마"): "중요한 건 꺾였는데도 그냥하는 마음",
        NewWord("KIJUL"): "기절을 영어로 적은 것",
        NewWord("맛꿀마"): "JMT를 대신하는 신조어",
        NewWord("웅니"): "언니를 부르는 말",
        NewWord("설참"): "설명 참고를 줄여 부르는 말",
        NewWord("가나디"): "강아지를 발음대로 부르는 말",
        NewWord("슬세권"): "슬리퍼로 갈 수 있는 거리",
        NewWord("뉴런공유"): "나와 생각이나 행동이 비슷한 사람을 보고 하는 말",
        NewWord("일며들다"): "일이 내 삶에 스며들었다",
        NewWord("내또출"): "내일 또 출근의 줄임말"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setSearchTextField()
        
        setSearchButton()
        
        setRecommendedButtons()
        
        setResultLabel()
        
        setResultBackgroundImageView()
    }
    
    private func setSearchTextField() {
        searchTextField.textColor = .black
        searchTextField.borderStyle = .line
        searchTextField.layer.borderColor = UIColor.black.cgColor
        searchTextField.layer.borderWidth = 2
    }
    
    private func setSearchButton() {
        searchButton.setTitle("", for: .normal)
        searchButton.setImage(
            UIImage(systemName: "magnifyingglass"),
            for: .normal
        )
        searchButton.backgroundColor = .black
        searchButton.configuration?.cornerStyle = .fixed
        searchButton.tintColor = .white
    }
    
    private func setRecommendedButtons() {
        let newWordList = newWordDictionary.map(\.key)
        for (index, button) in recommendedButtonList.enumerated() {
            let newWord = newWordList[index].value
            button.setTitle(newWord, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 8
            button.configuration?.contentInsets = .init(
                top: 6,
                leading: 6,
                bottom: 6,
                trailing: 6
            )
            button.configuration?.buttonSize = .mini
            button.sizeToFit()
            button.clipsToBounds = true
        }
    }
    
    private func setResultLabel() {
        resultLabel.text = ""
        resultLabel.textColor = .black
        resultLabel.numberOfLines = 0
        resultLabel.textAlignment = .center
    }
    
    private func setResultBackgroundImageView() {
        resultBackgourndImageView.image = .background
        resultBackgourndImageView.contentMode = .scaleAspectFit
    }
    
    private func searchResult(newWord: String) {
        let result = newWordDictionary[NewWord(newWord)]
        resultLabel.text = result ?? "검색결과가 없습니다"
    }
    
    @IBAction func searchTextFieldDidEndOnExit(_ sender: UITextField) {
        guard let newWord = sender.text else { return }
        searchResult(newWord: newWord)
    }
    
    @IBAction func searchButtonTouchUpInside(_ sender: UIButton) {
        guard let newWord = searchTextField.text else { return }
        view.endEditing(true)
        searchResult(newWord: newWord)
    }
    
    @IBAction func recommendedButtonTouchUpInside(_ sender: UIButton) {
        guard let newWord = sender.currentTitle else { return }
        view.endEditing(true)
        searchTextField.text = newWord
        searchResult(newWord: newWord)
    }
    
    @IBAction func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

