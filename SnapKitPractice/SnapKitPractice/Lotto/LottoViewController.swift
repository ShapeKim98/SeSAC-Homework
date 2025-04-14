//
//  LottoViewController.swift
//  SnapKitPractice
//
//  Created by 김도형 on 1/14/25.
//

import UIKit

import SnapKit
import Alamofire
import RxSwift
import RxCocoa
import RxCompose

class LottoViewController: UIViewController, Composable {
    private let drwNoTextField = UITextField()
    private let drwNoTextFieldContainer = UIView()
    private let drwNoPicker = UIPickerView()
    private let drwNoInfoLabel = UILabel()
    private let drwNoDateLabel = UILabel()
    private let drwNoLabel = UILabel()
    private let separatorView = UIView()
    private let drwNoHStack = UIStackView()
    private var drwNoList = [DRWNoCell]()
    private let bonusLabel = UILabel()
    private let observableButton = UIButton()
    private let singleButton = UIButton()
    
    @Compose
    var composer = LottoViewModel()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
        
        bindState()
        
        bindAction()
         
        $composer.send(.viewDidLoad)
    }
}

// MARK: Configure View
private extension LottoViewController {
    func configureUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(drwNoTextFieldContainer)
        drwNoTextFieldContainer.addSubview(drwNoTextField)
        drwNoTextFieldContainer.border(radius: 4, color: .separator, width: 1)
        drwNoTextFieldContainer.addSubview(drwNoTextField)
        
        drwNoTextField.borderStyle = .none
        drwNoTextField.textAlignment = .center
        drwNoTextField.font = .systemFont(ofSize: 24)
        drwNoTextField.inputView = drwNoPicker
        
        view.addSubview(drwNoInfoLabel)
        drwNoInfoLabel.text = "당첨번호 안내"
        drwNoInfoLabel.font = .systemFont(ofSize: 16)
        
        view.addSubview(drwNoDateLabel)
        drwNoDateLabel.font = .systemFont(ofSize: 12)
        drwNoDateLabel.textColor = .secondaryLabel
        
        view.addSubview(separatorView)
        separatorView.backgroundColor = .separator
        
        view.addSubview(drwNoLabel)
        drwNoLabel.font = .systemFont(ofSize: 28)
        
        view.addSubview(drwNoHStack)
        drwNoHStack.axis = .horizontal
        drwNoHStack.distribution = .fillEqually
        drwNoHStack.spacing = 4
        
        view.addSubview(bonusLabel)
        bonusLabel.text = "보너스"
        bonusLabel.textColor = .systemGray
        bonusLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        observableButton.setTitle("Observable", for: .normal)
        observableButton.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(observableButton)
        
        singleButton.setTitle("Single", for: .normal)
        singleButton.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(singleButton)
    }
    
    func configureLayout() {
        drwNoTextFieldContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        drwNoTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        drwNoInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(drwNoTextFieldContainer.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        drwNoDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(drwNoInfoLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview().inset(16)
            make.top.equalTo(drwNoInfoLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        drwNoLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        drwNoHStack.snp.makeConstraints { make in
            make.top.equalTo(drwNoLabel.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        observableButton.snp.makeConstraints { make in
            make.top.equalTo(drwNoHStack.snp.bottom).offset(40)
            make.trailing.equalTo(view.snp.centerX).offset(-40)
        }
        
        singleButton.snp.makeConstraints { make in
            make.top.equalTo(drwNoHStack.snp.bottom).offset(40)
            make.leading.equalTo(view.snp.centerX).offset(40)
        }
    }
}

// MARK: Data Bindings
private extension LottoViewController {
    func bindAction() {
        drwNoPicker.rx.itemSelected
            .map { Action.drwNoPickImteSelected($0.row) }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
        
        observableButton.rx.tap
            .map { Action.observableButtonTapped }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
        
        singleButton.rx.tap
            .map { Action.singleButtonTapped }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        bindLotto()
        
        bindLotteryDay()
        
        bindDrwNos()
        
        bindLotteryRange()
        
        bindSelectedDate()
        
        bindErrorMessage()
    }
    
    func bindLotto() {
        let lotto = composer.$state.observable
            .compactMap(\.lotto)
        
        lotto.map(\.drwNoDate)
            .map { "\($0) 추첨" }
            .drive(drwNoDateLabel.rx.text)
            .disposed(by: disposeBag)
        lotto.map(\.drwNo)
            .map { drwNo in
                let attributedString = NSMutableAttributedString(
                    string: "\(drwNo)회 당첨결과"
                ).addAttributes([
                    .foregroundColor: UIColor.systemYellow,
                    .font: UIFont.systemFont(ofSize: 28, weight: .bold)
                ], at: "\(drwNo)회")
                return attributedString
            }
            .drive(drwNoLabel.rx.attributedText)
            .disposed(by: disposeBag)
    }
    
    func bindLotteryDay() {
        composer.$state.observable
            .compactMap(\.lotteryDay)
            .map { String($0) }
            .drive(drwNoTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindDrwNos() {
        composer.$state.observable
            .map(\.drwNos)
            .drive(with: self) { this, drwNos in
                for cell in this.drwNoList {
                    this.drwNoHStack.removeArrangedSubview(cell)
                }
                this.drwNoList.removeAll()
                
                for no in drwNos {
                    let drwNoCell = DRWNoCell()
                    this.drwNoHStack.addArrangedSubview(drwNoCell)
                    this.drwNoList.append(drwNoCell)
                    drwNoCell.configureUI(no)
                }
                
                for cell in this.drwNoList {
                    cell.configureLayout()
                    if this.drwNoList.last == cell {
                        this.bonusLabel.snp.makeConstraints { make in
                            make.top.equalTo(cell.snp.bottom).offset(4)
                            make.centerX.equalTo(cell)
                        }
                    }
                    cell.layoutIfNeeded()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindLotteryRange() {
        composer.$state.observable
            .map(\.lotteryRange)
            .drive(drwNoPicker.rx.itemTitles) { _, item in item }
            .disposed(by: disposeBag)
    }
    
    func bindSelectedDate() {
        composer.$state.observable
            .map(\.currentDrwNo)
            .drive(drwNoTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindErrorMessage() {
        composer.$state.observable
            .compactMap(\.errorMessage)
            .drive(with: self) { this, message in
                let alert = UIAlertController(
                    title: "오류",
                    message: message,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(
                    title: "확인",
                    style: .default,
                    handler: { _ in
                        this.$composer.send(.alertConfirmTapped)
                    }
                ))
                this.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension LottoViewController {
    class DRWNoCell: UIView {
        private let label = UILabel()
        private let bonusLabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        override func layoutIfNeeded() {
            super.layoutIfNeeded()
            
            let height = frame.height
            layer.cornerRadius = height / 2
            clipsToBounds = true
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configureUI(_ no: String) {
            if let no = Int(no) {
                switch no {
                case 1...10:
                    self.backgroundColor = .systemYellow
                case 11...20:
                    self.backgroundColor = .systemBlue
                case 21...30:
                    self.backgroundColor = .systemRed
                case 31...40:
                    self.backgroundColor = .systemGray
                case 41...45:
                    self.backgroundColor = .systemGreen
                default: break
                }
            } else {
                self.backgroundColor = .clear
            }
            
            self.addSubview(label)
            label.text = no
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            label.textColor = Int(no) == nil ? .black : .white
        }
        
        func configureLayout() {
            self.snp.makeConstraints { make in
                make.height.equalTo(self.snp.width)
            }
            
            label.snp.makeConstraints { make in
                make.edges.equalTo(self).inset(8)
            }
        }
    }
}

#Preview {
    LottoViewController()
}
