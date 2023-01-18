//
//  TaskTableViewCell.swift
//  Remind me
//
//  Created by Andrey Versta on 28.06.2022.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var mainTaskLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var backroundView: UIView!
    
    // MARK: - Properties
    
    var onTaskDelete: (() -> Void) = {}
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    // MARK: - Methods
    
    func setup(with task: DBTasksList) {
        let date: String = task.taskDate.dateStringWith(strFormat: "dd MMMM yyyy")
        let time: String = task.taskDate.dateStringWith(strFormat: "HH:mm")
        var scheduleText: String = "\(date) в \(time)"
        mainTaskLabel.text = task.taskMessage
        if !task.isDateSetted {
            scheduleText = ""
        }
        dateTimeLabel.text = scheduleText
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        backgroundColor = .clear
        selectedBackgroundView = backgroundView
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        mainTaskLabel.textColor = .white
        dateTimeLabel.textColor = UIColor(hex: 0x71AAFF)
        backroundView.backgroundColor = UIColor(hex: 0x4E555D)
        backroundView.layer.cornerRadius = 15
    }
    
    // MARK: - IBActions
    @IBAction func deleteTask(_ sender: UIButton) {
        onTaskDelete()
    }
}
