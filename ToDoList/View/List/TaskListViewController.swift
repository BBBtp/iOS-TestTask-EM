// TaskListViewController.swift
// ToDoList
//
// Created by Богдан Топорин on 16.01.2025.
//

import UIKit
import SkeletonView

final class TaskListViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let taskViewModel: TaskViewModel
    let taskListView: TaskListView
    private var coordinator: TaskCoordinator?
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: - Initializer
    
    init(taskViewModel: TaskViewModel,coordinator: TaskCoordinator) {
        self.taskViewModel = taskViewModel
        self.taskListView = TaskListView()
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = taskListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        taskViewModel.fetchTasks()
        bind()
        taskListView.tableView.dataSource = self
        taskListView.countTaskTableView.dataSource = self
        taskListView.tableView.delegate = self
        taskListView.countTaskTableView.delegate = self
    }
    
    // MARK: - Private methods
    
    private func configureNavigationBar() {
        navigationItem.title = L.tasksTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = A.Colors.whiteDynamic.color
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: A.Colors.blackDynamic.color,
        ]
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = L.search
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.tintColor = A.Colors.blackDynamic.color
    }
    
    private func bind() {
        taskViewModel.onTaskListLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.taskListView.tableView.reloadData()
                self?.taskListView.countTaskTableView.reloadData()
            }
        }
        taskViewModel.onTaskListLoadedError = { [weak self] error in
            DispatchQueue.main.async {
                preconditionFailure(error)
            }
        }
    }
    
    func deleteTask(at indexPath: IndexPath) {
        taskViewModel.deleteTask(at: indexPath)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case taskListView.tableView:
            return taskViewModel.numberOfTasks
        case taskListView.countTaskTableView:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case taskListView.tableView:
            let cell: TaskTableViewCell = tableView.dequeueReusableCell()
            if let task = taskViewModel.task(at: indexPath.row) {
                cell.configCell(model: task, at: indexPath)
                cell.delegate = self
            }
            return cell
        case taskListView.countTaskTableView:
            let cell: TaskCountTableViewCell = tableView.dequeueReusableCell()
            cell.config(with: taskViewModel.numberOfTasks)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UISearchResultsUpdating

extension TaskListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        taskViewModel.filterTasks(with: searchController.searchBar.text)
    }
}

extension TaskListViewController: TaskStoreDelegate {
    func didUpdate(_ update: TaskStoreUpdate) {
        taskListView.tableView.performBatchUpdates({
            if !update.deletedIndexes.isEmpty {
                taskListView.tableView.deleteRows(at: update.deletedIndexes, with: .automatic)
            }
            if !update.deletedSections.isEmpty {
                taskListView.tableView.deleteSections(IndexSet(update.deletedSections), with: .automatic)
            }
            if !update.insertedSections.isEmpty {
                taskListView.tableView.insertSections(IndexSet(update.insertedSections), with: .automatic)
            }
            if !update.insertedIndexes.isEmpty {
                taskListView.tableView.insertRows(at: update.insertedIndexes, with: .automatic)
            }
            if !update.updatedIndexes.isEmpty {
                taskListView.tableView.reloadRows(at: update.updatedIndexes, with: .automatic)
            }
            for move in update.movedIndexes {
                taskListView.tableView.moveRow(at: move.from, to: move.to)
            }
        }, completion: nil)
    }
}

// MARK: - TaskCellDelegate
extension TaskListViewController: TaskCellDelegate {
    func didTapShare(at indexPath: IndexPath) {
        guard let task = taskViewModel.task(at: indexPath.row) else { return }
        let shareText = """
           Задача: \(task.title ?? "Без названия")
           Описание: \(task.todo)
           Дата: \(task.createdAt ?? "Без даты")
           """
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    func didTapTaskCell(at indexPath: IndexPath) {
        guard let task = taskViewModel.task(at: indexPath.row) else { return }
        coordinator?.showTaskDetail(task: task, isCreate: false, at: indexPath)
    }
    
    func didTapStatusButton(at indexPath: IndexPath) {
        guard let task = taskViewModel.task(at: indexPath.row) else { return }
        taskViewModel.updateTaskCompletion(at: indexPath, isCompleted: !task.completed)
        DispatchQueue.main.async {
            self.taskListView.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func didTapDeleteButton(at indexPath: IndexPath) {
        deleteTask(at: indexPath)
    }
}

// MARK: - TaskCountTableViewCellDelegate
extension TaskListViewController: TaskCountTableViewCellDelegate {
    func didCreateTask() {
        let task = taskViewModel.getEmptyTask()
        coordinator?.showTaskDetail(task: task, isCreate: true,at: nil)
    }
}

