//
//  TaskListViewController.swift
//

import UIKit

class TaskListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLabel: UILabel!

    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Review Your Items"

        // Hide top cell separator
        tableView.tableHeaderView = UIView()

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshTasks()
    }

    @IBAction func didTapNewTaskButton(_ sender: Any) {
        performSegue(withIdentifier: "ComposeSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ComposeSegue" {
            if let composeNavController = segue.destination as? UINavigationController,
               let composeViewController = composeNavController.topViewController as? TaskComposeViewController {

                composeViewController.taskToEdit = sender as? Task

                composeViewController.onComposeTask = { [weak self] task in
                    task.save()
                    self?.refreshTasks()
                }
            }
        }
    }

    private func refreshTasks() {
        var tasks = Task.getTasks()
        tasks.sort { lhs, rhs in
            if lhs.isComplete && rhs.isComplete {
                return (lhs.completedDate ?? .distantPast) < (rhs.completedDate ?? .distantPast)
            } else if !lhs.isComplete && !rhs.isComplete {
                return lhs.createdDate < rhs.createdDate
            } else {
                return !lhs.isComplete && rhs.isComplete
            }
        }
        self.tasks = tasks
        emptyStateLabel.isHidden = !tasks.isEmpty
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

// MARK: - Table View Data Source
extension TaskListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]
        cell.configure(with: task, onCompleteButtonTapped: { [weak self] toggledTask in
            toggledTask.save()
            self?.refreshTasks()
        })
        return cell
    }

    // Modern swipe-to-delete
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self = self else { return }
            self.tasks.remove(at: indexPath.row)
            Task.save(self.tasks)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - Table View Delegate
extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let selectedTask = tasks[indexPath.row]
        performSegue(withIdentifier: "ComposeSegue", sender: selectedTask)
    }
}

