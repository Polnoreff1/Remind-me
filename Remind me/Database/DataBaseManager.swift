//
//  DataBaseManager.swift
//  Remind me
//
//  Created by Andrey Versta on 01.08.2022.
//

import RealmSwift

protocol IDataBaseManager {
    func getDataFromBD() -> Results<DBTasksList>!
    func saveToDB(task: DBTasksList)
    func deleteFromDB(task: DBTasksList)
}

final class DataBaseManager: IDataBaseManager {
    
    private var allTasks = Dynamic([DBTasksList()])
    private let realm = try! Realm()
    
    private var results: Results<DBTasksList>! {
        didSet {
            var resultTaskArray: [DBTasksList] = []
            results.forEach { dbTask in
                resultTaskArray.append(dbTask)
            }
            allTasks.value = resultTaskArray
        }
    }
    
    func getDataFromBD() -> Results<DBTasksList>! {
        self.results = self.realm.objects(DBTasksList.self)
        return results
    }
    
    func saveToDB(task: DBTasksList) {
        DispatchQueue.main.async { [weak self] in
            try! self?.realm.write {
                self?.realm.add(task)
            }
        }
    }
    
    func deleteFromDB(task: DBTasksList) {
        try! self.realm.write({
            self.realm.delete(
                self.realm.objects(DBTasksList.self).filter("taskMessage=%@", task.taskMessage)
            )
            var resultTaskArray: [DBTasksList] = []
            self.results = self.realm.objects(DBTasksList.self)
            results.forEach { dbTask in
                resultTaskArray.append(dbTask)
            }
            allTasks.value = resultTaskArray
        })
    }
}
