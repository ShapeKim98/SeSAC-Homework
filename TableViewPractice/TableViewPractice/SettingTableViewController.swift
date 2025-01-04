//
//  SettingTableViewController.swift
//  TableViewPractice
//
//  Created by 김도형 on 1/2/25.
//

import UIKit

class SettingTableViewController: UITableViewController {
    private let data: [String: [String]] = [
        "전체 설정": ["공지사항", "실험실", "버전 정보"],
        "개인 설정": ["개인/보안", "알림", "채팅", "멀티프로필"],
        "기타": ["고객센터/도움말"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard
            let header = SectionHeader(rawValue: section),
            let count = data[header.title]?.count
        else { return 0 }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ???: identifier가 string이라 옵셔널 바인딩 처리 보단 강제 언래핑으로 cell 을 불러오지 못할 때 크래시를 발생 시키면 디버깅할 때 편하지 않을까?란 생각을 했는데.. 이렇게 해도 괜찮은건지 궁금합니다..!!
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SettingCell"
        )!
        guard
            let header = SectionHeader(rawValue: indexPath.section),
            let cellText = data[header.title]?[indexPath.row]
        else { return cell }
        
        var content = cell.defaultContentConfiguration()
        content.text = cellText
        content.textProperties.font = .systemFont(ofSize: 12)
        
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let header = SectionHeader(rawValue: section) else { return nil }
        return header.title
    }
}

extension SettingTableViewController {
    enum SectionHeader: Int {
        case total
        case personal
        case other
        
        var title: String {
            switch self {
            case .total: return "전체 설정"
            case .personal: return "개인 설정"
            case .other: return "기타"
            }
        }
    }
}
