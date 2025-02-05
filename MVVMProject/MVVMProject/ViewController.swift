//
//  ViewController.swift
//  MVVMProject
//
//  Created by 김도형 on 2/5/25.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureTabBarController()
        
        configureTabBarAppearance()
    }
    
    private func configureTabBarController() {
        let currencyViewController = UINavigationController(rootViewController: CurrencyViewController())
        currencyViewController.tabBarItem.title = "환전"
        currencyViewController.tabBarItem.image = UIImage(systemName: "dollarsign")
        
        let wordCounterViewController = UINavigationController(rootViewController: WordCounterViewController())
        wordCounterViewController.tabBarItem.title = "검색"
        wordCounterViewController.tabBarItem.image = UIImage(systemName: "pencil")
        
        let userViewController = UINavigationController(rootViewController: UserViewController())
        userViewController.tabBarItem.title = "검색"
        userViewController.tabBarItem.image = UIImage(systemName: "person")
        
        setViewControllers(
            [currencyViewController, wordCounterViewController, userViewController],
            animated: true
        )
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .black
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

