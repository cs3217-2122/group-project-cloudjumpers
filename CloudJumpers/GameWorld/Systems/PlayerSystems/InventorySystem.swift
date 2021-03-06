//
//  InventorySystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics

class InventorySystem: System {
    var active = true

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {
        guard let manager = manager else {
            return
        }

        for entity in manager.entities {
            guard let inventoryComponent = manager.component(ofType: InventoryComponent.self, of: entity),
                  inventoryComponent.inventory.isUpdated else {
                continue
            }
            inventoryComponent.inventory.isUpdated = false

            if manager.hasComponent(ofType: PlayerTag.self, in: entity) {
                updatePlayerInventory(inventoryComponent)
            } else {
                updateGuestInventory(inventoryComponent)
            }
        }
    }

    func dequeueItem(for id: EntityID) -> EntityID? {
        guard let entity = manager?.entity(with: id),
              let inventoryComponent = manager?.component(ofType: InventoryComponent.self, of: entity)
        else { return nil }
        return inventoryComponent.inventory.dequeue()

    }

    func enqueueItem(for id: EntityID, with powerUpId: EntityID) {
        guard let entity = manager?.entity(with: id),
              let inventoryComponent = manager?.component(ofType: InventoryComponent.self, of: entity),
              let ownerComponent = manager?.component(ofType: OwnerComponent.self, of: powerUpId),
              ownerComponent.ownerEntityId == nil
        else { return }

        ownerComponent.ownerEntityId = id
        inventoryComponent.inventory.enqueue(powerUpId)
    }

    private func updatePlayerInventory(_ inventoryComponent: InventoryComponent) {
        guard let manager = manager else {
            return
        }

        var position = Positions.initialPowerUpQueue
        var displayCount = 0

        for entityID in inventoryComponent.inventory.iterable {
            guard let entity = manager.entity(with: entityID),
                  let positionComponent = manager.component(ofType: PositionComponent.self, of: entity),
                  let spriteComponent = manager.component(ofType: SpriteComponent.self, of: entity)
            else { continue }

            removeTimerComponent(from: entity)

            guard displayCount <= Constants.PowerUps.powerUpMaxNumDisplay else {
                spriteComponent.alpha = 0
                continue
            }

            displayCount += 1

            positionComponent.position = position
            spriteComponent.alpha = 1
            manager.addComponent(CameraStaticTag(), to: entity)

            position.x += Constants.PowerUps.powerUpQueueXInterval
        }
    }

    private func updateGuestInventory(_ inventoryComponent: InventoryComponent) {
        guard let manager = manager else {
            return
        }

        for entityID in inventoryComponent.inventory.iterable {
            guard let entity = manager.entity(with: entityID),
                  let spriteComponent = manager.component(ofType: SpriteComponent.self, of: entity)
            else { continue }

            removeTimerComponent(from: entity)
            spriteComponent.alpha = 0

        }
    }

    private func removeTimerComponent(from entity: Entity) {
        guard let manager = manager else {
            return
        }

        manager.removeComponent(ofType: TimedComponent.self, from: entity)
        manager.removeComponent(ofType: TimedRemovalComponent.self, from: entity)
    }
}
