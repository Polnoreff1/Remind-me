//
//  TasksListViewModel.swift
//  Remind me
//
//  Created by Andrey Versta on 21.07.2022.
//

import UIKit
import Realm
import RealmSwift

protocol ITasksListViewModel {
    func showCreateTaskViewController(from view: UIViewController)
    func showDetailTaskViewController(
        from view: UIViewController,
        with task: DBTasksList
    )
    func getData()
    func deleteTask(with task: DBTasksList)
    var tasks: Dynamic<[DBTasksList]> { get }
}

class TasksListViewModel: ITasksListViewModel {
    
    private let dataBaseManager: IDataBaseManager
    private let assembly: Assembly
    private let router: IRouter
    var tasks = Dynamic([DBTasksList()])
    weak var tasksListViewController: ITasksListViewController?
    
    init(
        assembly: Assembly,
        router: IRouter,
        dataBaseManager: IDataBaseManager
    ) {
        self.assembly = assembly
        self.router = router
        self.dataBaseManager = dataBaseManager
    }
    
    func getData() {
        var resultTaskArray: [DBTasksList] = []
        dataBaseManager.getDataFromBD().forEach { dbTask in
            resultTaskArray.append(dbTask)
        }
        tasks.value = resultTaskArray
    }
    
    func showDetailTaskViewController(from view: UIViewController, with task: DBTasksList) {
        router.showTaskDetailViewController(from: view, with: task)
    }
    
    func showCreateTaskViewController(from view: UIViewController) {
        router.showCreateTaskViewController(from: view)
    }
    
    func deleteTask(with task: DBTasksList) {
        dataBaseManager.deleteFromDB(task: task)
    }
}
