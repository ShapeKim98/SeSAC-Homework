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
    let lottoButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureNaverPayButton()
        
        configureJackflixButton()
        
        configureMovieSearchButton()
        
        configureLottoButton()
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
    
    func configureMovieSearchButton() {
        view.addSubview(movieSearchButton)
        movieSearchButton.setTitle("영화 검색", for: .normal)
        movieSearchButton.setTitleColor(.blue, for: .normal)
        movieSearchButton.addTarget(
            self,
            action: #selector(movieSearchButtonTouchUpInside),
            for: .touchUpInside
        )
        movieSearchButton.snp.makeConstraints { make in
            make.top.equalTo(naverPayButton.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureLottoButton() {
        view.addSubview(lottoButton)
        lottoButton.setTitle("로또 조회", for: .normal)
        lottoButton.setTitleColor(.blue, for: .normal)
        lottoButton.addTarget(
            self,
            action: #selector(lottoButtonTouchUpInside),
            for: .touchUpInside
        )
        lottoButton.snp.makeConstraints { make in
            make.top.equalTo(movieSearchButton.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
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
    
    @objc
    func movieSearchButtonTouchUpInside() {
        let viewController = MovieSearchViewController()
        present(viewController, animated: true)
    }
    
    @objc
    func lottoButtonTouchUpInside() {
        let viewController = LottoViewController()
        present(viewController, animated: true)
    }
}

#Preview {
    ViewController()
}
