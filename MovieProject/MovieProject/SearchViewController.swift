//
//  SearchViewController.swift
//  MovieProject
//
//  Created by 김도형 on 12/28/24.
//

import UIKit

class SearchViewController: UIViewController {
    enum ButtonType: Int {
        case willReleaase
        case popular
        case top10
    }
    
    @IBOutlet var subEmptyLabel: UILabel!
    @IBOutlet var emptyLabel: UILabel!
    @IBOutlet var top10Button: UIButton!
    @IBOutlet var popularButton: UIButton!
    @IBOutlet var willReleaseButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
    
    private var selectedButton: ButtonType = .willReleaase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setSearchTextField()
        
        updateButtons()
        
        setEmptyLabel()
        
        setSubEmptyLabel()
    }
    
    private func setSearchTextField() {
        searchTextField.placeholder = "게임, 시리즈, 영화를 검색하세요..."
        searchTextField.textColor = .white
        searchTextField.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchTextField.leftViewMode = .always
        searchTextField.backgroundColor = .secondaryLabel
        searchTextField.tintColor = .lightGray
    }
    
    private func updateButtons() {
        setButton(
            willReleaseButton,
            title: "공개예정",
            imageName: "blue",
            type: .willReleaase
        )
        
        setButton(
            popularButton,
            title: "모두의 인기 콘텐츠",
            imageName: "turquoise",
            type: .popular
        )
        
        setButton(
            top10Button,
            title: "TOP 10 시리즈",
            imageName: "pink",
            type: .top10
        )
    }
    
    private func setButton(
        _ button: UIButton,
        title: String,
        imageName: String,
        type: ButtonType
    ) {
        let isSelected = selectedButton == type
        
        button.tag = type.rawValue
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = isSelected ? .black : .white
        button.tintColor = isSelected ? .black : .white
        button.setImage(UIImage(named: imageName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 18
        button.backgroundColor = isSelected ? .white : .clear
        button.clipsToBounds = true
    }
    
    private func setEmptyLabel() {
        emptyLabel.font = .boldSystemFont(ofSize: 20)
        emptyLabel.textColor = .white
        emptyLabel.textAlignment = .center
        
        updateEmptyLabel()
    }
    
    private func setSubEmptyLabel() {
        subEmptyLabel.font = .systemFont(ofSize: 16)
        subEmptyLabel.textColor = .darkGray
        subEmptyLabel.textAlignment = .center
        subEmptyLabel.text = "다른 영화, 시리즈, 배우, 감독 또는 장르를 검색해보세요"
    }
    
    private func updateEmptyLabel() {
        switch selectedButton {
        case .willReleaase:
            emptyLabel.text = "이런! 찾으시는 공개예정 작품이 없습니다."
        case .popular:
            emptyLabel.text = "이런! 찾으시는 인기 작품이 없습니다."
        case .top10:
            emptyLabel.text = "이런! 찾으시는 TOP 10 작품이 없습니다."
        }
    }
    
    @IBAction func typeButtonTouchUpInside(_ sender: UIButton) {
        guard let type = ButtonType(rawValue: sender.tag) else {
            return
        }
        selectedButton = type
        updateButtons()
        updateEmptyLabel()
    }
}
