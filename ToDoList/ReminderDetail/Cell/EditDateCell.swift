//
//  EditDateCell.swift
//  ToDoList
//
//  Created by Андрей on 27.09.2021.
//

import UIKit

class EditDateCell: UITableViewCell {
    
    typealias DateChangeAction = (Date) -> Void
    
    // MARK: Outlets
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: Properties
    
    private var dateChangeAction: DateChangeAction?
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)) , for: .valueChanged)
    }
    
    // MARK: Public Methods
    
    public func configure(date: Date, changeAction: @escaping DateChangeAction) {
        datePicker.date = date
        self.dateChangeAction = changeAction
    }
    
    // MARK: Private Methods
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        dateChangeAction?(sender.date)
    }
}
