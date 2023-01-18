//
//  Router.swift
//  Remind me
//
//  Created by Andrey Versta on 19.07.2022.
//

import UIKit

protocol IRouter {
    func showTasksListVC(from view: UIViewController, with tasks: String)
    func showTaskDetailViewController(from view: UIViewController, with task: DBTasksList)
    func showCreateTaskViewController(from view: UIViewController)
    func closeScreens(from view: UIViewController)
}

final class Router: IRouter {
    
    private let screenAssembly: Assembly
    private var viewController: UIViewController = UIViewController()
    
    init(screenAssembly: Assembly) {
        self.screenAssembly = screenAssembly
    }
    
    func showTasksListVC(from view: UIViewController, with placeHolder: String) {
        let emptyModel = DBTasksList()
        viewController = screenAssembly.assemble(with: emptyModel, type: .taskListsVC)
        view.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showTaskDetailViewController(from view: UIViewController, with task: DBTasksList) {
        viewController = screenAssembly.assemble(with: task, type: .taskDetailsVC)
        view.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showCreateTaskViewController(from view: UIViewController) {
        let emptyModel = DBTasksList()
        viewController = screenAssembly.assemble(with: emptyModel, type: .createTaskVC)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            view.navigationController?.pushViewController(self.viewController, animated: true)
        }
    }
    
    func closeScreens(from view: UIViewController) {
        view.navigationController?.popViewController(animated: true)
    }
}
