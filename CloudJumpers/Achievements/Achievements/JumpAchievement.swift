//
//  JumpAchievement.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 16/4/22.
//

import Foundation

class JumpAchievement: Achievement {
    let userId: NetworkID

    let title: String = "Jumps"
    let description: String = "Lifetime jumps made across games."
    let metricKeys: [String] = ["jump"]

    weak var dataDelegate: AchievementDataDelegate?

    private var userJumps: Int?
    private let requiredJumps = 1_000

    var currentProgress: String? {
        if let jumps = userJumps {
            return String(jumps)
        }
        return nil
    }

    var requiredProgress: String { String(requiredJumps) }

    var isUnlocked: Bool {
        guard let jumps = userJumps else {
            return false
        }

        return jumps >= requiredJumps
    }

    required init(userId: NetworkID) {
        self.userId = userId
    }

    func load(_ key: String, _ value: Any) {
        guard let jumps = value as? Int else {
            return
        }

        assert(metricKeys.first == key)
        userJumps = jumps
    }
}
