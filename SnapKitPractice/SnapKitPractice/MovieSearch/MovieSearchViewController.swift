//
//  MovieSearchViewController.swift
//  SnapKitPractice
//
//  Created by 김도형 on 1/13/25.
//

import UIKit

import SnapKit
import Alamofire

class MovieSearchViewController: UIViewController {
    private let tableView = UITableView()
    private let searchTextField = UITextField()
    private let searchButton = UIButton()
    
    private var boxOffice: [BoxOffice] = [] {
        didSet { tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        configureSearchTextField()
        
        configureSearchButton()
        
        configureCollectionView()
        
        fetchBoxOffice()
    }
}

// MARK: Configure Views
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

// MARK: Functions
private extension MovieSearchViewController {
    func fetchBoxOffice() {
        let apiKey = Bundle.main.kobisApiKey
        let date = "20241225"
        
        let url = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(apiKey)&targetDt=\(date)&itemPerPage=10"
        AF
            .request(url)
            .responseDecodable(of: BoxOfficeDTO.self) { [weak self] response in
                guard let `self` else { return }
                switch response.result {
                case .success(let data):
                    self.boxOffice = data.toEntity()
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension MovieSearchViewController: UITableViewDelegate,
                                     UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        boxOffice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: .movieTableCell,
            for: indexPath
        )
        guard let movieCell = cell as? MovieTableViewCell else { return cell }
        let movie = boxOffice[indexPath.row]
        movieCell.configure(movie: movie)
        return movieCell
    }
}

#Preview {
    MovieSearchViewController()
}
