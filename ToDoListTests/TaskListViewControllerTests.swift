import XCTest
@testable import ToDoList

class TaskListViewControllerTests: XCTestCase {
    
    var viewController: TaskListViewController!
    var viewModel: MockTaskViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = MockTaskViewModel(taskRepository: TaskRepository(apiClient: APIClient(), taskStore: TaskStore()))
        let coordinator = TaskCoordinator(navigationController: UINavigationController(), taskViewModel: viewModel)
        
        viewController = TaskListViewController(taskViewModel: viewModel, coordinator: coordinator)
        
        viewController.loadViewIfNeeded()
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(viewController.taskListView.tableView.dataSource)
    }
    
    func testDeleteTask() {
        let task = TaskModel(id: 1, title: "Test Task", todo: "Test Task", completed: false, userId: 1, createdAt: "")
        viewModel.addTask(task: task)
        
        let indexPath = IndexPath(row: 0, section: 0)
        viewController.didTapDeleteButton(at: indexPath)
        
        viewController.taskListView.tableView.reloadData()
        XCTAssertEqual(viewController.taskListView.tableView.numberOfRows(inSection: 0), 0)
    }
    
    func testAddTask() {
        let task = TaskModel(id: 1, title: "Test Task", todo: "Test Task", completed: false, userId: 1, createdAt: "")
        
        XCTAssertEqual(viewController.taskListView.tableView.numberOfRows(inSection: 0), 0)
        viewModel.addTask(task: task)
        viewController.taskListView.tableView.reloadData()
        XCTAssertEqual(viewController.taskListView.tableView.numberOfRows(inSection: 0), 1)
    }
}
