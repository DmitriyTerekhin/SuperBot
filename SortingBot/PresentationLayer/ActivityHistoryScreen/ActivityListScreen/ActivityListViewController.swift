//
//  ActivityListViewController.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 28.12.2022.
//

import UIKit

class ActivityListViewController: UIViewController {
    
    private let contentView = ActivityListView()
    private let databaseService: IDatabaseService
    private var dataSource: [ActivityModel]
    
    override func loadView() {
        view = contentView
    }
    
    init(
        activityModels: [ActivityModel],
        databaseService: IDatabaseService
    ) {
        self.dataSource = activityModels
        self.databaseService = databaseService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        contentView.tableView.dataSource = self
    }
    
    @objc
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - Delegate
extension ActivityListViewController: ActivityListTableViewCellDelegate {
    func doneButtonTapped(activity: ActivityModel) {
        let predicate = NSPredicate(format: "name = %@ AND important == \(activity.howImportant) AND urgent == \(activity.howUrgent)",
                                    argumentArray: [activity.name])
        databaseService.deleteActivity(predicate: predicate) {
            dataSource.removeAll(where: {
                $0.name == activity.name && $0.howUrgent == activity.howUrgent && $0.howImportant == activity.howImportant
            })
            self.contentView.tableView.reloadData()
            guard dataSource.isEmpty else {
                return
            }
            self.backButtonTapped()
        }
    }
}

// MARK: - tableView nethods
extension ActivityListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityListTableViewCell.reuseID, for: indexPath) as! ActivityListTableViewCell
        if let model = dataSource[safe: indexPath.row] {
            cell.setup(with: model)
        }
        cell.delegate = self
        return cell
    }
}
