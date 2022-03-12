//
//  PlayerSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/12/22.
//

import Foundation

class PlayerSystem: System {
    
    weak var entitiesManager: EntitiesManager?
    
    private var entityComponentMapping: [Entity: PlayerComponent] = [:]

    
    init (entitiesManager: EntitiesManager) {
        self.entitiesManager = entitiesManager
    }
    
    func addComponent(entity: Entity, component: Component) {
        guard let playerComponent = component as? PlayerComponent else {
            return
        }
        entityComponentMapping[entity] = playerComponent
    }
    
    
    func update(_ deltaTime: Double) {
        for entity in entityComponentMapping.keys {
            // find contact here?
        }
    }
}

