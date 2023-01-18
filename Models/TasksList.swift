//
//  TasksList.swift
//  Remind me
//
//  Created by Andrey Versta on 25.07.2022.
//

import RealmSwift

class DBTasksList: Object {
  @objc dynamic var taskMessage: String = ""
  @objc dynamic var taskDate: Date = Date()
  @objc dynamic var isDateSetted: Bool = false
}

struct TasksList: Hashable {
  var taskMessage: String = ""
  var taskDate: Date = Date()
}
