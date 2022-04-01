//
//  TimedComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 24/3/22.
//

class TimedComponent: Component {
    var time: Double

    init(time: Double = .zero) {
        self.time = time
        super.init()
    }
}
