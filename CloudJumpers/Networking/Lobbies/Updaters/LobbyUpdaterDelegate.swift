//
//  UpdaterDelegate.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 15/3/22.
//

protocol LobbyUpdaterDelegate: AnyObject {
    var managedLobby: NetworkedLobby? { get set }

    func createLobby(hostId: NetworkID, hostDisplayName: String)
    func joinLobby(userId: NetworkID, userDisplayName: String)
    func exitLobby(userId: NetworkID, deleteLobby: Bool)
    func toggleReady(userId: NetworkID)
}