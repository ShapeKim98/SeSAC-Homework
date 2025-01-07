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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
    }
    
    func setTitlelabel(title: String) {
        titleLabel.text = title
    }
    
    private func setNavigationBar() {
        navigationItem.title = "광고 화면"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(self.dismiss)
        )
    }
    
    private func setTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }
    
    @objc
    private func dismiss(_ viewController: AdViewController) {
        dismiss(animated: true)
    }
}
