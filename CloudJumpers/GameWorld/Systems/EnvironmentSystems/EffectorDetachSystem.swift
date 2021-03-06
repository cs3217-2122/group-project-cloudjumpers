//
//  EffectorDetachSystem.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//

import CoreGraphics
import ContentGenerator

class EffectorDetachSystem: System {
    var active = false

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    var positionsTemplate: PositionsTemplate?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {}

    func shouldDetach(watchingEntity effectEntity: Entity) -> Bool {
        manager?.component(ofType: TimedComponent.self, of: effectEntity) == nil
    }
}
