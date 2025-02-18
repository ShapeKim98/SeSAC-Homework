//
//  SimpleTableViewController.swift
//  RXSampleProject
//
//  Created by 김도형 on 2/18/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SimpleTableViewController: UIViewController {
    private let simpleTableView = UITableView()
    
    private let dataSource = Observable.just(Array(1...100))
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(simpleTableView)
        simpleTableView.register(
            SimpleTableViewCell.self,
            forCellReuseIdentifier: .simpleTableCell
        )
        
        simpleTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bind()
    }
    
    private func bind() {
        dataSource
            .bind(to: simpleTableView.rx.items(
                cellIdentifier: .simpleTableCell,
                cellType: SimpleTableViewCell.self
            )) { _, model, cell in
                cell.accessoryType = .detailButton
                cell.forRowAt("\(model) - label")
            }
            .disposed(by: disposeBag)
        
        Observable.zip(
            simpleTableView.rx.itemSelected,
            simpleTableView.rx.modelSelected(Int.self)
        )
        .map { ($0.0, "Tapped `\($0.1)`") }
        .bind(with: self) { this, value in
            let (indexPath, message) = value
            this.presentAlert(message)
            this.simpleTableView.deselectRow(at: indexPath, animated: true)
        }
        .disposed(by: disposeBag)
        
        simpleTableView.rx.itemAccessoryButtonTapped
            .map { "Tapped Detail @ \($0.section),\($0.row)" }
            .bind(with: self) { this, message in
                this.presentAlert(message)
            }
            .disposed(by: disposeBag)
    }
    
    private func presentAlert(_ title: String) {
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}

fileprivate extension String {
    static let simpleTableCell = "SimpleTableViewCell"
}

#Preview {
    SimpleTableViewController()
}
