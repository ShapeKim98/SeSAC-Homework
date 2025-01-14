//
//  NaverPayViewController.swift
//  SnapKitPractice
//
//  Created by 김도형 on 1/13/25.
//

import UIKit

import SnapKit

class NaverPayViewController: UIViewController {
    private let memberShipButton = UIButton()
    private let paymentButton = UIButton()
    private let couponButton = UIButton()
    private let closeButton = UIButton()
    private let confirmButton = UIButton()
    private let countryButton = UIButton()
    private let directPaymentButton = UIButton()
    private let hstack = UIStackView()
    private let paymentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        configureHStack()
        
        configureHStackButton(
            memberShipButton,
            title: "멤버쉽",
            isSelected: false
        )
        memberShipButton.snp.makeConstraints { make in
            make.leading.equalTo(hstack).inset(12)
        }
        
        configureHStackButton(
            paymentButton,
            title: "현장결제",
            isSelected: true
        )
        
        configureHStackButton(
            couponButton,
            title: "쿠폰",
            isSelected: false
        )
        couponButton.snp.makeConstraints { make in
            make.trailing.equalTo(hstack).inset(12)
        }
        
        configurePaymentView()
    }
    
    override func viewDidLayoutSubviews() {
        let height = hstack.frame.height
        hstack.layer.cornerRadius = height / 2
        hstack.clipsToBounds = true
    }
}

private extension NaverPayViewController {
    func configureHStack() {
        view.addSubview(hstack)
        hstack.axis = .horizontal
        hstack.distribution = .fillEqually
        hstack.alignment = .center
        hstack.spacing = 8
        hstack.backgroundColor = .black
        hstack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configureHStackButton(_ button: UIButton, title: String, isSelected: Bool) {
        hstack.addArrangedSubview(button)
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.configuration = UIButton.Configuration.filled()
        button.configuration?.cornerStyle = .capsule
        button.configuration?.attributedTitle = AttributedString(
            NSAttributedString(
                string: title,
                attributes: [.font: UIFont.boldSystemFont(ofSize: 14)]
            )
        )
        button.tintColor = isSelected
        ? UIColor(named: "NaverPayButtonColor")
        : .clear
        
        let label = button.titleLabel
        label?.textAlignment = .center
        label?.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.verticalEdges.equalTo(button).inset(2)
        }
        
        button.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
        }
    }
    
    func configurePaymentView() {
        view.addSubview(paymentView)
        paymentView.backgroundColor = .white
        paymentView.layer.cornerRadius = 16
        
        paymentView.snp.makeConstraints { make in
            make.top.equalTo(hstack.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(paymentView.snp.width).multipliedBy(1.3)
        }
        
        let nImageView = configureNImageView()
        
        let payLabel = configurePayLabel(nImageView: nImageView)
        
        configureCountryButton(payLabel: payLabel)
        
        configureCloseButton()
        
        let lockImageView = configureLockImageView()
        
        configurePaymentLabel(lockImageView: lockImageView)
        
        configureConfirmButton()
        
        configureDirectPaymentButton()
    }
    
    func configureNImageView() -> UIImageView {
        let nImageView = UIImageView(image: UIImage(systemName: "n.circle.fill"))
        paymentView.addSubview(nImageView)
        nImageView.tintColor = .black
        nImageView.preferredSymbolConfiguration = .init(pointSize: 24)
        nImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        return nImageView
    }
    
    func configurePayLabel(nImageView: UIImageView) -> UILabel {
        let payLabel = UILabel()
        paymentView.addSubview(payLabel)
        payLabel.text = "pay"
        payLabel.textColor = .black
        payLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        payLabel.snp.makeConstraints { make in
            make.leading.equalTo(nImageView.snp.trailing).offset(4)
            make.centerY.equalTo(nImageView.snp.centerY)
        }
        return payLabel
    }
    
    func configureCountryButton(payLabel: UILabel) {
        paymentView.addSubview(countryButton)
        countryButton.setTitle("국내", for: .normal)
        countryButton.setTitleColor(.secondaryLabel, for: .normal)
        countryButton.setImage(
            UIImage(systemName: "arrowtriangle.down.fill"),
            for: .normal
        )
        countryButton.configuration = .plain()
        countryButton.configuration?.imagePlacement = .trailing
        couponButton.configuration?.preferredSymbolConfigurationForImage = .init(scale: .small)
        countryButton.tintColor = .secondaryLabel
        countryButton.snp.makeConstraints { make in
            make.leading.equalTo(payLabel.snp.trailing).offset(4)
            make.centerY.equalTo(payLabel.snp.centerY)
        }
    }
    
    func configureCloseButton() {
        paymentView.addSubview(closeButton)
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(
            UIImage(systemName: "xmark"),
            for: .normal
        )
        closeButton.configuration = .plain()
        closeButton.tintColor = .black
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configureLockImageView() -> UIImageView {
        let lockImageView = UIImageView(image: UIImage(systemName: "lock.open.fill"))
        paymentView.addSubview(lockImageView)
        lockImageView.tintColor = UIColor(named: "NaverColor")
        lockImageView.snp.makeConstraints { make in
            make.width.height.equalTo(140)
            make.top.equalTo(closeButton.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        return lockImageView
    }
    
    func configurePaymentLabel(lockImageView: UIImageView) {
        let paymentLabel = UILabel()
        paymentView.addSubview(paymentLabel)
        paymentLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        paymentLabel.textAlignment = .center
        paymentLabel.text = "한 번만 인증하고\n비밀번호 없이 결제하세요"
        paymentLabel.numberOfLines = 0
        paymentLabel.snp.makeConstraints { make in
            make.top.equalTo(lockImageView.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureConfirmButton() {
        paymentView.addSubview(confirmButton)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.configuration = .filled()
        confirmButton.configuration?.cornerStyle = .capsule
        confirmButton.configuration?.baseBackgroundColor = UIColor(named: "NaverColor")
        confirmButton.configuration?.contentInsets = .init(
            top: 16, leading: 0, bottom: 16, trailing: 0
        )
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configureDirectPaymentButton() {
        paymentView.addSubview(directPaymentButton)
        directPaymentButton.setTitle("바로결제 사용하기", for: .normal)
        directPaymentButton.setTitleColor(.label, for: .normal)
        directPaymentButton.setImage(
            UIImage(systemName: "checkmark.circle.fill"),
            for: .normal
        )
        directPaymentButton.tintColor = UIColor(named: "NaverColor")
        directPaymentButton.configuration = .plain()
        directPaymentButton.configuration?.imagePlacement = .leading
        directPaymentButton.configuration?.imagePadding = 8
        directPaymentButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top).offset(-32)
        }
    }
}

#Preview {
    NaverPayViewController()
}
