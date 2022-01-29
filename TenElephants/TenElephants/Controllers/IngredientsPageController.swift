//
//  IngredientsPageController.swift
//  TenElephants
//
//  Created by Полина Скалкина on 16.12.2021.
//

import Foundation
import UIKit

final class IngredientsPageController: UIViewController {
    private enum Constants {
        static let cellId = "IngredientTableCell"
    }

    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)

    private let dataProvider: IngredientsDataProvider
    private var ingredientsData: IngredientsUIData?
    private let openSingleIngredient: (IngredientUIData) -> Void

    init(
        dataProvider: IngredientsDataProvider,
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
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        ingredientsData?.ingredients.count ?? 0
    }

    func numberOfSections(in _: UITableView) -> Int {
        1
    }
}

extension IngredientsPageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        return cell
    }

    private func configTableView() {
        tableView.register(IngredientTableCell.self, forCellReuseIdentifier: Constants.cellId)

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        tableView.backgroundColor = .systemBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.delegate = self
        tableView.dataSource = self

        tableView.reloadData()
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let ingredient = ingredientsData?.ingredients[indexPath.row] {
            openSingleIngredient(ingredient)
        }
    }
}
