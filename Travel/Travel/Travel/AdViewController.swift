//
//  AdViewController.swift
//  Travel
//
//  Created by 김도형 on 1/7/25.
//

import UIKit

class AdViewController: UIViewController {
    @IBOutlet
    private var titleLabel: UILabel!
    
    private var titleText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        setTitleLabel()
    }
    
    func setTitleText(title: String) {
        titleText = title
    }
    
    private func setNavigationBar() {
        navigationItem.title = "광고 화면"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(self.dismiss)
        )
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func setTitleLabel() {
        titleLabel.text = titleText
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }
    
    @objc
    private func dismiss(_ viewController: AdViewController) {
        dismiss(animated: true)
    }
}

extension String {
    static let adController = "AdViewController"
}
