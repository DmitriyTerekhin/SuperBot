//
//  ActivityHistoryViewController.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import UIKit

class ActivityHistoryViewController: UIViewController {
    
    private let contentView = ActivityHistoryView()
    private let numberOfCells: Int = 5*5
    private let importantDataSource: [Int] = [1,2,3,4,5]
    private let urgentDataSource: [Int] = [5,4,3,2,1]
    private let databaseService: IDatabaseService
    private var allActivities: [ActivityModel]
    private var indexPathToColorized: [Int: [ActivityModel]] = [:]
    
    init(databaseService: IDatabaseService) {
        self.databaseService = databaseService
        allActivities = databaseService.getActivities(predicate: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareDataSource()
    }
    
    private func prepareDataSource() {
        allActivities = databaseService.getActivities(predicate: nil)
        indexPathToColorized = [:]
        guard allActivities.count > 0
        else {
            contentView.historyCollectionView.isHidden = true
            contentView.urgentArrowsImageView.isHidden = true
            contentView.titleLabel.isHidden = false
            contentView.equipmentsImageView.isHidden = false
            contentView.importantArrowsImageView.isHidden = true
            contentView.urgentCollectionView.isHidden = true
            contentView.importantCollectionView.isHidden = true
            return
        }
        
        allActivities.forEach({
            let row = getIndexPathRowFor(important: $0.howImportant, urgent: $0.howUrgent)
            if var models: [ActivityModel] = indexPathToColorized[row] {
                models.append($0)
                indexPathToColorized[row] = models
            } else {
                indexPathToColorized[row] = [$0]
            }
        })
        contentView.historyCollectionView.isHidden = false
        contentView.importantArrowsImageView.isHidden = false
        contentView.importantCollectionView.isHidden = false
        contentView.urgentCollectionView.isHidden = false
        contentView.urgentArrowsImageView.isHidden = false
        contentView.titleLabel.isHidden = true
        contentView.equipmentsImageView.isHidden = true
        contentView.historyCollectionView.reloadData()
    }

    private func setupView() {
        contentView.historyCollectionView.dataSource = self
        contentView.historyCollectionView.delegate = self
        contentView.urgentCollectionView.delegate = self
        contentView.importantCollectionView.delegate = self
        contentView.urgentCollectionView.dataSource = self
        contentView.importantCollectionView.dataSource = self
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func showActivityList(models: [ActivityModel]) {
        let actListVC = ActivityListViewController(activityModels: models, databaseService: databaseService)
        navigationController?.pushViewController(actListVC, animated: true)
    }
    
    // Row indexPath'a
    private func getIndexPathRowFor(important: Int, urgent: Int) -> Int {
        let row = (5 - urgent) * 5 + (important - 1)
        return row
    }
    
    /*
     important
     0 1 2 3 4
     5 6 7 8 9
     10 11 12 13 14
     15 16 17 18 19
     20 21 22 23 24
     */
}

// MARK: - UICollectionView dataSource
extension ActivityHistoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case contentView.historyCollectionView:
            return ActivityHistoryView.Constants.betweenCell
        case contentView.importantCollectionView:
            return ActivityHistoryView.Constants.betweenCell
        case contentView.urgentCollectionView:
            return ActivityHistoryView.Constants.betweenCell
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case contentView.historyCollectionView:
            return ActivityHistoryView.Constants.betweenCell
        case contentView.importantCollectionView:
            return ActivityHistoryView.Constants.betweenCell
        case contentView.urgentCollectionView:
            return ActivityHistoryView.Constants.betweenCell
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case contentView.historyCollectionView:
            return CGSize(width: ActivityHistoryView.Constants.cellSize,
                          height: ActivityHistoryView.Constants.cellSize)
        case contentView.importantCollectionView:
            return CGSize(width: (collectionView.bounds.width - ActivityHistoryView.Constants.betweenCell*4 - 2*ActivityHistoryView.Constants.cellInset)/5,
                          height: 20)
        case contentView.urgentCollectionView:
            return CGSize(width: 20,
                          height: (collectionView.bounds.height - ActivityHistoryView.Constants.betweenCell*4 - 2*ActivityHistoryView.Constants.cellInset)/5)
        default:
            return CGSize.zero
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case contentView.historyCollectionView:
            return numberOfCells
        case contentView.importantCollectionView:
            return importantDataSource.count
        case contentView.urgentCollectionView:
            return urgentDataSource.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case contentView.historyCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCollectionViewCell.reuseID, for: indexPath) as! HistoryCollectionViewCell
            if indexPathToColorized[indexPath.row] != nil {
                cell.prepare(eventExist: true)
            } else {
                cell.prepare(eventExist: false)
            }
            return cell
        case contentView.importantCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryNumberCollectionViewCell.reuseID, for: indexPath) as! HistoryNumberCollectionViewCell
            let value = String(importantDataSource[safe: indexPath.row] ?? 0)
            cell.prepare(with: value)
            return cell
        case contentView.urgentCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryNumberCollectionViewCell.reuseID, for: indexPath) as! HistoryNumberCollectionViewCell
            let value = String(urgentDataSource[safe: indexPath.row] ?? 0)
            cell.prepare(with: value)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let models = indexPathToColorized[indexPath.row] {
            showActivityList(models: models)
        }
    }
}
