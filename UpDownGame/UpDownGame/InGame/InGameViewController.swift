//
//  InGameViewController.swift
//  UpDownGame
//
//  Created by 김도형 on 1/9/25.
//

import UIKit

class InGameViewController: UIViewController {
    @IBOutlet var resultButton: UIButton!
    @IBOutlet var inGameCollectionView: UICollectionView!
    @IBOutlet var tryCountLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    
    private var numbers: [Int] = Array(1...30)
    private var tryCount: Int = 0
    private var selectedNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .accent
        
        configureResultLabel()
        
        configureTryCountLabel()
        
        configureResultButton()
        
        configureInGameCollectionView()
        
        configureInGameCollectionViewLayout()
    }
}

// MARK: View {
private extension InGameViewController {
    func configureResultLabel() {
        resultLabel.text = "UP DOWN"
        resultLabel.font = .udLargeTitle
        resultLabel.textAlignment = .center
    }
    
    func configureTryCountLabel() {
        tryCountLabel.text = "시도 횟수: \(tryCount)"
        tryCountLabel.font = .udTitle
        tryCountLabel.textAlignment = .center
    }
    
    func configureResultButton() {
        resultButton.setUDButtonStyle(title: "결과 확인하기")
    }
    
    func configureInGameCollectionView() {
        inGameCollectionView.delegate = self
        inGameCollectionView.dataSource = self
        inGameCollectionView.backgroundColor = .clear
        
        inGameCollectionView.register(
            UINib(nibName: .inGameCollectionCell, bundle: nil),
            forCellWithReuseIdentifier: .inGameCollectionCell
        )
    }
    
    func configureInGameCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        
        let localHeight = inGameCollectionView.frame.width
        let spacing: CGFloat = 8
        let cellWidth = (localHeight - (spacing * 6)) / 5
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.sectionInset = UIEdgeInsets(
            top: spacing,
            left: spacing,
            bottom: spacing,
            right: spacing
        )
        inGameCollectionView.collectionViewLayout = layout
    }
}

// MARK: CollectionView DataSource
extension InGameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: .inGameCollectionCell,
            for: indexPath
        )
        guard let inGameCell = cell as? InGameCollectionViewCell else {
            return cell
        }
        inGameCell.setNumber(numbers[indexPath.item])
        return inGameCell
    }
}

// MARK: CollectionView Delegate
extension InGameViewController: UICollectionViewDelegate {
    
}

private extension InGameViewController {
    enum GameState {
        case up
        case down
        case good
        
        var result: String {
            switch self {
            case .up: return "UP"
            case .down: return "DOWN"
            case .good: return "GOOD!"
            }
        }
    }
}

extension String {
    static let inGameViewController = "InGameViewController"
}
