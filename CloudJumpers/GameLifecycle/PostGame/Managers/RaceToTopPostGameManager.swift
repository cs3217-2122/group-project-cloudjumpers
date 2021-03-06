//
//  RaceToTopManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 1/4/22.
//

import Foundation

class RaceToTopPostGameManager: PostGameManager {
    private let completionData: RaceToTopData
    private let endpointKey: String

    private var requestHandler: PostGameRequestDelegate?
    var callback: PostGameCallback = nil

    private(set) var rankings: [IndividualRanking] = [IndividualRanking]()

    private var endpoint: String {
        baseUrl + endpointKey
    }

    init(_ completionData: RaceToTopData, _ endpointKey: String) {
        self.completionData = completionData
        self.endpointKey = endpointKey
        self.requestHandler = PostGameRestDelegate()
        self.requestHandler?.postGameManager = self
    }

    func submitForRanking() {
        var data = [String: Any]()
        data["userId"] = completionData.playerId
        data["userDisplayName"] = completionData.playerName
        data["completionTime"] = completionData.completionTime
        data["kills"] = completionData.kills
        data["deaths"] = completionData.deaths

        requestHandler?.submitLocalData(endpoint, data)
    }

    func subscribeToRankings() {
        requestHandler?.startRankingsFetch(endpoint, handleRankingsResponse)
    }

    func unsubscribeFromRankings() {
        requestHandler?.stopRankingsFetch()
    }

    private func handleRankingsResponse(_ data: Data) {
        let decoder = JSONDecoder()

        guard let response = try? decoder.decode(RaceToTopResponses.self, from: data) else {
            return
        }

        rankings.removeAll()
        response.topLobbyPlayers.forEach { item in
            let completionTimeString = String(format: "%.2f", item.completionTime)

            var rankingRow = IndividualRanking()

            rankingRow.setPrimaryField(colName: "Position", value: item.position)
            rankingRow.setPrimaryField(colName: "Name", value: item.userDisplayName)
            rankingRow.setPrimaryField(colName: "Completion Time", value: completionTimeString)
            rankingRow.setPrimaryField(colName: "Kills", value: item.kills)
            rankingRow.setPrimaryField(colName: "Deaths", value: item.deaths)

            if completionData.playerId == item.userId {
                rankingRow.setSupportingField(colName: PGKeys.isUserRow, value: true)
            }

            rankings.append(rankingRow)
        }

        DispatchQueue.main.async { [weak self] in
            self?.callback?()
        }
    }
}
