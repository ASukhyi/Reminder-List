//
//  EditTitleCell.swift
//  ToDoList
//
//  Created by Андрей on 27.09.2021.
//

import UIKit

class EditTitleCell: UITableViewCell {

    typealias TitleChangeAction = (String) -> Void
        
    // MARK: Outlets
    
    @IBOutlet private weak var titleTextField: UITextField!
    
    // MARK: Properties
    
    private var titleChangeAction: TitleChangeAction?
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextField.delegate = self
    }
    
    // MARK: Public Methods
    
    public func configure(title: String, changeAction: @escaping TitleChangeAction) {
        titleTextField.text = title
        self.titleChangeAction = changeAction
    }
}

// MARK: - UITextFieldDelegate

extension EditTitleCell: UITextFieldDelegate {
    
   func textField(_ textField: UITextField,
                  shouldChangeCharactersIn range: NSRange,
                  replacementString string: String) -> Bool {
        if let originalText = textField.text {
            let title = (originalText as NSString).replacingCharacters(in: range, with: string)
            titleChangeAction?(title)
        }
        return true
    }
}
