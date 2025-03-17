import XCTest
@testable import ToDoList

class MockTaskViewModel: TaskViewModel {
    
    private var tasksTest: [TaskModel] = []
    
    override var numberOfTasks: Int {
        return tasksTest.count
    }
    
    override func addTask(task: TaskModel?) {
        tasksTest.append(task!)
    }
    
    override func deleteTask(at indexPath: IndexPath) {
        tasksTest.remove(at: indexPath.row)
    }
    
    func task(at indexPath: IndexPath) -> TaskModel? {
        return tasksTest[safe: indexPath.row]
    }
    
    override func deleteAll() {
        tasksTest.removeAll()
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class TaskViewModelTests: XCTestCase {
    
    var viewModel: MockTaskViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = MockTaskViewModel(taskRepository: TaskRepository(apiClient: APIClient(), taskStore: TaskStore()))
        viewModel.deleteAll()
    }
    
    func testNumberOfTasks() {
        XCTAssertEqual(viewModel.numberOfTasks, 0)
    }
    
    func testAddTask() {
        let task = TaskModel(id: 1, title: "Test Task", todo: "Test Task", completed: false, userId: 1, createdAt: "")
    
        viewModel.addTask(task: task)
    
        XCTAssertEqual(viewModel.numberOfTasks, 1)
    }
    
    func testDeleteTask() {
        let task = TaskModel(id: 1, title: "Test Task", todo: "Test Task", completed: false, userId: 1, createdAt: "")
        viewModel.addTask(task: task)
        
        XCTAssertEqual(viewModel.numberOfTasks, 1)
        viewModel.deleteTask(at: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(viewModel.numberOfTasks, 0)
    }
}
