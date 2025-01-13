//
//  MovieCollectionViewCell.swift
//  SnapKitPractice
//
//  Created by 김도형 on 1/13/25.
//

import UIKit

import SnapKit

class MovieTableViewCell: UITableViewCell {
    private let numberLabel = UILabel()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    
    private var movie: Movie?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(movie: Movie) {
        self.movie = movie
        
        backgroundColor = .clear
        
        configureNumberLabel()
        
        configureTitleLabel()
        
        configureDateLabel()
    }
}

private extension MovieTableViewCell {
    func configureNumberLabel() {
        contentView.addSubview(numberLabel)
        numberLabel.text = "\(movie?.number ?? 0)"
        numberLabel.font = .systemFont(ofSize: 16, weight: .bold)
        numberLabel.textColor = .black
        numberLabel.backgroundColor = .white
        numberLabel.textAlignment = .center
        numberLabel.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
            make.verticalEdges.equalTo(safeAreaLayoutGuide).inset(8)
        }
    }
    
    func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.text = movie?.title
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(numberLabel.snp.trailing).offset(8)
            make.centerY.equalTo(numberLabel.snp.centerY)
        }
    }
    
    func configureDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.text = movie?.date
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = .white
        dateLabel.textAlignment = .right
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(numberLabel.snp.centerY)
        }
    }
}

extension String {
    static let movieTableCell = "MovieCollectionViewCell"
}
