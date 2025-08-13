//
//  Task+Save.swift
//  PebblePath
//
//  Created by Yu-Shan Cheng on 8/12/25.
//

import Foundation

extension Task {
    func save() {
        var tasks = Task.loadAll()
        tasks.append(self)
        
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }
    
    static func loadAll() -> [Task] {
        if let data = UserDefaults.standard.data(forKey: "tasks"),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            return decoded
        }
        return []
    }
}
