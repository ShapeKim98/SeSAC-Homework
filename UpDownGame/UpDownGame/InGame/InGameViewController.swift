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
    
    private var gameState: GameState? {
        didSet { didSetGameState() }
    }
    private var result = (1...30).randomElement()!
    private var numbers: [Int] = Array(1...30)
    private var tryCount: Int = 0 {
        didSet { tryCountLabel.text = "시도 횟수: \(tryCount)" }
    }
    private var selectedNumber: Int? {
        didSet { didSetSelectedNumber() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .accent
        
        configureResultLabel()
        
        configureTryCountLabel()
        
        configureResultButton()
        
        configureInGameCollectionView()
        
        configureInGameCollectionViewLayout()
    }
    
    @IBAction func resultButtonTouchUpInside(_ sender: UIButton) {
        guard gameState != .good else {
            dismiss(animated: true)
            return
        }
        
        guard let selectedNumber else { return }
        self.selectedNumber = nil
        tryCount += 1
        guard selectedNumber != result else {
            gameState = .good
            return
        }
        if result > selectedNumber {
            gameState = .up
            numbers = numbers.filter { selectedNumber < $0 }
            inGameCollectionView.reloadData()
            return
        }
        
        if result < selectedNumber {
            gameState = .down
            numbers = numbers.filter { selectedNumber > $0 }
            inGameCollectionView.reloadData()
            return
        }
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
        disableResultButton()
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
    
    func disableResultButton() {
        resultButton.isEnabled = false
        resultButton.backgroundColor = .lightGray
        resultButton.setTitleColor(.white, for: .normal)
    }
    
    func enableResultButton() {
        resultButton.isEnabled = true
        resultButton.backgroundColor = .black
        resultButton.setTitleColor(.white, for: .normal)
    }
}

// MARK: Functions
private extension InGameViewController {
    func didSetGameState() {
        guard let gameState else { return }
        resultLabel.text = gameState.result
        enableResultButton()
        if gameState == .good {
            resultButton.setTitle("다시 하기", for: .normal)
        }
    }
    
    func didSetSelectedNumber() {
        if selectedNumber != nil {
            enableResultButton()
        } else {
            disableResultButton()
        }
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
        guard let selectedNumber else {
            return inGameCell
        }
        inGameCell.didSelected(String(selectedNumber))
        return inGameCell
    }
}

// MARK: CollectionView Delegate
extension InGameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        guard let inGameCell = cell as? InGameCollectionViewCell else {
            return
        }
        selectedNumber = inGameCell.onSelect()
        inGameCollectionView.reloadData()
    }
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
