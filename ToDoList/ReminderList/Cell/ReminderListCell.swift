//
//  ReminderListCell.swift
//  ToDoList
//
//  Created by Андрей on 27.09.2021.
//

import UIKit

class ReminderListCell: UITableViewCell {
    
    typealias DoneButtonAction = () -> Void
    
    // MARK: Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var doneButton: UIButton!
    
    // MARK: Properties
    
    private var doneButtonAction: DoneButtonAction?
    
    // MARK: Actions
    
    @IBAction private func doneButtonTriggered(_ sender: UIButton) {
        doneButtonAction?()
    }
    
    // MARK: Public Methods
    
    public func configure(title: String,
                          dateText: String,
                          isDone: Bool,
                          doneButtonAction: @escaping DoneButtonAction) {
        titleLabel.text = title
        dateLabel.text = dateText
        let image = isDone ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
        doneButton.setBackgroundImage(image, for: .normal)
        self.doneButtonAction = doneButtonAction
    }
}
