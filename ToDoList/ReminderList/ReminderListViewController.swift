//
//  TableViewController.swift
//  ToDoList
//
//  Created by Андрей on 25.09.2021.
//

import UIKit

class ReminderListViewController: UITableViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var filterSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var progressContainerView: UIView!
    @IBOutlet private weak var percentIncompleteView: UIView!
    @IBOutlet private weak var percentCompleteView: UIView!
    @IBOutlet private weak var percentCompleteHeightConstraint: NSLayoutConstraint!
    
    // MARK: Constants
    
    static let showDetailSegueIdentier = "ShowReminderDetailSegue"
    static let mainStoryboardName = "Main"
    static let detailViewControllerIdentifier = "ReminderDetailViewController"
    
    // MARK: Private Properties
    
    private var reminderListDataSource: ReminderListDataSource?
    private var filter: ReminderListDataSource.Filter {
        return ReminderListDataSource.Filter(rawValue: filterSegmentedControl.selectedSegmentIndex) ?? .today
    }
    
    // MARK: Life Cycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.showDetailSegueIdentier,
           let destination = segue.destination as? ReminderDetailViewController,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let rowIndex = indexPath.row
            guard let reminder = reminderListDataSource?.reminder(at: rowIndex) else {
                fatalError("Couldn't find source for reminder list")
            }
            destination.configure(with: reminder, editAction: { reminder in
                self.reminderListDataSource?.update(reminder, at: rowIndex) { success in
                    if success {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.refreshProgressView()
                        }
                    } else {
                        DispatchQueue.main.async {
                            let alertTitle = "Can't Update Reminder"
                            let alertMessage = "An error occured while attempting to update the reminder."
                            let alert = UIAlertController(title: alertTitle,
                                                          message: alertMessage,
                                                          preferredStyle: .alert)
                            let actionTitle = "OK"
                            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderListDataSource = ReminderListDataSource(reminderCompletedAction: { reminderIndex in
            DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: reminderIndex, section: 0)], with: .automatic)
            self.refreshProgressView()
            }
        }, reminderDeletedAction: {
            DispatchQueue.main.async {
            self.refreshProgressView()
            }
        }, remindersChangedAction: {
            DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshProgressView()
            }
        })
        tableView.dataSource = reminderListDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let radius = view.bounds.size.width * 0.5 * 0.7
        progressContainerView.layer.cornerRadius = radius
        progressContainerView.layer.masksToBounds = true
        self.refreshProgressView()
        //refreshBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navigationController = navigationController,
            navigationController.isToolbarHidden {
            navigationController.setToolbarHidden(false, animated: animated)
        }
    }
    
    // MARK: Actions
    
    @IBAction private func addButtonTriggered(_ sender: UIBarButtonItem) {
        addReminder()
    }
    
    @IBAction private func segmentControlChanged(_ sender: UISegmentedControl) {
        reminderListDataSource?.filter = filter
        tableView.reloadData()
        self.refreshProgressView()
       // refreshBackground()
    }
    
    // MARK: Private Methods
    
    private func addReminder() {
        let storyboard = UIStoryboard(name: Self.mainStoryboardName, bundle: nil)
        let detailViewController: ReminderDetailViewController = storyboard.instantiateViewController(identifier: Self.detailViewControllerIdentifier)
        let reminder = Reminder(id: UUID().uuidString, title: "New Reminder", dueDate: Date())
        detailViewController.configure(with: reminder, isNew: true, addAction: { reminder in
            self.reminderListDataSource?.add(reminder, completion: { (index) in
                if let index = index {
                    DispatchQueue.main.async {
                        self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        self.refreshProgressView()
                    }
                }
            })
        })
            
        let navigationController = UINavigationController(rootViewController: detailViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func refreshProgressView() {
        guard let percentComplete = reminderListDataSource?.percentComplete else { return }
        let totalHeight = progressContainerView.bounds.size.height
        percentCompleteHeightConstraint.constant = totalHeight * CGFloat(percentComplete)
        UIView.animate(withDuration: 0.2) {
            self.progressContainerView.layoutSubviews()
        }
    }
        

    
//    private func refreshBackground() {
//        tableView.backgroundView = nil
//        let backgroundView = UIView()
//        if let backgroundColors = filter.backgroundColors {
//            let gradientBackgroundLayer = CAGradientLayer()
//            gradientBackgroundLayer.colors = backgroundColors
//            gradientBackgroundLayer.frame = tableView.frame
//        } else {
//            backgroundView.backgroundColor = filter.substituteBackgroundColor
//        }
//        tableView.backgroundView = backgroundView
//    }
}

//fileprivate extension ReminderListDataSource.Filter {
//    private var gradientBeginColor: UIColor? {
//        switch self {
//        case .today:
//            return UIColor(named: "LIST_GradientTodayBegin")
//        case .future:
//            return UIColor(named: "LIST_GradientFutureBegin")
//        case .all:
//            return UIColor(named: "LIST_GradientAllBegin")
//        }
//    }
    
//    private var gradientEndColor: UIColor? {
//        switch self {
//        case .today:
//            return UIColor(named: "LIST_GradientTodayEnd")
//        case .future:
//            return UIColor(named: "LIST_GradientFutureEnd")
//        case .all:
//            return UIColor(named: "LIST_GradientAllEnd")
//        }
//    }
//
//    var backgroundColors: [CGColor]? {
//        guard let beginColor = gradientBeginColor, let endColor = gradientEndColor else {
//            return nil
//        }
//        return [beginColor.cgColor, endColor.cgColor]
//    }
//
//    var substituteBackgroundColor: UIColor {
//        return gradientBeginColor ?? .tertiarySystemBackground
//    }
//}
    
    


