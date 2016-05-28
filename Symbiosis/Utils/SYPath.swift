//
//  PathAtTime.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 27/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation

extension CGPath {
    func forEach(@noescape body: @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        func callback(info: UnsafeMutablePointer<Void>, element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, Body.self)
            body(element.memory)
        }
        print(sizeofValue(body))
        let unsafeBody = unsafeBitCast(body, UnsafeMutablePointer<Void>.self)
        CGPathApply(self, unsafeBody, callback)
    }
}

struct SYPathElement {
    let type: CGPathElementType;
    let points: [CGPoint];
    let startPoint: CGPoint;
    var length: Float = 0;
    
    init(from startPoint: CGPoint, type: CGPathElementType, points: [CGPoint]) {
        self.type = type
        self.startPoint = startPoint
        self.points = points
    }
    
}

class SYPath {
    
    let path: CGPath
    let elements: [SYPathElement]
    
    init(withCGPath path: CGPath) {
        self.path = path
        var elements: [SYPathElement] = []
        var startPoint = CGPoint(x: 0, y: 0)
        var nextStartPoint = CGPoint(x: 0, y: 0)
        self.path.forEach { element in
            var points: [CGPoint] = []
            switch (element.type) {
            case CGPathElementType.MoveToPoint:
                points.append(element.points[0])
                nextStartPoint = element.points[0]
            case .AddLineToPoint:
                points.append(element.points[0])
                nextStartPoint = element.points[0]
            case .AddQuadCurveToPoint:
                points.append(element.points[0])
                points.append(element.points[1])
                nextStartPoint = element.points[0]
            case .AddCurveToPoint:
                points.append(element.points[0])
                points.append(element.points[1])
                points.append(element.points[2])
                nextStartPoint = element.points[0]
            case .CloseSubpath:
                nextStartPoint = CGPoint(x: 0, y: 0)
            }
            elements.append(SYPathElement(from: startPoint, type: element.type, points: points))
            startPoint = nextStartPoint
        }
        self.elements = elements
        
    }

}