//
//  MovieListViewController.swift
//  MovieProject
//
//  Created by 김도형 on 12/28/24.
//

import UIKit

class MovieListViewController: UIViewController {
    @IBOutlet var detailButton: UIButton!
    @IBOutlet var settingButton: UIButton!
    @IBOutlet var netflixImageView: UIImageView!
    @IBOutlet var top10ImageViewList: [UIImageView]!
    @IBOutlet var posterImageViewList: [UIImageView]!
    @IBOutlet var posterBackgroundView: UIView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    private let movies = ["극한직업", "노량", "더퍼스트슬램덩크"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setTitleLabel()
        
        setDescriptionLabel()
        
        setPosterBackgroundView()
        
        setPosterImages()
        
        setTop10Images()
        
        netflixImageView.image = UIImage(named: "single-small")
        
        setSettingButton()
        
        setDetailButton()
    }
    
    private func setTitleLabel() {
        titleLabel.text = "'나만의 자동 저장' 기능"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
    }
    
    private func setDescriptionLabel() {
        descriptionLabel.text = """
        취향에 맞는 영화와 시리즈를 자동으로 저장해드립니다.
        디바이스에 언제나 시청할 콘텐츠가 준비되니 지루할 틈이 없어요.
        """
        descriptionLabel.textColor = .darkGray
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 3
    }
    
    private func setPosterBackgroundView() {
        posterBackgroundView.backgroundColor = .secondaryLabel
        posterBackgroundView.layer.cornerRadius = 120
        posterBackgroundView.clipsToBounds = true
    }
    
    private func setPosterImages() {
        for (index, movie) in movies.enumerated() {
            let imageView = posterImageViewList[index]
            imageView.image = UIImage(named: movie)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 4
            imageView.clipsToBounds = true
        }
    }
    
    private func setTop10Images() {
        for imageView in top10ImageViewList {
            imageView.image = UIImage(named: "top10 badge")
            imageView.layer.cornerRadius = 4
            imageView.clipsToBounds = true
        }
    }
    
    private func setSettingButton() {
        settingButton.setTitle("설정하기", for: .normal)
        settingButton.setTitleColor(.white, for: .normal)
        settingButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        settingButton.tintColor = .white
        settingButton.backgroundColor = .systemBlue
        settingButton.layer.cornerRadius = 4
        settingButton.clipsToBounds = true
    }
    
    private func setDetailButton() {
        detailButton.setTitle("저장 가능한 콘텐츠 살펴보기", for: .normal)
        detailButton.setTitleColor(.black, for: .normal)
        detailButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        detailButton.tintColor = .black
        detailButton.backgroundColor = .white
        detailButton.layer.cornerRadius = 4
        detailButton.clipsToBounds = true
    }
}
