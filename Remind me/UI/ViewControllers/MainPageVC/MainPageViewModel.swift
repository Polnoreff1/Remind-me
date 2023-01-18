//
//  MainPageViewModel.swift
//  Remind me
//
//  Created by Andrey Versta on 08.07.2022.
//

import UIKit

protocol IMainPageViewModel {
    func showTasksScreen(from view: UIViewController)
    func getTasksCount()
    var tasksCount: Dynamic<Int> { get }
}

class MainPageViewModel: IMainPageViewModel {
    private let dataBaseManager: IDataBaseManager
    private let assembly: Assembly
    private let router: Router
    var tasksCount = Dynamic(0)
    
    init(
        assembly: Assembly = Assembly(),
        dataBaseManager: IDataBaseManager = DataBaseManager()
    ) {
        self.assembly = assembly
        self.dataBaseManager = dataBaseManager
        self.router = Router(screenAssembly: assembly)
    }
    
    func getTasksCount() {
        DispatchQueue.main.async { [weak self] in
            if let tasksCount = self?.dataBaseManager.getDataFromBD().count {
                self?.tasksCount.value = tasksCount
            } else {
                AlertService.showErrorTextAlert(with: "Проблемы с базой данных и получением значений") {
                    return
                }
            }
        }
    }
    
    func showTasksScreen(from view: UIViewController) {
        router.showTasksListVC(from: view, with: "")
    }
}
