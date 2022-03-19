//
//  GameModes.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 15/3/22.
//

import Foundation

enum GameModes: String {
    case TimeTrial = "Time Trial"
}

func urlSafeGameMode(mode: GameModes) -> String {
    mode.rawValue.components(separatedBy: .whitespaces).joined()
}
