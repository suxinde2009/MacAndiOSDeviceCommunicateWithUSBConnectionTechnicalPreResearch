//
//  MouseController.swift
//  MacClient
//
//  Created by SuXinDe on 2018/8/18.
//  Copyright © 2018年 su xinde. All rights reserved.
//

import Cocoa

final class MouseController {
    static let sharedInstanced = MouseController()
    private init() {}
    
    private var pos = CGPoint(x: 0, y: 0)
    
    static func moveTo(x: Int, y: Int) {
        sharedInstanced.pos.x = CGFloat(x)
        sharedInstanced.pos.y = CGFloat(y)
        let moveEvent = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: sharedInstanced.pos, mouseButton: .left)
        moveEvent?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    
    static func dragTo(x: Int, y: Int) {
        sharedInstanced.pos.x = CGFloat(x)
        sharedInstanced.pos.y = CGFloat(y)
        let moveEvent = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDragged, mouseCursorPosition: sharedInstanced.pos, mouseButton: .left)
        moveEvent?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    
    static func mouseDown() {
        let moveEvent = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition: sharedInstanced.pos, mouseButton: .left)
        moveEvent?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    
    static func mouseUp() {
        let moveEvent = CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: sharedInstanced.pos, mouseButton: .left)
        moveEvent?.post(tap: CGEventTapLocation.cghidEventTap)
    }
}
