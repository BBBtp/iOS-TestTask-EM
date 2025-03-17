//
//  TaskRepository.swift
//  ToDoList
//
//  Created by Богдан Топорин on 17.03.2025.
//

import Foundation

protocol TaskRepositoryProtocol {
    func fetchTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void)
    func fetchTasksFromCoreData() -> [TaskModel]
    func saveTasksToCoreData(_ tasks: [TaskModel])
    func updateTask(_ task: TaskModel)
    func addTask(_ task: TaskModel)
    func deleteTask(_ task: TaskModel)
    func deleteAllTasks()
}
