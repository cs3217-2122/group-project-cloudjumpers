//
//  JoystickUpdateEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/16/22.
//

import Foundation
import CoreGraphics

struct JoystickUpdateEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    let displacement: CGVector

    init( displacement: CGVector, at timestamp: TimeInterval = EventManager.timestamp) {
        self.timestamp = timestamp
        self.entityID = EntityID()
        self.displacement = displacement
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let playerSystem = target.system(ofType: PlayerStateSystem.self),
              let player = playerSystem.getPlayerEntity(),
              let physicsSystem = target.system(ofType: PhysicsSystem.self)
        else {
            return
        }

        // Caution: this means displacement can be zero
        let moveEvent = MoveEvent(onEntityWith: player.id, by: displacement)
        supplier.add(moveEvent)

        // Update to idle or walking animation based on state
        if displacement != .zero && !physicsSystem.isMoving(player.id) {
            let walkingAnimateEvent = AnimateEvent(onEntityWith: player.id, to: CharacterFrames.walking.key)
            let soundEvent = SoundEvent(.walking)
            supplier.add(walkingAnimateEvent.then(do: soundEvent))
        } else if !physicsSystem.isMoving(player.id) {
            let idleAnimateEvent = AnimateEvent(onEntityWith: player.id, to: CharacterFrames.idle.key)
            supplier.add(idleAnimateEvent)
        }
    }
}
