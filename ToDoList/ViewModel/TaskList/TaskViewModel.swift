//
//  TaskViewModel.swift
//  ToDoList
//
//  Created by Богдан Топорин on 16.03.2025.
//

import Foundation

class TaskViewModel {
    private let taskRepository: TaskRepositoryProtocol
    
    private var allTasks: [TaskModel]? {
        didSet {
            onTaskListLoaded?()
        }
    }
   
    private(set) var tasks: [TaskModel]? {
        didSet {
            onTaskListLoaded?()
        }
    }
    
    var onTaskListLoaded: (() -> Void)?
    var onTaskListLoadedError: ((String) -> Void)?
    var onTaskDeleted: ((IndexPath) -> Void)?
    var numberOfTasks: Int {
        return tasks?.count ?? 0
    }
    
    init(taskRepository: TaskRepositoryProtocol) {
        self.taskRepository = taskRepository
    }
    
    func updateTask(at index: IndexPath, updatedTask: TaskModel?) {
        guard let updatedTask = updatedTask else { return }
        taskRepository.updateTask(updatedTask)
        loadTasksFromCoreData()
    }
    
    func addTask(task: TaskModel?) {
        guard let task = task else { return }
        taskRepository.addTask(task)
        loadTasksFromCoreData()
    }
    
    func deleteTask(at index: IndexPath) {
        guard let taskToDelete = tasks?[index.row] else { return }
        taskRepository.deleteTask(taskToDelete)
        loadTasksFromCoreData()
    }
    
    func getEmptyTask() -> TaskModel {
        let task = TaskModel(id: -1,
                             title: "",
                             todo: "",
                             completed: false,
                             userId: -1,
                             createdAt: "")
        return task
    }

    func fetchTasks() {
        if isFirstLaunch() {
            taskRepository.fetchTasks { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let tasks):
                    self.allTasks = tasks
                    self.tasks = tasks
                case .failure(let error):
                    self.onTaskListLoadedError?(error.localizedDescription)
                }
            }
        } else {
            loadTasksFromCoreData()
        }
    }
    
    func filterTasks(with searchText: String?) {
        guard let searchText = searchText, !searchText.isEmpty, let allTasks = allTasks else {
            tasks = allTasks ?? []
            return
        }
        tasks = allTasks.filter { $0.todo.lowercased().contains(searchText.lowercased()) }
    }
    
    func task(at index: Int) -> TaskModel? {
        guard let tasks = tasks, index >= 0, index < tasks.count else { return nil }
        return tasks[index]
    }
    
    func deleteAll() {
        taskRepository.deleteAllTasks()
    }
    
    func updateTaskCompletion(at indexPath: IndexPath, isCompleted: Bool) {
            var task = task(at: indexPath.row)
            task?.completed = isCompleted
            guard let updatedTask = task else { return }
            updateTask(at: indexPath, updatedTask: updatedTask)
    }
}

//MARK: - Private methods
extension TaskViewModel {
    private func isFirstLaunch() -> Bool {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        }
        return isFirstLaunch
    }

    private func loadTasksFromCoreData() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            let tasks = self.taskRepository.fetchTasksFromCoreData()
            DispatchQueue.main.async {
                self.allTasks = tasks
                self.tasks = tasks
            }
        }
    }

}
