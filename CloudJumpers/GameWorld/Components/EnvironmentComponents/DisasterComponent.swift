//
//  DisasterComponent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 1/4/22.
//

class DisasterComponent: Component {
    enum Kind: String, CaseIterable, Codable {
        case meteor

        var name: String { rawValue }
    }

    let kind: Kind

    init(_ kind: Kind) {
        self.kind = kind
        super.init()
    }
}