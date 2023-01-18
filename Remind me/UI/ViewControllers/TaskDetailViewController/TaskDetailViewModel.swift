//
//  TaskDetailViewModel.swift
//  Remind me
//
//  Created by Andrey Versta on 21.07.2022.
//

import UIKit

protocol ITaskDetailViewModel {
    func getData() -> DBTasksList
    func deleteTask(with task: DBTasksList)
    func closeScreen(from view: UIViewController)
}

class TaskDetailViewModel: ITaskDetailViewModel {
    
    private let dataBaseManager: IDataBaseManager
    private let assembly: Assembly
    private let router: IRouter
    private let task: DBTasksList?
    var tasks = Dynamic([DBTasksList()])
    weak var tasksListViewController: ITasksListViewController?
    
    init(
        assembly: Assembly,
        router: IRouter,
        dataBaseManager: IDataBaseManager,
        task: DBTasksList?
    ) {
        self.assembly = assembly
        self.router = router
        self.dataBaseManager = dataBaseManager
        self.task = task
    }
    
    func getData() -> DBTasksList {
        if let task = task {
            return task
        } else {
            return DBTasksList()
        }
    }
    
    func deleteTask(with task: DBTasksList) {
        dataBaseManager.deleteFromDB(task: task)
    }
    
    func closeScreen(from view: UIViewController) {
        router.closeScreens(from: view)
    }
}
