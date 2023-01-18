//
//  CreateTaskViewController+extensions.swift
//  Remind me
//
//  Created by Andrey Versta on 09.08.2022.
//

import UIKit

extension CreateTaskViewController {
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo
        if let keyboardRect = info?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
            let keyboardSize = keyboardRect.size
            taskTextView.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardSize.height - 100,
                right: 0
            )
            taskTextView.scrollIndicatorInsets = taskTextView.contentInset
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        taskTextView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )
        taskTextView.scrollIndicatorInsets = taskTextView.contentInset
    }
}

extension CreateTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            isTextViewHaveContent = true
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            isTextViewHaveContent = false
            textView.text = "Опишите задачу и выберите время с датой, когда нужно создать напоминание"
            textView.textColor = UIColor.lightGray
        }
    }
}
