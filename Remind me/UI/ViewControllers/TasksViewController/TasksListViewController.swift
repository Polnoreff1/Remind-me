//
//  TasksListViewController.swift
//  Remind me
//
//  Created by Andrey Versta on 29.06.2022.
//

import UIKit

protocol ITasksListViewController: AnyObject {
    func setup(with model: [DBTasksList])
}

class TasksListViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addTaskButton: UIButton!
    
    // MARK: - Properties
    
    private let viewModel: ITasksListViewModel
    private var arrayOfTasks: [DBTasksList] = []
    private var dataSource: UITableViewDiffableDataSource<Section, DBTasksList>!
    
    private enum Section {
        case first
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        bindViewModel()
    }
    
    init(viewModel: ITasksListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewModel.getData()
    }
    
    // MARK: - Private Methods
    
    private func bindViewModel() {
        viewModel.tasks.bind { (tasks) in
            DispatchQueue.main.async { [weak self] in
                self?.arrayOfTasks = tasks
                self?.setupTableView()
                self?.updateDataSource(with: tasks)
            }
        }
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: String(describing: TaskTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: String(describing: TaskTableViewCell.self))
        setupDataSource()
        tableView.rowHeight = 150
        tableView.separatorStyle = .none
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, DBTasksList>(tableView: tableView) { [weak self]            tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TaskTableViewCell.self),
                for: indexPath
            ) as! TaskTableViewCell
            if let self = self, !self.arrayOfTasks.isEmpty {
                let task = self.arrayOfTasks[indexPath.row]
                cell.setup(with: task)
                
                cell.onTaskDelete = {
                    self.arrayOfTasks.remove(at: indexPath.row)
                    self.viewModel.deleteTask(with: task)
                    AlertService.showDoneAlert(
                        with: Constants.successDeletedReminder)
                    self.viewModel.getData()
                }
            }
            return cell
        }
    }
    
    private func setupButtons() {
        let backItem = UIBarButtonItem()
        backItem.title = "К списку задач"
        navigationItem.backBarButtonItem = backItem
        addTaskButton.layer.cornerRadius = 15
    }
    
    private func updateDataSource(with tasks: [DBTasksList]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DBTasksList>()
        snapshot.appendSections([.first])
        snapshot.appendItems(tasks)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func createTaskAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.viewModel.showCreateTaskViewController(from: self)
        }
    }
}

// MARK: - Extension

extension TasksListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = arrayOfTasks[indexPath.row]
        viewModel.showDetailTaskViewController(from: self, with: task)
    }
}

extension TasksListViewController: ITasksListViewController {
    func setup(with model: [DBTasksList]) {
        arrayOfTasks = model
    }
}
