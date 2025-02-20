//
//  DetailViewController.swift
//  RXSampleProject
//
//  Created by 김도형 on 2/19/25.
//

import UIKit

class DetailViewController: UIViewController {
    private let name: String
    
    init(name: String) {
        self.name = name
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = name
    }
}
