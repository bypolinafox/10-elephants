//
//  SettingsViewController.swift
//  TenElephants
//
//  Created by Алексей Шерстнёв on 17.12.2021.
//

import Foundation
import UIKit

final class SettingsViewController: UIViewController {
    private enum Constants {
        static let cellID = "iconCell"
    }

    private struct Icon {
        let name: String
        let description: String
        let image: UIImage

        init(_ name: String, description: String) {
            self.name = name
            self.description = description
            self.image = UIImage(named: name)!
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var icons: [Icon] = [
        .init("AppIcon", description: "sampleIcon"),
        .init("dice-1", description: "blue"),
    ]

    private lazy var iconCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Choose an icon"

        view.addSubview(tableView)
        tableView.register(IconTableViewCell.self, forCellReuseIdentifier: Constants.cellID)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        icons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.cellID,
            for: indexPath
        ) as? IconTableViewCell else { return UITableViewCell() }
        cell.fillIn(
            image: icons[indexPath.row].image,
            description: icons[indexPath.row].description
        )
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UIApplication.shared.setAlternateIconName("blueIcon")
    }
}
