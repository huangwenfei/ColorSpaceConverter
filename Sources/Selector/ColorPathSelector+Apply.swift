//
//  ColorPathSelector+Apply.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

extension ColorPathSelector {
    
    #if false
    public static func applyRGBMatrix<RGB: RGBColorable>(var1: Element, var2: Element, var3: Element, rgbType: RGB.Type, isToRgb: Bool = true) -> (v1: Element, v2: Element, v3: Element) {
        
//        Applies an RGB working matrix to convert from XYZ to RGB.
//        The arguments are tersely named var1, var2, and var3 to allow for the
//        passing of XYZ _or_ RGB values. var1 is X for XYZ, and R for RGB. var2 and
//        var3 follow suit.
        
        /// - Tag: Retrieve the appropriate transformation matrix from the constants.
        let transMatrix = RGB.matrices(isToRgb: isToRgb)
        
        /// - Tag: Stuff the RGB/XYZ values into a NumPy matrix for conversion.
        let values = [var1, var2, var3]
        let valueM = values.count
        let valueN = 1
        
        let resultMatrix = Math.mul(
            mat1: transMatrix,
            mat2: .init(values: values, rows: .init(valueM), columns: .init(valueN))
        ).values

        /// - Tag: Clamp these values to a valid range.
        
        return (
            max(resultMatrix[0], 0),
            max(resultMatrix[1], 0),
            max(resultMatrix[2], 0)
        )
    }
    #else
    public static func applyRGBMatrix<RGB: RGBColorable>(fromXYZ xyz: [Element]) -> RGB {
        
        var rgb = RGB.init(array: xyz)
        
        /// - Tag: Retrieve the appropriate transformation matrix from the constants.
        let transMatrix = rgb.matrices(isToRgb: true)
        
        /// - Tag: Stuff the RGB/XYZ values into a NumPy matrix for conversion.
        let values = xyz
        let valueM = values.count
        let valueN = 1
        
        let resultMatrix = Math.mul(
            mat1: transMatrix,
            mat2: .init(values: values, rows: .init(valueM), columns: .init(valueN))
        ).values

        /// - Tag: Clamp these values to a valid range.
        
        rgb.red   = max(resultMatrix[0], 0)
        rgb.green = max(resultMatrix[1], 0)
        rgb.blue  = max(resultMatrix[2], 0)
        
        return rgb
        
    }
    
    public static func applyRGBMatrix<RGB: RGBColorable>(fromRGB rgb: RGB) -> XYZ {
        
        /// - Tag: Retrieve the appropriate transformation matrix from the constants.
        let transMatrix = rgb.matrices(isToRgb: false)
        
        /// - Tag: Stuff the RGB/XYZ values into a NumPy matrix for conversion.
        let values = rgb.elements
        let valueM = values.count
        let valueN = 1
        
        let resultMatrix = Math.mul(
            mat1: transMatrix,
            mat2: .init(values: values, rows: .init(valueM), columns: .init(valueN))
        ).values

        /// - Tag: Clamp these values to a valid range.
        
        return .init(
            x: max(resultMatrix[0], 0),
            y: max(resultMatrix[1], 0),
            z: max(resultMatrix[2], 0)
        )
        
    }
    #endif
    
}
