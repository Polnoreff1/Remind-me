//
//  CreaateTaskViewController.swift
//  Remind me
//
//  Created by Andrey Versta on 12.07.2022.
//

import UIKit
import SPAlert

class CreateTaskViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var taskView: UIView!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var timePickerView: UIView!
    @IBOutlet private weak var datePickerView: UIView!
    @IBOutlet private weak var timePickerViewTimeLabel: UILabel!
    @IBOutlet private weak var timePickerViewPickedTimeLabel: UILabel!
    @IBOutlet private weak var timePickerViewImageView: UIImageView!
    @IBOutlet private weak var datePickerViewDateLabel: UILabel!
    @IBOutlet private weak var datePickerViewPickedDateLabel: UILabel!
    @IBOutlet private weak var datePickerViewImageView: UIImageView!
    @IBOutlet private weak var createTaskButton: UIButton!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var timePicker: UIDatePicker!
    @IBOutlet weak var taskTextView: UITextView!
    
    // MARK: - Properties
    
    private let viewModel: ICreateTaskViewModel
    private var choosedDate: Date?
    private var choosedTime: Date?
    var isTextViewHaveContent: Bool = false
    private let notificationService = NotificationService()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    init(viewModel: ICreateTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        self.hideKeyboardWhenTappedAround()
        taskTextView.delegate = self
        navigationController?.setNavigationBarHidden(false, animated: true)
        taskView.layer.cornerRadius = 15
        timePickerView.layer.cornerRadius = 10
        datePickerView.layer.cornerRadius = 10
        taskView.backgroundColor = UIColor(hex: 0x4E555D)
        timeLabel.textColor = UIColor(hex: 0x71AAFF)
        dateLabel.textColor = UIColor(hex: 0x71AAFF)
        taskTextView.backgroundColor = .clear
        setupContent()
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWasShown(notification:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupContent() {
        taskTextView.text = "Опишите задачу и выберите время с датой, когда нужно создать напоминание"
        taskTextView.textColor = UIColor.lightGray
        timeLabel.text = "Время"
        dateLabel.text = "Дата"
        timePickerViewTimeLabel.text = "Выбрать"
        datePickerViewDateLabel.text = "Выбрать"
        timePickerViewPickedTimeLabel.text = "Время"
        datePickerViewPickedDateLabel.text = "Дату"
        setupGesturesForViews()
        setupPickers()
    }
    
    private func setupPickers() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
        datePicker.isHidden = true
        timePicker.isHidden = true
        datePicker.backgroundColor = .white
        timePicker.backgroundColor = .white
        datePicker.locale = Locale(identifier: "ru_RU")
        timePicker.locale = Locale(identifier: "ru_RU")
        hideDatePickerWhenTappedAround()
    }
    
    private func setupGesturesForViews() {
        let timeViewWasTapped = UITapGestureRecognizer(
            target: self,
            action: #selector(timeViewWasTapped)
        )
        timePickerView.isUserInteractionEnabled = true
        timePickerView.addGestureRecognizer(timeViewWasTapped)
        let dateViewWasTapped = UITapGestureRecognizer(
            target: self,
            action: #selector(dateViewWasTapped)
        )
        datePickerView.isUserInteractionEnabled = true
        datePickerView.addGestureRecognizer(dateViewWasTapped)
    }
    
    private func hideDatePickerWhenTappedAround() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissDatePicker)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setupNotification(with message: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Напоминание"
        content.body = message
        content.sound = .default
        notificationService.setupNotification(with: content, time: date)
    }
    
    private func configReminderAndNotification() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let task = DBTasksList()
            
            if let choosedDate = self.choosedDate, let choosedTime = self.choosedTime {
                var notificDate = Calendar.current.date(
                    from: Calendar.current.dateComponents(
                        [.year, .month, .day],
                        from: choosedDate
                    )
                )!
                let hour = Calendar.current.component(.hour, from: choosedTime)
                let minute = Calendar.current.component(.minute, from: choosedTime)
                
                let calendar = Calendar.current
                if let date = calendar.date(
                    byAdding: .hour,
                    value: hour,
                    to: notificDate
                ) {
                    let dateWihtHours = calendar.date(
                        byAdding: .minute,
                        value: minute,
                        to: date
                    )
                    if let resultDate = dateWihtHours {
                        notificDate = resultDate
                        
                        self.setupNotification(
                            with: self.taskTextView.text,
                            date: notificDate
                        )
                        
                        task.taskMessage = self.taskTextView.text
                        task.taskDate = notificDate
                        task.isDateSetted = true
                    }
                }
            } else {
                task.taskMessage = self.taskTextView.text
                task.taskDate = Date()
                task.isDateSetted = false
            }
            
            self.viewModel.createTask(task: task)
            AlertService.showDoneAlert(with: Constants.successAddedReminder) {
                self.viewModel.closeScreen(from: self)
            }
        }
    }
    
    @objc func dismissDatePicker() {
        datePicker.isHidden = true
        timePicker.isHidden = true
    }
    
    @objc private func timeViewWasTapped() {
        timePicker.resignFirstResponder()
        datePicker.isHidden = true
        timePicker.isHidden = false
    }
    
    @objc private func dateViewWasTapped() {
        datePicker.resignFirstResponder()
        timePicker.isHidden = true
        datePicker.isHidden = false
    }
    
    // MARK: - IBActions
    
    @IBAction func createTaskButtonAction(_ sender: UIButton) {
        if !isTextViewHaveContent
            || taskTextView.text.isEmpty {
            AlertService.showErrorTextAlert(with: "Задача пуста и не была создана") { [weak self] in
                guard let self = self else { return }
                self.viewModel.closeScreen(from: self)
            }
        } else {
            configReminderAndNotification()
        }
    }
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        if let url = URL(string: "tel://120") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        datePickerViewDateLabel.text = "Выбранная дата"
        datePickerViewPickedDateLabel.text = datePicker.date.dateStringWith(strFormat: "dd MMMM yyyy")
        choosedDate = datePicker.date
    }
    
    @IBAction func timePickerAction(_ sender: UIDatePicker) {
        timePickerViewTimeLabel.text = "Выбранное время"
        timePickerViewPickedTimeLabel.text = timePicker.date.dateStringWith(strFormat: "HH:mm")
        choosedTime = timePicker.date
    }
}
