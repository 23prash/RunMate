//
//  RunDataService.swift
//  RunMate
//
//  Created by Prashant Pukale on 2/14/22.
//

import Foundation
import OSLog

final class RunDataService {
    private var key = "user_info"
    func save(run: Run) {
        var runs = getAll()
        runs.insert(run, at: 0)
        save(runs: runs)
    }

    private func save(runs: [Run]) {
        do {
            let jsonData = try JSONEncoder().encode(runs)
            UserDefaults.standard.set(jsonData, forKey: key)
        } catch {
            print(error)
        }
    }

    func getAll() -> [Run] {
        do {
            guard let jsonData = UserDefaults.standard.data(forKey: key) else { return [] }
            let runs = try JSONDecoder().decode([Run].self, from: jsonData)
            return runs
        } catch {
            print(error)
        }
        return []
    }

    @discardableResult
    func deleteRuns(at indices: IndexSet) -> [Run] {
        var runs = getAll()
        runs.remove(atOffsets: indices)
        save(runs: runs)
        return runs
    }
}
