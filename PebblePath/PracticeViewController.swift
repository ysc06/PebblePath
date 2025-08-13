import UIKit

class PracticeViewController: UIViewController {
    @IBOutlet weak var optionButton4: UIButton!
    @IBOutlet weak var optionButton3: UIButton!
    @IBOutlet weak var optionButton2: UIButton!
    @IBOutlet weak var optionButton1: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    var questions: [Question] = []
    var currentQuestionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questions = loadQuestions()
        print("✅ PracticeViewController loaded with \(questions.count) questions")
        showQuestion()
    }
    
    func showQuestion() {
        guard !questions.isEmpty else { return }
        let current = questions[currentQuestionIndex]
        questionLabel.text = current.question
        
        optionButton1.setTitle(current.options[0], for: .normal)
        optionButton2.setTitle(current.options[1], for: .normal)
        optionButton3.setTitle(current.options[2], for: .normal)
        optionButton4.setTitle(current.options[3], for: .normal)
    }
    
    func loadQuestions() -> [Question] {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            print("❌ Could not find questions.json")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let questions = try JSONDecoder().decode([Question].self, from: data)
            print("✅ Loaded \(questions.count) questions")
            return questions
        } catch {
            print("❌ JSON decode failed: \(error)")
            return []
        }
    }

    @IBAction func optionTapped(_ sender: UIButton) {
        let selectedIndex = sender.tag
        let current = questions[currentQuestionIndex]
        
        var title: String
        if selectedIndex == current.answerIndex {
            title = "✅ Correct!"
            questions[currentQuestionIndex].isCorrect = true
        } else {
            title = "Try again!"
            questions[currentQuestionIndex].isCorrect = false
        }
        questions[currentQuestionIndex].isAnswered = true
        
        var message = current.explanation
       
        
        showFeedbackAlert(title: title, message: message)
    }
    
    func showFeedbackAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.goToNextQuestion()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func goToNextQuestion() {
        // ✅ 存成任務
        saveTask(title: questions[currentQuestionIndex].question, date: Date())

        currentQuestionIndex += 1
        if currentQuestionIndex < questions.count {
            showQuestion()
        } else {
            let finishedAlert = UIAlertController(
                title: "🎉 Quiz Finished",
                message: "You have completed all questions.",
                preferredStyle: .alert
            )
            finishedAlert.addAction(UIAlertAction(title: "OK", style: .default))
            present(finishedAlert, animated: true)
        }
    }

    // ✅ 用 Task 模型存檔
    func saveTask(title: String, date: Date) {
        let task = Task(title: title, dueDate: date, isComplete: true)
        task.save() // 用 Task struct 的 extension 存到 UserDefaults
        print("✅ Saved task from quiz: \(title)")
    }

}

