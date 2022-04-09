//
//  AnimateEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import Foundation

struct AnimateEvent: Event {
    var timestamp: TimeInterval
    
    var entityID: EntityID
    
    private let kind: TextureFrame

    init(onEntityWith id: EntityID, to kind: TextureFrame) {
        timestamp = EventManager.timestamp
        entityID = id
        self.kind = kind
    }

    
    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        return
    }
    
    
}
