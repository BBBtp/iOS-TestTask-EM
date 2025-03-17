//
//  TaskCoordinator.swift
//  ToDoList
//
//  Created by Богдан Топорин on 17.03.2025.
//

import UIKit


protocol TaskCoordinatorDelegate: AnyObject {
    func showTaskDetail(task: TaskModel, isCreate: Bool, at indexPath: IndexPath?)
}

final class TaskCoordinator: TaskCoordinatorDelegate, TaskUpdateDelegate {
    
    let navigationController: UINavigationController
    private let taskViewModel: TaskViewModel
    private weak var taskListViewController: TaskListViewController?
    
    init(navigationController: UINavigationController, taskViewModel: TaskViewModel) {
        self.navigationController = navigationController
        self.taskViewModel = taskViewModel
    }
    
    func start() {
        let taskListVC = TaskListViewController(taskViewModel: taskViewModel, coordinator: self)
        taskListViewController = taskListVC
        navigationController.viewControllers = [taskListVC]
    }
    
    func showTaskDetail(task: TaskModel, isCreate: Bool, at indexPath: IndexPath?) {
        let detailViewModel = DetailViewModel(task: task)
        let detailVC = DetailViewController(taskDetailViewModel: detailViewModel, at: indexPath, isCreate: isCreate)
        detailVC.delegate = self
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func didCreateTask(task: TaskModel) {
        taskViewModel.addTask(task: task)
        navigationController.popViewController(animated: true)
    }
    
    func didUpdateTask(_ task: TaskModel?, at indexPath: IndexPath) {
        taskViewModel.updateTask(at: indexPath, updatedTask: task)
        navigationController.popViewController(animated: true)
    }
}
