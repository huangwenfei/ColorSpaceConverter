//
//  ColorPathSelector+xyY.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

extension ColorPathSelector {
    public struct xyYSelector {
        
        public static let selectors: ColorPathSelector.SelectorDict = [
            toXYZ.pathId: toXYZ
        ]
        
        public static let toXYZ: PathConverter = .init( .xyY ==> .XYZ ) {
            .init( Self.toXYZ(color: ($0.base as! xyY), infos: $1) )
        }

    }
}

extension ColorPathSelector.xyYSelector {
    
    public static func toXYZ(color: xyY, infos: [AnyHashable: Any]?) -> XYZ {
        
        let color = color.downable()
        
        /// - Tag: avoid division by zero
        let x: XYZ.Element
        let y: XYZ.Element
        let z: XYZ.Element
        
        if color.y == 0 {
            x = 0
            y = 0
            z = 0
        } else {
            x = (color.x * color.Y) / color.y
            y = color.Y
            z = ((1 - color.x - color.y) * y) / color.y
        }

        return .init(
            x: x, y: y, z: z, illuminant: color.illuminant
        )
    
    }
    
}
