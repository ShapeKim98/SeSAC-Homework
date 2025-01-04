//
//  PosterViewController.swift
//  MovieProject
//
//  Created by 김도형 on 12/27/24.
//

import UIKit

class PosterViewController: UIViewController {
    enum HotPosterType: CaseIterable {
        case normal
        case newEpisode
        case newSeries
    }
    
    @IBOutlet var netflixImageViewList: [UIImageView]!
    @IBOutlet var hotBottomLabelList: [UILabel]!
    @IBOutlet var hotTopLabelList: [UILabel]!
    @IBOutlet var top10ImageViewList: [UIImageView]!
    @IBOutlet var hotImageViewList: [UIImageView]!
    @IBOutlet var hotContentLabel: UILabel!
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var mainOverlayImageView: UIImageView!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var mainImageView: UIImageView!
    
    private var movies = [
        "극한직업",
        "노량",
        "더퍼스트슬램덩크",
        "도둑들",
        "명량",
        "밀수",
        "범죄도시3",
        "베테랑",
        "부산행",
        "서울의봄",
        "스즈메의문단속",
        "신과함께인과연",
        "신과함께죄와벌",
        "아바타",
        "아바타물의길",
        "알라딘",
        "암살",
        "어벤져스엔드게임",
        "오펜하이머",
        "왕의남자",
        "육사오",
        "콘크리트유토피아",
        "택시운전사",
        "해운대"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setMainPosterImageView()
        
        setMainPosterLabel()
        
        setPosterButton(
            playButton,
            title: "재생",
            imageName: "play.fill",
            backgroundColor: .white,
            tintColor: .black
        )
        
        setPosterButton(
            favoriteButton,
            title: "내가 찜한 리스트",
            imageName: "plus",
            backgroundColor: .darkGray,
            tintColor: .white
        )
        
        hotContentLabel.textColor = .white
        hotContentLabel.text = "지금 뜨는 콘텐츠"
        
        setHotPosters()
    }
    
    private func setMainPosterImageView() {
        mainImageView.image = UIImage(named: movies[0])
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.layer.cornerRadius = 12
        mainImageView.clipsToBounds = true
        
        mainOverlayImageView.image = UIImage(named: "background")
        mainOverlayImageView.contentMode = .scaleAspectFill
        mainOverlayImageView.layer.borderWidth = 1
        mainOverlayImageView.layer.borderColor = UIColor(white: 1, alpha: 0.1).cgColor
        mainOverlayImageView.layer.cornerRadius = 12
        mainOverlayImageView.clipsToBounds = true
    }
    
    private func setMainPosterLabel() {
        mainLabel.text = "응원하고픈 ∙ 흥미진진 ∙ 사극 ∙ 전투 ∙ 한국 작품"
        mainLabel.textAlignment = .center
        mainLabel.textColor = .white
        mainLabel.font = .systemFont(ofSize: 12)
    }
    
    private func setHotPosters() {
        for i in 0...2 {
            hotImageViewList[i].contentMode = .scaleAspectFill
            hotImageViewList[i].layer.borderWidth = 1
            hotImageViewList[i].layer.borderColor = UIColor(white: 1, alpha: 0.1).cgColor
            hotImageViewList[i].layer.cornerRadius = 4
            hotImageViewList[i].clipsToBounds = true
            top10ImageViewList[i].image = UIImage(named: "top10 badge")
            top10ImageViewList[i].layer.cornerRadius = 4
            top10ImageViewList[i].clipsToBounds = true
            netflixImageViewList[i].image = UIImage(named: "single-small")
        }
        
        updateHotPosters()
    }
    
    private func setPosterButton(
        _ button: UIButton,
        title: String,
        imageName: String,
        backgroundColor: UIColor,
        tintColor: UIColor
    ) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .center
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tintColor = tintColor
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
    }
    
    private func updateHotPosters() {
        for (index, imageView) in hotImageViewList.enumerated() {
            imageView.image = UIImage(named: movies[index + 1])
            setHotPosterLabel(
                HotPosterType.allCases.randomElement() ?? .normal,
                topLabel: hotTopLabelList[index],
                bottomLabel: hotBottomLabelList[index]
            )
            let bools = [true, false]
            netflixImageViewList[index].isHidden = bools.randomElement() ?? false
            top10ImageViewList[index].isHidden = bools.randomElement() ?? false
        }
    }
    
    private func setHotPosterLabel(
        _ type: HotPosterType,
        topLabel: UILabel,
        bottomLabel: UILabel
    ) {
        switch type {
        case .normal:
            normalLabel(topLabel: topLabel, bottomLabel: bottomLabel)
        case .newEpisode:
            newEpisodeLabel(topLabel: topLabel, bottomLabel: bottomLabel)
        case .newSeries:
            newSeriesLabel(topLabel: topLabel, bottomLabel: bottomLabel)
        }
    }
    
    private func normalLabel(topLabel: UILabel, bottomLabel: UILabel) {
        topLabel.isHidden = true
        bottomLabel.isHidden = true
    }
    
    private func newEpisodeLabel(topLabel: UILabel, bottomLabel: UILabel) {
        topLabel.isHidden = false
        topLabel.text = "새로운 에피소드"
        topLabel.textAlignment = .center
        topLabel.font = .systemFont(ofSize: 12)
        topLabel.textColor = .white
        topLabel.backgroundColor = .red
        
        bottomLabel.isHidden = false
        bottomLabel.text = "지금 시청하기"
        bottomLabel.textAlignment = .center
        bottomLabel.font = .systemFont(ofSize: 12)
        bottomLabel.textColor = .black
        bottomLabel.backgroundColor = .white
    }
    
    private func newSeriesLabel(topLabel: UILabel, bottomLabel: UILabel) {
        topLabel.isHidden = true
        
        bottomLabel.isHidden = false
        bottomLabel.text = "새로운 시리즈"
        bottomLabel.textAlignment = .center
        bottomLabel.font = .systemFont(ofSize: 12)
        bottomLabel.textColor = .white
        bottomLabel.backgroundColor = .red
    }
    
    @IBAction func playButtonTouchUpInside(_ sender: UIButton) {
        movies.shuffle()
        mainImageView.image = UIImage(named: movies[0])
        updateHotPosters()
    }
}
