//
//  SettingViewController.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/23/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SettingViewController: UIViewController {
    private let tableView = UITableView()
    
    private let viewModel = SettingViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
        
        bindState()
        
        bindAction()
        
        viewModel.send.accept(.viewDidLoad)
    }
}

// MARK: Configure Views
private extension SettingViewController {
    func configureUI() {
        view.backgroundColor = .tgBackground
        
        configureTableView()
    }
    
    func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureTableView() {
        tableView.separatorInset = .zero
        tableView.separatorColor = .accent
        tableView.register(
            SettingTableViewCell.self,
            forCellReuseIdentifier: .settingTableCell
        )
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
    }
}

// MARK: Bindings
private extension SettingViewController {
    typealias Action = SettingViewModel.Action
    
    func bindAction() {
        let modelSelected = tableView.rx.modelSelected(
            SettingViewModel.SettingItem.self
        ).share()
        modelSelected
            .compactMap { $0.type == .nameEdit ? $0 : nil }
            .bind(with: self) { this, _ in
                this.nameEditButtonTapped()
            }
            .disposed(by: disposeBag)
        modelSelected
            .compactMap { $0.type == .tamagotchiEdit ? $0 : nil }
            .bind(with: self) { this, _ in
                this.tamagotchiEditButtonTapped()
            }
            .disposed(by: disposeBag)
        modelSelected
            .compactMap { $0.type == .reset ? $0 : nil }
            .bind(with: self) { this, _ in
                this.presentAlert()
            }
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        bindSettingItems()
    }
    
    func bindSettingItems() {
        viewModel.observableState
            .map { $0.settingItems }
            .distinctUntilChanged()
            .drive(tableView.rx.items(
                cellIdentifier: .settingTableCell,
                cellType: SettingTableViewCell.self
            )) { row, item, cell in
                cell.forRowAt(item)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Functions
private extension SettingViewController {
    func nameEditButtonTapped() {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "NicknameViewController")
        
        navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }
    
    func tamagotchiEditButtonTapped() {
        navigationController?.pushViewController(
            SelectionViewController(),
            animated: true
        )
    }
    
    func presentAlert() {
        let alert = UIAlertController(
            title: "데이터 초기화",
            message: "정말 처음부터 다시 시작하실 건가용?",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(
            title: "아냐!",
            style: .cancel
        )
        alert.addAction(cancel)
        let confirm = UIAlertAction(
            title: "웅",
            style: .default
        ) { [weak self] _ in
            self?.viewModel.send.accept(.alertConfirmButtonTapped)
        }
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}

fileprivate extension String {
    static let settingTableCell = "SettingTableViewCell"
}
