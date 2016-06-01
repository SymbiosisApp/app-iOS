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
        let unsafeBody = unsafeBitCast(body, UnsafeMutablePointer<Void>.self)
        CGPathApply(self, unsafeBody, callback)
    }
}

struct SYPathElement {
    let type: CGPathElementType;
    let points: [CGPoint];
    let startPoint: CGPoint;
    var length: Float = 0;
    var positions: [CGPoint] = [];
    var segmentsLength: [Float] = [];
    
    init(from startPoint: CGPoint, type: CGPathElementType, points: [CGPoint]) {
        self.type = type
        self.startPoint = startPoint
        self.points = points
        
        // Precompute
        let precision: Int = 100
        for i in 0..<precision {
            let t: CGFloat = CGFloat(Float(i)) / CGFloat(precision);
            self.positions.append(self.precomputeForT(t))
        }
        for (index, pos) in self.positions.enumerate() {
            if index == 0 {
                self.segmentsLength.append(0)
            } else {
                let lastPos = self.positions[index - 1]
                let dist = CGPointDistance(from: lastPos, to: pos)
                self.segmentsLength.append(Float(dist))
            }
        }
        // Find total length
        if self.type == CGPathElementType.MoveToPoint  {
            self.length = 0
        } else {
            for segment in self.segmentsLength {
                self.length += segment
            }
        }
    }
    
    func precomputeForT(t: CGFloat) -> CGPoint {
        switch (self.type) {
        case CGPathElementType.MoveToPoint:
            let p0 = self.points[0]
            let p1 = self.points[1]
            let x = p0.x + t * (p1.x - p0.x)
            let y = p0.y + t * (p1.y - p0.y)
            return CGPoint(x: x, y: y)
        case .AddLineToPoint:
            let p0 = self.points[0]
            let p1 = self.points[1]
            let x = p0.x + t * (p1.x - p0.x)
            let y = p0.y + t * (p1.y - p0.y)
            return CGPoint(x: x, y: y)
        case .AddQuadCurveToPoint:
            let p0 = self.points[0]
            let p1 = self.points[1]
            let p2 = self.points[2]
            let x = ((1 - t) * (1 - t)) * p0.x + 2 * (1 - t) * t * p1.x + t * t * p2.x
            let y = ((1 - t) * (1 - t)) * p0.y + 2 * (1 - t) * t * p1.y + t * t * p2.y
            return CGPoint(x: x, y: y)
        case .AddCurveToPoint:
            let p0 = self.points[0]
            let p1 = self.points[1]
            let p2 = self.points[2]
            let p3 = self.points[3]
            let x = ((1 - t) * (1 - t) * (1 - t)) * p0.x + 3 * (1 - t) * (1 - t) * t * p1.x + 3 * (1 - t) * t * t * p2.x + t * t * t * p3.x
            let y = ((1 - t) * (1 - t) * (1 - t)) * p0.y + 3 * (1 - t) * (1 - t) * t * p1.y + 3 * (1 - t) * t * t * p2.y + t * t * t * p3.y
            return CGPoint(x: x, y: y)
        case .CloseSubpath:
            return CGPoint(x: 0, y: 0)
        }
    }
    
    func valueAtTime(time: Float) -> CGPoint {
        if time < 0 || time > 1 {
            // If outbound compute the result
            return self.precomputeForT(CGFloat(time))
        }
        // Else use the precompute to match the correct length
        let targetLength: Float = self.length * time
        var currentLength: Float = 0
        var index = 0;
        while (currentLength + self.segmentsLength[index]) < targetLength {
            currentLength += self.segmentsLength[index]
            if index >= self.segmentsLength.count - 2 {
                break;
            } else {
                index += 1
            }
        }
        let pos = self.positions[index]
        let nextPos = self.positions[index + 1]
        var progress: Float = 0
        if self.segmentsLength[index] > 0 {
            progress = (targetLength - currentLength) / self.segmentsLength[index]
        }
        return CGPointLerp(from: pos, to: nextPos, progress: CGFloat(progress))
    }
    
}

class SYPath {
    
    let path: CGPath
    let elements: [SYPathElement]
    let length: Float
    
    init(withCGPath path: CGPath) {
        self.path = path
        var elements: [SYPathElement] = []
        var startPoint = CGPoint(x: 0, y: 0)
        var nextStartPoint = CGPoint(x: 0, y: 0)
        print("Gooo")
        self.path.forEach { element in
            print("loop")
            var points: [CGPoint] = []
            switch (element.type) {
            case CGPathElementType.MoveToPoint:
                // points.append(nextStartPoint)
                // points.append(element.points[0])
                // print("Move to")
                nextStartPoint = element.points[0]
            case .AddLineToPoint:
                print("=============")
                points.append(nextStartPoint)
                points.append(element.points[0])
                nextStartPoint = element.points[0]
            case .AddQuadCurveToPoint:
                points.append(nextStartPoint)
                points.append(element.points[0])
                points.append(element.points[1])
                nextStartPoint = element.points[0]
            case .AddCurveToPoint:
                print("Add Curve")
                points.append(nextStartPoint)
                points.append(element.points[0])
                points.append(element.points[1])
                points.append(element.points[2])
                nextStartPoint = element.points[2]
            case .CloseSubpath:
                nextStartPoint = CGPoint(x: 0, y: 0)
            }
            print(points)
            if element.type != CGPathElementType.MoveToPoint {
                elements.append(SYPathElement(from: startPoint, type: element.type, points: points))
            }
            startPoint = nextStartPoint
        }
        self.elements = elements
        
        print("------")
        for elem in elements {
            print(elem.points)
        }
        
        print(path)
        var totalLength: Float = 0
        for elem in self.elements {
            totalLength += elem.length
        }
        self.length = totalLength
    }

    func valueAtTime(time: Float) -> CGPoint {        
        let targetLength: Float = self.length * time
        var currentLength: Float = 0
        var index = 0;
        while (currentLength + self.elements[index].length) < targetLength {
            if index >= self.elements.count - 1 {
                break;
            } else {
                currentLength += self.elements[index].length
                index += 1
            }
        }
        let elem = self.elements[index]
        var subTime: Float = 0
        if elem.length > 0 {
            subTime = (targetLength - currentLength) / elem.length;
        }
        print("\(time) => \(index) & \(subTime)")
        let result = elem.valueAtTime(subTime)
        return result;
    }
    
}