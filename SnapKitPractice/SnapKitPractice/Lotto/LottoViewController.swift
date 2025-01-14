//
//  LottoViewController.swift
//  SnapKitPractice
//
//  Created by 김도형 on 1/14/25.
//

import UIKit

import SnapKit
import Alamofire

class LottoViewController: UIViewController {
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
    
    private var lotto: Lotto? {
        didSet { didSetLotto() }
    }
    private var drwNos: [String] {
        return [
            "\(lotto?.drwtNo1 ?? 0)",
            "\(lotto?.drwtNo2 ?? 0)",
            "\(lotto?.drwtNo3 ?? 0)",
            "\(lotto?.drwtNo4 ?? 0)",
            "\(lotto?.drwtNo5 ?? 0)",
            "\(lotto?.drwtNo6 ?? 0)",
            "+",
            "\(lotto?.bnusNo ?? 0)"
        ]
    }
    private var lotteryDay: Int? {
        let firstLottery = "2002-12-07"
        let strategy = Date.ParseStrategy(
            format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)",
            timeZone: .autoupdatingCurrent
        )
        guard
            let date = try? Date(firstLottery, strategy: strategy)
        else { return nil }
        
        let count = Calendar
            .current
            .dateComponents(
                [.weekdayOrdinal],
                from: date,
                to: .now
            )
            .weekdayOrdinal
        return count
    }
    private var lotteryRange = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let lotteryDay else { return }
        
        lotteryRange = Array(1...lotteryDay).reversed().map { String($0) }
        
        configureUI()
        
        configureLayout()
        
        fetchLotto(no: "\(lotteryDay)")
    }
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` else { return }
            
            for cell in drwNoList {
                let height = cell.frame.height
                cell.layer.cornerRadius = height / 2
                cell.clipsToBounds = true
            }
        }
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
        
        drwNoTextField.text = "\(lotteryDay ?? 0)"
        drwNoTextField.borderStyle = .none
        drwNoTextField.textAlignment = .center
        drwNoTextField.font = .systemFont(ofSize: 24)
        drwNoTextField.inputView = drwNoPicker
        
        drwNoPicker.delegate = self
        drwNoPicker.dataSource = self
        
        view.addSubview(drwNoInfoLabel)
        drwNoInfoLabel.text = "당첨번호 안내"
        drwNoInfoLabel.font = .systemFont(ofSize: 16)
        
        view.addSubview(drwNoDateLabel)
        drwNoDateLabel.text = "\(lotto?.drwNoDate ?? "") 추첨"
        drwNoDateLabel.font = .systemFont(ofSize: 12)
        drwNoDateLabel.textColor = .secondaryLabel
        
        view.addSubview(separatorView)
        separatorView.backgroundColor = .separator
        
        view.addSubview(drwNoLabel)
        drwNoLabel.font = .systemFont(ofSize: 28)
        updateDRWNoLabelAttributedText()
        
        view.addSubview(drwNoHStack)
        drwNoHStack.axis = .horizontal
        drwNoHStack.distribution = .fillEqually
        drwNoHStack.spacing = 4
        
        view.addSubview(bonusLabel)
        bonusLabel.text = "보너스"
        bonusLabel.textColor = .systemGray
        bonusLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        for no in drwNos {
            let drwNoCell = DRWNoCell()
            drwNoHStack.addArrangedSubview(drwNoCell)
            drwNoList.append(drwNoCell)
            drwNoCell.configureUI(no)
        }
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
        
        for cell in drwNoList {
            cell.configureLayout()
            if drwNoList.last == cell {
                bonusLabel.snp.makeConstraints { make in
                    make.top.equalTo(cell.snp.bottom).offset(4)
                    make.centerX.equalTo(cell)
                }
            }
        }
    }
    
    func updateDRWNoLabelAttributedText() {
        let attributedString = NSMutableAttributedString(
            string: "\(lotto?.drwNo ?? 0)회 당첨결과"
        )
        let range = attributedString.mutableString.range(
            of: "\(lotto?.drwNo ?? 0)회"
        )
        attributedString.addAttributes(
            [.foregroundColor: UIColor.systemYellow,
             .font: UIFont.systemFont(ofSize: 28, weight: .bold)],
            range: range
        )
        drwNoLabel.attributedText = attributedString
    }
}

// MARK: Data Bindings
private extension LottoViewController {
    func didSetLotto() {
        updateDRWNoLabelAttributedText()
        
        drwNoDateLabel.text = "\(lotto?.drwNoDate ?? "") 추첨"
        
        for cell in drwNoList {
            drwNoHStack.removeArrangedSubview(cell)
        }
        drwNoList.removeAll()
        
        for no in drwNos {
            let drwNoCell = DRWNoCell()
            drwNoHStack.addArrangedSubview(drwNoCell)
            drwNoList.append(drwNoCell)
            drwNoCell.configureUI(no)
        }
        
        for cell in drwNoList {
            cell.configureLayout()
            if drwNoList.last == cell {
                bonusLabel.snp.makeConstraints { make in
                    make.top.equalTo(cell.snp.bottom).offset(4)
                    make.centerX.equalTo(cell)
                }
            }
        }
    }
}

// MARK: Functions
private extension LottoViewController {
    func fetchLotto(no: String) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(no)"
        AF
            .request(url)
            .responseDecodable(of: Lotto.self) { [weak self] response in
                guard let `self` else { return }
                
                switch response.result {
                case .success(let data):
                    self.lotto = data
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension LottoViewController {
    class DRWNoCell: UIView {
        private let label = UILabel()
        private let bonusLabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
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

extension LottoViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lotteryRange.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        drwNoTextField.text = lotteryRange[row]
        fetchLotto(no: lotteryRange[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lotteryRange[row]
    }
}

#Preview {
    LottoViewController()
}
