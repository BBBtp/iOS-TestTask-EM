//
//  TaskListResponse.swift
//  ToDoList
//
//  Created by Богдан Топорин on 16.03.2025.
//

import Foundation

struct TaskListResponse: Codable {
    let todos: [TaskModelResponse]
    let total: Int
    let skip: Int
    let limit: Int 
}
