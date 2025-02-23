//
//  SelectionViewController.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/23/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SelectionViewController: UIViewController {
    private lazy var collectionView = { configureCollectionView() }()
    private let dimmedView = UIView()
    private var tamagotchiAlert: TamagotchiAlert?
    
    private let viewModel = SelectionViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
        
        bindState()
        
        bindAction()
    }
}

// MARK: Configure Views
private extension SelectionViewController {
    func configureUI() {
        view.backgroundColor = .tgBackground
        
        navigationItem.title = "다마고치 선택하기"
        
        configureDimmedView()
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 16
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        let width = (view.frame.width - (4 * spacing)) / 3
        layout.itemSize = CGSize(width: width, height: width + 50)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            TamagotchiCollectionViewCell.self,
            forCellWithReuseIdentifier: .tamagotchiCollectionCell
        )
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        return collectionView
    }
    
    func configureDimmedView() {
        dimmedView.backgroundColor = .black.withAlphaComponent(0.3)
        dimmedView.isHidden = true
        dimmedView.alpha = 0
        view.insertSubview(dimmedView, aboveSubview: collectionView)
    }
}

// MARK: Bindings
private extension SelectionViewController {
    typealias Action = SelectionViewModel.Action
    
    func bindAction() {
        collectionView.rx.modelSelected(Tamagotchi.self)
            .map { Action.collectionViewModelSelected($0) }
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        bindTamagotchiList()
        
        bindSelectedTamagotchi()
    }
    
    func bindTamagotchiList() {
        viewModel.observableState
            .map(\.tamagotchiList)
            .distinctUntilChanged()
            .drive(collectionView.rx.items(
                cellIdentifier: .tamagotchiCollectionCell,
                cellType: TamagotchiCollectionViewCell.self
            )) { item, element, cell in
                cell.forItemAt(element)
            }
            .disposed(by: disposeBag)
    }
    
    func bindSelectedTamagotchi() {
        viewModel.observableState
            .map(\.selectedTamagotchi)
            .distinctUntilChanged()
            .drive(with: self) { this, tamagotchi in
                guard tamagotchi != .준비중 else { return }
                if let tamagotchi {
                    this.presentTamagotchiAlert(tamagotchi)
                } else {
                    this.dismissTamagotchiAlert()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func presentTamagotchiAlert(_ tamagotchi: Tamagotchi) {
        dimmedView.isHidden = false
        dimmedView.alpha = 1
        let alert = TamagotchiAlert(tamagotchi: tamagotchi)
        Observable.merge(
            alert.cancelButton.rx.tap
                .map { Action.tamagotchiAlertCancelButtonTapped },
            alert.startButton.rx.tap
                .map { Action.tamagotchiAlertStartButtonTapped }
        )
        .bind(to: viewModel.send)
        .disposed(by: disposeBag)
        tamagotchiAlert = alert
        
        view.insertSubview(alert, aboveSubview: dimmedView)
        tamagotchiAlert?.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    func dismissTamagotchiAlert() {
        tamagotchiAlert?.removeFromSuperview()
        dimmedView.isHidden = true
        dimmedView.alpha = 0
    }
}

fileprivate extension String {
    static let tamagotchiCollectionCell = "tamagotchiCollectionViewCell"
}

#Preview {
    UINavigationController(rootViewController: SelectionViewController())
}
