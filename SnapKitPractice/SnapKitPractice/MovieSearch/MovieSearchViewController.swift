//
//  MovieSearchViewController.swift
//  SnapKitPractice
//
//  Created by 김도형 on 1/13/25.
//

import UIKit

import SnapKit

class MovieSearchViewController: UIViewController {
    private let tableView = UITableView()
    private let searchTextField = UITextField()
    private let searchButton = UIButton()
    
    private let movieList = Movie.mock
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        configureSearchTextField()
        
        configureSearchButton()
        
        configureCollectionView()
    }
}

private extension MovieSearchViewController {
    func configureCollectionView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        
        tableView.register(
            MovieTableViewCell.self,
            forCellReuseIdentifier: .movieTableCell
        )
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureSearchTextField() {
        view.addSubview(searchTextField)
        searchTextField.borderStyle = .none
        searchTextField.backgroundColor = .clear
        searchTextField.textColor = .white
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        let border = UIView()
        searchTextField.addSubview(border)
        border.backgroundColor = .white
        border.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalTo(searchTextField.snp.width)
            make.top.equalTo(searchTextField.snp.bottom)
        }
        
    }
    
    func configureSearchButton() {
        view.addSubview(searchButton)
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.black, for: .normal)
        searchButton.backgroundColor = .white
        searchButton.titleLabel?.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        searchButton.snp.makeConstraints { make in
            make.leading.equalTo(searchTextField.snp.trailing).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(searchTextField.snp.centerY)
        }
    }
}

extension MovieSearchViewController: UITableViewDelegate,
                                     UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: .movieTableCell,
            for: indexPath
        )
        guard let movieCell = cell as? MovieTableViewCell else { return cell }
        let movie = movieList[indexPath.row]
        movieCell.configure(movie: movie)
        return movieCell
    }
}

#Preview {
    MovieSearchViewController()
}
