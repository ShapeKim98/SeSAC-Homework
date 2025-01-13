//
//  ViewController.swift
//  SnapKitPractice
//
//  Created by 김도형 on 1/13/25.
//

import UIKit

import SnapKit

class ViewController: UIViewController {
    let jackflixButton = UIButton()
    let naverPayButton = UIButton()
    let movieSearchButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNaverPayButton()
        
        configureJackflixButton()
    }
}

private extension ViewController {
    func configureJackflixButton() {
        view.addSubview(jackflixButton)
        jackflixButton.setTitle("JACKFLIX", for: .normal)
        jackflixButton.setTitleColor(.blue, for: .normal)
        jackflixButton.addTarget(
            self,
            action: #selector(jackflixButtonTouchUpInside),
            for: .touchUpInside
        )
        jackflixButton.snp.makeConstraints { make in
            make.bottom.equalTo(naverPayButton.snp.top).offset(-60)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureNaverPayButton() {
        view.addSubview(naverPayButton)
        naverPayButton.setTitle("네이버 페이", for: .normal)
        naverPayButton.setTitleColor(.blue, for: .normal)
        naverPayButton.addTarget(
            self,
            action: #selector(naverPayButtonTouchUpInside),
            for: .touchUpInside
        )
        naverPayButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc
    func jackflixButtonTouchUpInside() {
        let viewController = JackflixViewController()
        present(viewController, animated: true)
    }
    
    @objc
    func naverPayButtonTouchUpInside() {
        let viewController = NaverPayViewController()
        present(viewController, animated: true)
    }
}

#Preview {
    ViewController()
}
