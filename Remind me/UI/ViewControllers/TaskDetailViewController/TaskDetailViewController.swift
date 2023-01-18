//
//  TaskDetailViewController.swift
//  Remind me
//
//  Created by Andrey Versta on 12.07.2022.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var taskTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    // MARK: - Properties
    
    private let viewModel: ITaskDetailViewModel
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    init(viewModel: ITaskDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        taskView.layer.cornerRadius = 15
        setupColors()
        setupContent()
    }
    
    private func setupColors() {
        taskView.backgroundColor = UIColor(hex: 0x4E555D)
        timeLabel.textColor = UIColor(hex: 0x71AAFF)
        dateLabel.textColor = UIColor(hex: 0x71AAFF)
        currentTimeLabel.textColor = UIColor(hex: 0x71AAFF)
        currentDateLabel.textColor = UIColor(hex: 0x71AAFF)
        taskTextView.backgroundColor = .clear
    }
    
    private func setupContent() {
        let task = viewModel.getData()
        taskTextView.text = task.taskMessage
        taskTextView.textColor = UIColor.white
        
        if !task.isDateSetted {
            timeLabel.isHidden = true
            dateLabel.isHidden = true
            currentDateLabel.isHidden = true
            currentTimeLabel.isHidden = true
        } else {
            timeLabel.text = "Время"
            dateLabel.text = "Дата"
            currentDateLabel.text = task.taskDate.dateStringWith(
                strFormat: "dd MMMM yyyy"
            )
            currentTimeLabel.text = task.taskDate.dateStringWith(
                strFormat: "HH:mm"
            )
        }
    }
    
    private func deleteTask() {
        let task = viewModel.getData()
        let dbTask = DBTasksList()
        dbTask.taskMessage = task.taskMessage
        dbTask.taskDate = task.taskDate
        viewModel.deleteTask(with: dbTask)
        
        AlertService.showDoneAlert(with: Constants.successDeletedReminder) { [weak self] in
            guard let self = self else { return }
            self.viewModel.closeScreen(from: self)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        deleteTask()
    }
}
