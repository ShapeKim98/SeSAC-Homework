//
//  TouristViewController.swift
//  Travel
//
//  Created by 김도형 on 1/7/25.
//

import UIKit

import Kingfisher

class TouristViewController: UIViewController {
    @IBOutlet
    private var anotherTravelButton: UIButton!
    @IBOutlet
    private var descriptionLabel: UILabel!
    @IBOutlet
    private var titleLabel: UILabel!
    @IBOutlet
    private var travelImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTravelImageView()
        
        setTitleLabel()
        
        setDescriptionLabel()
        
        setAnotherTravelButton()
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setTravelImageView() {
        travelImageView.contentMode = .scaleAspectFill
        travelImageView.layer.cornerRadius = 12
        travelImageView.clipsToBounds = true
    }
    
    private func setTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }
    
    private func setDescriptionLabel() {
        descriptionLabel.font = .boldSystemFont(ofSize: 18)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
    }
    
    private func setAnotherTravelButton() {
        anotherTravelButton.setTitleColor(.white, for: .normal)
        anotherTravelButton.configuration?.background.backgroundColor = .systemTeal
        anotherTravelButton.configuration?.cornerStyle = .capsule
        let attributedTitle = NSAttributedString(
            string: "다른 관광지 보러 가기",
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.boldSystemFont(ofSize: 14)
            ]
        )
        anotherTravelButton.configuration?.attributedTitle = AttributedString(attributedTitle)
    }
    
    @IBAction
    private func anotherTravelButtonTouchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
