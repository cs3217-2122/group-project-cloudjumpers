//
//  KingHillGameRules.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/15/22.
//

import Foundation

import CoreGraphics

class KingHillGameRules: GameRules {
    private static let gameDuration = 120.0
    private static let scoreBias: Double = 0.05 * scoreRatio
    private static let scoreRatio: Double = 0.035

    private unowned var target: RuleModifiable?

    private var timer: StaticLabel?
    private var scoreLabel: StaticLabel?
    private var playerScore: Double = .zero
    private var currentGameDuration = KingHillGameRules.gameDuration

    var playerInfo: PlayerInfo?

    func setTarget(_ target: RuleModifiable) {
        self.target = target
    }

    func setUpForRule() {
        guard let target = target else {
            return
        }
        let scoreLabel = StaticLabel(
            at: Positions.scoreLabel,
            typeface: .display,
            size: Dimensions.labelFontSize,
            text: "\(playerScore)")

        self.scoreLabel = scoreLabel
        target.add(scoreLabel)
        self.timer = setUpTimer(initialValue: Constants.timerInitial, to: target)
        enablePowerUpFunction(target: target)
    }

    func setUpPlayers(_ playerInfo: PlayerInfo, allPlayersInfo: [PlayerInfo]) {
        self.playerInfo = playerInfo
        for (index, info) in allPlayersInfo.enumerated() {
            let id = info.playerId
            let name = info.displayName
            let character: Entity

            if id == playerInfo.playerId {
                character = Player(
                    at: Positions.players[index],
                    texture: .Character1,
                    name: name,
                    with: id)
            } else {
                character = Guest(
                    at: Positions.players[index],
                    texture: .Character1,
                    name: name,
                    with: id)
            }
            target?.add(character)
        }
    }

    func enableHostSystems() {
        target?.activateSystem(ofType: PowerSpawnSystem.self)
        target?.activateSystem(ofType: DisasterSpawnSystem.self)
    }

    func update(within time: CGFloat) {
        guard let target = target else {
            return
        }

        updateGodStatusRule(target: target)
        updateRespawnIfPlayerOnSameCloudRule(target: target)
        updateRespawnIfPlayerOnSamePlatformRule(target: target)
        updateScoreRule(target: target)
        updateCountDownTimer(target: target)
    }

    private func updateCountDownTimer(target: RuleModifiable) {
        guard let timer = timer,
              let timedComponent = target.component(ofType: TimedComponent.self, of: timer)
        else {
            return
        }
        currentGameDuration = KingHillGameRules.gameDuration - timedComponent.time
        let timeString = currentGameDuration.minuteSeconds

        updateLabelWithValue(timeString, label: timer, target: target)
    }

    func hasGameEnd() -> Bool {
        currentGameDuration.isLess(than: 0)
    }

    func fetchLocalCompletionData() -> LocalCompletionData {
        guard let playerInfo = playerInfo,
              let metricsProvider = target as? MetricsProvider
        else { fatalError("Cannot get player data") }
        let metrics = metricsProvider.getMetricsSnapshot()

        return KingOfTheHillData(
            playerId: playerInfo.playerId,
            playerName: playerInfo.displayName,
            completionScore: playerScore,
            kills: metrics[String(describing: ExternalRespawnEvent.self)] ?? 0,
            deaths: metrics[String(describing: RespawnEvent.self)] ?? 0
        )
    }
}

// MARK: Specific Game Rules
extension KingHillGameRules {
    private func updateScoreRule(target: RuleModifiable) {
        guard let scoreLabel = scoreLabel,
              let playerID = playerInfo?.playerId,
              let playerPositionComponent = target.component(ofType: PositionComponent.self, of: playerID),
              let platform = target.components(ofType: TopPlatformTag.self).first?.entity,
              let platformPositionComponent = target.component(ofType: PositionComponent.self, of: platform.id),
              let worldHeight = target.components(ofType: AreaComponent.self).first?.size.height
        else {
            return
        }
        let distanceToTop = abs(playerPositionComponent.position.y - platformPositionComponent.position.y)

        let scoreModifier = (distanceToTop / worldHeight)
        var score = max(1 - scoreModifier, 0)
        score = score * KingHillGameRules.scoreRatio + KingHillGameRules.scoreBias

        playerScore += score
        updateLabelWithValue(String(format: "%.1f", playerScore), label: scoreLabel, target: target)
    }

    private func updateGodStatusRule(target: RuleModifiable) {
        guard let playerID = playerInfo?.playerId else {
            return
        }
        if isPlayerOnTopPlatform(target: target) {
            target.add(PromoteGodEvent(onEntityWith: playerID))
            target.activateSystem(ofType: GodPowerSpawnSystem.self)
        } else {
            target.add(DemoteGodEvent(onEntityWith: playerID))
            target.deactivateSystem(ofType: GodPowerSpawnSystem.self)
        }
    }
}
