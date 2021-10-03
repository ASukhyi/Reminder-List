//
//  ReminderDetailViewDataSource.swift
//  ToDoList
//
//  Created by Андрей on 27.09.2021.
//

import UIKit

class ReminderDetailViewDataSource: NSObject{
    
    enum ReminderRow: Int, CaseIterable {
        case title
        case date
        case time
        case notes
        
        static var timeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.timeStyle = .short
            return formatter
        }()
        
        static let dateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .long
            return formatter
        }()
    
        func displayText(for reminder: Reminder?) -> String? {
            switch self {
            case .title:
                return reminder?.title
            case .date:
                guard let date = reminder?.dueDate else { return nil }
                if Locale.current.calendar.isDateInToday(date) {
                    return NSLocalizedString("Today", comment: "Today for date description")
                }
                return Self.dateFormatter.string(from: date)
            case .time:
                guard let time = reminder?.dueDate else { return nil }
                return Self.timeFormatter.string(from: time)
            case .notes:
                return reminder?.notes
            }
        }
     
        var cellImage: UIImage? {
            switch self  {
            case .title:
                return nil
            case .date:
                return UIImage(systemName: "calendar.circle")
            case .time:
                return UIImage(systemName: "clock")
            case .notes:
                return UIImage(systemName: "square.and.pencil")
           
            }
        }
    }
    
    private var reminder: Reminder
    
    init(reminder: Reminder) {
        self.reminder = reminder
        super.init()
    }
}

extension ReminderDetailViewDataSource: UITableViewDataSource {
    
    static let reminderDetailCellIdentifier = "ReminderDetailCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ReminderRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: Self.reminderDetailCellIdentifier, for: indexPath)
        let row = ReminderRow(rawValue: indexPath.row)
        cell.textLabel?.text = row?.displayText(for: reminder)
        cell.imageView?.image = row?.cellImage
        return cell
        
    }
}