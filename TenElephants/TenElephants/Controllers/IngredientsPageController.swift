//
//  IngredientsPageController.swift
//  TenElephants
//
//  Created by Полина Скалкина on 16.12.2021.
//

import Foundation
import UIKit

final class IngredientsPageController: UIViewController {
    private enum IngredientsSection: Int {
        case header = 0
        case elements = 1
    }

    private enum Constants {
        static let cellId = "IngredientTableCell"
        static let ingredientsHeaderCellId = "IngredientsHeaderTableCell"
        static let ingredientCellHeight = 60.0
        static let headerCellHeight = 70.0
    }

    private lazy var tableView = UITableView(frame: .zero)

    private let dataProvider: IngredientsDataProvider
    private var ingredientsData: IngredientsUIData?
    private let openSingleIngredient: (IngredientUIData) -> Void

    init(
        dataProvider: IngredientsDataProvider,
        imageLoader: ImageLoader,
        openSingleIngredient: @escaping (IngredientUIData) -> Void
    ) {
        self.dataProvider = dataProvider
        self.openSingleIngredient = openSingleIngredient
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Init from coder is not available")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        configTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func fetchData() {
        dataProvider.fetchIngredientsList { [weak self] result in
            switch result {
            case .failure:
                return
            case let .success(data):
                self?.ingredientsData = data
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension IngredientsPageController: UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = IngredientsSection(rawValue: section) else {
            assertionFailure("No section provided")
            return 0
        }

        switch section {
        case .header: return 1
        case .elements: return ingredientsData?.ingredients.count ?? 0
        }
    }

    func numberOfSections(in _: UITableView) -> Int {
        2
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = IngredientsSection(rawValue: indexPath.section) else {
            assertionFailure("No section provided")
            return 0.0
        }

        switch section {
        case .header:
            return Constants.headerCellHeight
        case .elements:
            return Constants.ingredientCellHeight
        }
    }
}

extension IngredientsPageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = IngredientsSection(rawValue: indexPath.section) else {
            assertionFailure("No section provided")
            return UITableViewCell()
        }

        switch section {
        case .header:
            let reusableCell = tableView.dequeueReusableCell(
                withIdentifier: Constants.ingredientsHeaderCellId,
                for: indexPath
            )

            guard let cell = reusableCell as? IngredientsHeaderTableCell else {
                return reusableCell
            }

            cell.configure()
            cell.selectionStyle = .none

            return cell

        case .elements:
            let reusableCell = tableView.dequeueReusableCell(
                withIdentifier: Constants.cellId,
                for: indexPath
            )

            guard let cell = reusableCell as? IngredientTableCell else {
                return reusableCell
            }

            cell
                .configure(
                    ingredientData: ingredientsData?
                        .ingredients[indexPath.row] ??
                        IngredientUIData(title: nil, type: nil, description: nil)
                )
            cell.selectionStyle = .none

            return cell
        }
    }

    private func configTableView() {
        tableView.register(IngredientTableCell.self, forCellReuseIdentifier: Constants.cellId)
        tableView.register(
            IngredientsHeaderTableCell.self,
            forCellReuseIdentifier: Constants.ingredientsHeaderCellId
        )

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        tableView.backgroundColor = .systemBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none

        tableView.delegate = self
        tableView.dataSource = self

        tableView.reloadData()
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = IngredientsSection(rawValue: indexPath.section),
              section == .elements else {
            return
        }
        if let ingredient = ingredientsData?.ingredients[indexPath.row] {
            openSingleIngredient(ingredient)
        }
    }
}
