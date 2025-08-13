import UIKit

struct Task: Codable, Equatable {
    var title: String
    var note: String?
    var dueDate: Date
    var isComplete: Bool {
        didSet {
            if isComplete {
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }
    
    private(set) var completedDate: Date?
    private(set) var createdDate: Date = Date()
    private(set) var id: String = UUID().uuidString
    
    init(title: String, note: String? = nil, dueDate: Date = Date(), isComplete: Bool = false) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
        self.isComplete = isComplete
    }
}

// MARK: - 儲存到 UserDefaults
extension Task {
    static var tasksKey: String { return "Tasks" }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func save(_ tasks: [Task]) {
        let defaults = UserDefaults.standard
        if let encodedData = try? JSONEncoder().encode(tasks) {
            defaults.set(encodedData, forKey: tasksKey)
            print("✅ Saved \(tasks.count) tasks")
        }
    }
    
    static func getTasks() -> [Task] {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: tasksKey),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: data) {
            return decodedTasks
        }
        return []
    }
    
    func save() {
        var tasks = Task.getTasks()
        tasks.removeAll { $0 == self }
        tasks.append(self)
        Task.save(tasks)
    }
}

