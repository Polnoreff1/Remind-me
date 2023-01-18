//
//  Assembly.swift
//  Remind me
//
//  Created by Andrey Versta on 19.07.2022.
//

import UIKit

enum ViewControllersTypes {
    case taskListsVC
    case taskDetailsVC
    case createTaskVC
}

protocol AssemblyProtocol {
    func assemble(with data: DBTasksList?, type: ViewControllersTypes) -> UIViewController
}

final class Assembly: AssemblyProtocol {
    
    let dataBaseManager: IDataBaseManager
    
    init(dataBaseManager: IDataBaseManager = DataBaseManager()) {
        self.dataBaseManager = dataBaseManager
    }
    
    func assemble(with data: DBTasksList?, type: ViewControllersTypes) -> UIViewController {
        let router: IRouter = Router(screenAssembly: self)
        let viewController: UIViewController
        switch type {
        case .taskListsVC:
            let viewModel = TasksListViewModel(
                assembly: self,
                router: router,
                dataBaseManager: dataBaseManager
            )
            viewController = TasksListViewController(viewModel: viewModel)
        case .taskDetailsVC:
            let viewModel = TaskDetailViewModel(
                assembly: self,
                router: router,
                dataBaseManager: dataBaseManager,
                task: data
            )
            viewController = TaskDetailViewController(viewModel: viewModel)
        case .createTaskVC:
            let viewModel = CreateTaskViewModel(
                assembly: self,
                router: router,
                dataBaseManager: dataBaseManager
            )
            viewController = CreateTaskViewController(viewModel: viewModel)
        }
        return viewController
    }
}
