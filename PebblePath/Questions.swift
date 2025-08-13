import Foundation

struct Question: Codable {
    let id: String
    let question: String
    let options: [String]
    let answerIndex: Int
    let explanation: String
    var isAnswered: Bool = false
    var isCorrect: Bool = false
}

   


enum QuestionStore {
    private static let key = "question_results_v1" // 儲存作答結果的 key

    // 載入 bundle 中的題庫 JSON
    static func loadBundledQuestions() -> [Question] {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return [] }
        return (try? JSONDecoder().decode([Question].self, from: data)) ?? []
    }

    // 合併歷史作答紀錄
    static func loadQuestionsMerged() -> [Question] {
        var qs = loadBundledQuestions()
        let results = loadResults()
        for i in qs.indices {
            if let correct = results[qs[i].id] {
                qs[i].isAnswered = true
                qs[i].isCorrect = correct
            }
        }
        return qs
    }

    // 儲存答題結果
    static func saveResult(for id: String, isCorrect: Bool) {
        var results = loadResults()
        results[id] = isCorrect
        if let data = try? JSONEncoder().encode(results) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    // 從 UserDefaults 載入答題紀錄
    private static func loadResults() -> [String: Bool] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let dict = try? JSONDecoder().decode([String: Bool].self, from: data)
        else { return [:] }
        return dict
    }
}

