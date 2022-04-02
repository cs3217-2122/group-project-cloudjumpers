//
//  DisasterStartEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 2/4/22.
//

import Foundation
import CoreGraphics

struct DisasterStartEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private var position: CGPoint
    private var velocity: CGVector
    private var disasterType: DisasterComponent.Kind

    init(position: CGPoint,
         velocity: CGVector,
         disasterType: DisasterComponent.Kind,
         playerId: EntityID) {
        timestamp = EventManager.timestamp
        entityID = playerId
        self.position = position
        self.velocity = velocity
        self.disasterType = disasterType
     }

    init(position: CGPoint,
         at timestamp: TimeInterval,
         velocity: CGVector,
         disasterType: DisasterComponent.Kind,
         playerId: EntityID) {
        entityID = playerId
        self.position = position
        self.timestamp = timestamp
        self.velocity = velocity
        self.disasterType = disasterType
     }

    func execute(in entityManager: EntityManager) -> [Event]? {
        let disasterPrompt = DisasterPrompt(disasterType, at: position)
        entityManager.add(disasterPrompt)

        let disaster = Disaster(disasterType, at: position, velocity: velocity)

        return [FadeEntityEvent(on: disasterPrompt, until: Constants.disasterPromptPeriod, fadeType: .fadeIn),
                RemoveEntityEvent(disasterPrompt, after: Constants.disasterPromptPeriod),
                ConditionalEvent(disaster, until: {
                    entityManager.entity(with: disasterPrompt.id) == nil
                }, action: {
                    entityManager.add(disaster)
                    return [RemoveUnboundEntityEvent(disaster)]
                })
                ]
    }
//    func getSharedCommand() -> GameEventCommand {
//        let onlineUpdate = OnlineDisasterEvent(
//            disasterPositionX: position.x,
//            disasterPositionY: position.y,
//            disasterVelocityX: velocity.dx,
//            disasterVelocityY: velocity.dy,
//            disasterType: disasterType.rawValue)
//        return DisasterStartEventCommand(sourceId: entityID, event: onlineUpdate)
//    }
}
