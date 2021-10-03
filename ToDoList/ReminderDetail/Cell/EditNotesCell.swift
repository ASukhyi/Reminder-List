//
//  EditNotesCell.swift
//  ToDoList
//
//  Created by Андрей on 27.09.2021.
//

import UIKit

class EditNotesCell: UITableViewCell {
    
    typealias NotesChangeAction = (String) -> Void
    
    // MARK: Outlets
    
    @IBOutlet private weak var notesTextView: UITextView!
    
    // MARK: Properties
    
    private var notesChangeAction: NotesChangeAction?
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notesTextView.delegate = self 
    }
    
    // MARK: Public Methods
    
    public func configure(notes: String?, changeAction: NotesChangeAction?) {
        notesTextView.text = notes
        self.notesChangeAction = changeAction
    }
}

// MARK: - UITextViewDelegate

extension EditNotesCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if let originalText = textView.text {
            let title = (originalText as NSString).replacingCharacters(in: range, with: text)
            notesChangeAction?(title)
        }
        return true
    }
}
