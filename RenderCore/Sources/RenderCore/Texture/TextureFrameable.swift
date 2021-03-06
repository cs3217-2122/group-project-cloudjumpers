//
//  TextureFrameable.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

public protocol TextureFrameable {
    var setName: TextureSetName { get }
    var frameName: TextureName { get }
}

extension TextureFrameable {
    public var frame: TextureFrame {
        TextureFrame(from: setName, frameName)
    }
}
