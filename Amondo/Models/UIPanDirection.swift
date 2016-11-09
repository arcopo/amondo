//
//  UIPanDirection.swift
//  Amondo
//
//  Created by James Bradley on 20/06/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

import Foundation
import UIKit

public enum Direction: String {
    case Up = "up"
    case Down = "down"
    case Left = "left"
    case Right = "right"
    
    public var isX: Bool { return self == .Left || self == .Right }
    public var isY: Bool { return !isX }
}

public extension UIPanGestureRecognizer {
    public var direction: Direction? {
        let velocity = velocityInView(view)
        let vertical = fabs(velocity.y) > fabs(velocity.x)
        switch (vertical, velocity.x, velocity.y) {
        case (true, _, let y) where y > 0: return .Down
        case (true, _, let y) where y < 0: return .Up
        case (false, let x, _) where x > 0: return .Right
        case (false, let x, _) where x < 0: return .Left
        default: return nil
        }
    }
}
