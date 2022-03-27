//
//  RepositionEvent.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 27/3/22.
//

import Foundation
import CoreGraphics

struct RepositionEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let nextPosition: CGPoint
    private let kind: Textures.Kind

    init(onEntityWith id: EntityID, at timestamp: TimeInterval, to nextPosition: CGPoint, as kind: Textures.Kind) {
        entityID = id
        self.timestamp = timestamp
        self.nextPosition = nextPosition
        self.kind = kind
    }

    func execute(in entityManager: EntityManager) {
        guard let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity),
              let animationComponent = entityManager.component(ofType: AnimationComponent.self, of: entity)
        else { return }

        spriteComponent.node.position = nextPosition
        animationComponent.kind = kind
    }
}