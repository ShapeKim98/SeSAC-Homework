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

protocol SelectionViewControllerDelegate: AnyObject {
    func tamagotchiAlertStartButtonTapped()
}

final class SelectionViewController: UIViewController {
    private lazy var collectionView = { configureCollectionView() }()
    private let dimmedView = UIView()
    private var tamagotchiAlert: TamagotchiAlert?
    
    private let viewModel = SelectionViewModel()
    private let disposeBag = DisposeBag()
    
    weak var delegate: SelectionViewControllerDelegate?
    
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
        dimmedView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(dimmedViewTapped)
        ))
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
            .debug()
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
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.dimmedView.alpha = 1
            self?.dimmedView.isHidden = false
        }
        
        let alert = TamagotchiAlert(tamagotchi: tamagotchi)
        let startButtonObservable = alert.startButton.rx.tap.share()
        Observable.merge(
            alert.cancelButton.rx.tap
                .map { Action.tamagotchiAlertCancelButtonTapped },
            startButtonObservable
                .map { Action.tamagotchiAlertStartButtonTapped }
        )
        .bind(to: viewModel.send)
        .disposed(by: disposeBag)
        startButtonObservable
            .bind(with: self) { this, _ in
                if let delegate = this.delegate {
                    delegate.tamagotchiAlertStartButtonTapped()
                } else {
                    this.navigationController?.popToRootViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        tamagotchiAlert = alert
        alert.alpha = 0
        view.insertSubview(alert, aboveSubview: dimmedView)
        
        tamagotchiAlert?.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        alert.transform = CGAffineTransform(translationX: 0, y: 50)
        
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: [.curveEaseOut]
        ) {
            alert.alpha = 1
            alert.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    func dismissTamagotchiAlert() {
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: [.curveEaseOut]
        ) { [weak self] in
            self?.tamagotchiAlert?.alpha = 0
            self?.tamagotchiAlert?.transform = CGAffineTransform(translationX: 0, y: 50)
        } completion: { [weak self] _ in
            self?.tamagotchiAlert = nil
            self?.tamagotchiAlert?.removeFromSuperview()
        }
        
        UIView.animate(withDuration: 0.7) { [weak self] in
            self?.dimmedView.alpha = 0
        } completion: { [weak self] _ in
            self?.dimmedView.isHidden = true
        }
        
    }
}

// MARK: Functions
private extension SelectionViewController {
    @objc
    func dimmedViewTapped() {
        viewModel.send.accept(.dimmedViewTapped)
    }
}

fileprivate extension String {
    static let tamagotchiCollectionCell = "tamagotchiCollectionViewCell"
}

#Preview {
    UINavigationController(rootViewController: SelectionViewController())
}
