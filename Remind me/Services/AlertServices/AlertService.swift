//
//  AlertService.swift
//  Remind me
//
//  Created by Andrey Versta on 09.08.2022.
//

import SPAlert

enum AlertService {
    static func showDoneAlert(with text: String, completion: (() -> Void)? = nil) {
        let alertView = SPAlertView(title: text, preset: .done)
        alertView.duration = 1.3
        alertView.layout.spaceBetweenIconAndTitle = 8
        alertView.present(haptic: .success) {
            if let completion = completion {
                completion()
            }
        }
    }
    
    static func showErrorTextAlert(with text: String, completion: (() -> Void)? = nil) {
        let alertView = SPAlertView(title: text, preset: .error)
        alertView.duration = 1.3
        alertView.layout.spaceBetweenIconAndTitle = 8
        alertView.present(haptic: .success) {
            if let completion = completion {
                completion()
            }
        }
    }
}
