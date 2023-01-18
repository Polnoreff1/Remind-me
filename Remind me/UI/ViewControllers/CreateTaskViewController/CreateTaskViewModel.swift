//
//  CreateTaskViewModel.swift
//  Remind me
//
//  Created by Andrey Versta on 21.07.2022.
//

import UIKit

protocol ICreateTaskViewModel {
    func createTask(task: DBTasksList)
    func closeScreen(from view: UIViewController)
}

class CreateTaskViewModel: ICreateTaskViewModel {
    
    private let dataBaseManager: IDataBaseManager
    private let assembly: Assembly
    private let router: IRouter
    
    init(
        assembly: Assembly,
        router: IRouter,
        dataBaseManager: IDataBaseManager
    ) {
        self.assembly = assembly
        self.router = router
        self.dataBaseManager = dataBaseManager
    }
    
    func createTask(task: DBTasksList) {
        DispatchQueue.main.async {
            self.dataBaseManager.saveToDB(task: task)
        }
    }
    
    func closeScreen(from view: UIViewController) {
        router.closeScreens(from: view)
    }
}
