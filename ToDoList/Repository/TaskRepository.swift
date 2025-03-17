//
//  TaskRepository.swift
//  ToDoList
//
//  Created by Богдан Топорин on 17.03.2025.
//

import Foundation

class TaskRepository: TaskRepositoryProtocol {
    private let apiClient: APIClient
    private let taskStore: TaskStore
    
    init(apiClient: APIClient, taskStore: TaskStore) {
        self.apiClient = apiClient
        self.taskStore = taskStore
    }
    
    func fetchTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        apiClient.fetchTasks(skip: 0, limit: 30) { result in
            switch result {
            case .success(let response):
                let tasks = response.todos.map {
                    TaskModel(id: $0.id, title: nil, todo: $0.todo, completed: $0.completed, userId: $0.userId, createdAt: nil)
                }
                self.saveTasksToCoreData(tasks)
                completion(.success(tasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTasksFromCoreData() -> [TaskModel] {
        return taskStore.fetchTasks()
    }

    func saveTasksToCoreData(_ tasks: [TaskModel]) {
        taskStore.syncWithAPI(tasks: tasks)
    }

    func updateTask(_ task: TaskModel) {
        taskStore.updateTask(updatedTask: task, at: task.id)
    }

    func addTask(_ task: TaskModel) {
        taskStore.addTask(task: task)
    }

    func deleteTask(_ task: TaskModel) {
        taskStore.deleteTask(at: task.id)
    }

    func deleteAllTasks() {
        taskStore.deleteAllTasks()
    }
}
