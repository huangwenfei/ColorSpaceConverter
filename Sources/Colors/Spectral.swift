//
//  Spectral.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public struct Spectral: SpectralColorableProtocol, ColorElement {
    
    // MARK: ColorProtocol
    public var colorSpace: ColorSpaceType { .Spectral }
    public var elementCount: Int { 50 }
    
    // MARK: Color Elements
    public var v_340nm: Element
    public var v_350nm: Element
    public var v_360nm: Element
    public var v_370nm: Element
    public var v_380nm: Element
    public var v_390nm: Element
    public var v_400nm: Element
    public var v_410nm: Element
    public var v_420nm: Element
    public var v_430nm: Element
    public var v_440nm: Element
    public var v_450nm: Element
    public var v_460nm: Element
    public var v_470nm: Element
    public var v_480nm: Element
    public var v_490nm: Element
    public var v_500nm: Element
    public var v_510nm: Element
    public var v_520nm: Element
    public var v_530nm: Element
    public var v_540nm: Element
    public var v_550nm: Element
    public var v_560nm: Element
    public var v_570nm: Element
    public var v_580nm: Element
    public var v_590nm: Element
    public var v_600nm: Element
    public var v_610nm: Element
    public var v_620nm: Element
    public var v_630nm: Element
    public var v_640nm: Element
    public var v_650nm: Element
    public var v_660nm: Element
    public var v_670nm: Element
    public var v_680nm: Element
    public var v_690nm: Element
    public var v_700nm: Element
    public var v_710nm: Element
    public var v_720nm: Element
    public var v_730nm: Element
    public var v_740nm: Element
    public var v_750nm: Element
    public var v_760nm: Element
    public var v_770nm: Element
    public var v_780nm: Element
    public var v_790nm: Element
    public var v_800nm: Element
    public var v_810nm: Element
    public var v_820nm: Element
    public var v_830nm: Element
    
    public var isUpscale: Bool = false
    
    public var illuminant: SpectralIlluminant = .default
    
    // MARK: Normal Init
    public init() {
        self.init(v_340nm: 0)
    }
    
    public init(
        v_340nm: Element = 0,
        v_350nm: Element = 0,
        v_360nm: Element = 0,
        v_370nm: Element = 0,
        v_380nm: Element = 0,
        v_390nm: Element = 0,
        v_400nm: Element = 0,
        v_410nm: Element = 0,
        v_420nm: Element = 0,
        v_430nm: Element = 0,
        v_440nm: Element = 0,
        v_450nm: Element = 0,
        v_460nm: Element = 0,
        v_470nm: Element = 0,
        v_480nm: Element = 0,
        v_490nm: Element = 0,
        v_500nm: Element = 0,
        v_510nm: Element = 0,
        v_520nm: Element = 0,
        v_530nm: Element = 0,
        v_540nm: Element = 0,
        v_550nm: Element = 0,
        v_560nm: Element = 0,
        v_570nm: Element = 0,
        v_580nm: Element = 0,
        v_590nm: Element = 0,
        v_600nm: Element = 0,
        v_610nm: Element = 0,
        v_620nm: Element = 0,
        v_630nm: Element = 0,
        v_640nm: Element = 0,
        v_650nm: Element = 0,
        v_660nm: Element = 0,
        v_670nm: Element = 0,
        v_680nm: Element = 0,
        v_690nm: Element = 0,
        v_700nm: Element = 0,
        v_710nm: Element = 0,
        v_720nm: Element = 0,
        v_730nm: Element = 0,
        v_740nm: Element = 0,
        v_750nm: Element = 0,
        v_760nm: Element = 0,
        v_770nm: Element = 0,
        v_780nm: Element = 0,
        v_790nm: Element = 0,
        v_800nm: Element = 0,
        v_810nm: Element = 0,
        v_820nm: Element = 0,
        v_830nm: Element = 0,
        illuminant: SpectralIlluminant = .default
    ) {
        self.v_340nm = v_340nm
        self.v_350nm = v_350nm
        self.v_360nm = v_360nm
        self.v_370nm = v_370nm
        self.v_380nm = v_380nm
        self.v_390nm = v_390nm
        self.v_400nm = v_400nm
        self.v_410nm = v_410nm
        self.v_420nm = v_420nm
        self.v_430nm = v_430nm
        self.v_440nm = v_440nm
        self.v_450nm = v_450nm
        self.v_460nm = v_460nm
        self.v_470nm = v_470nm
        self.v_480nm = v_480nm
        self.v_490nm = v_490nm
        self.v_500nm = v_500nm
        self.v_510nm = v_510nm
        self.v_520nm = v_520nm
        self.v_530nm = v_530nm
        self.v_540nm = v_540nm
        self.v_550nm = v_550nm
        self.v_560nm = v_560nm
        self.v_570nm = v_570nm
        self.v_580nm = v_580nm
        self.v_590nm = v_590nm
        self.v_600nm = v_600nm
        self.v_610nm = v_610nm
        self.v_620nm = v_620nm
        self.v_630nm = v_630nm
        self.v_640nm = v_640nm
        self.v_650nm = v_650nm
        self.v_660nm = v_660nm
        self.v_670nm = v_670nm
        self.v_680nm = v_680nm
        self.v_690nm = v_690nm
        self.v_700nm = v_700nm
        self.v_710nm = v_710nm
        self.v_720nm = v_720nm
        self.v_730nm = v_730nm
        self.v_740nm = v_740nm
        self.v_750nm = v_750nm
        self.v_760nm = v_760nm
        self.v_770nm = v_770nm
        self.v_780nm = v_780nm
        self.v_790nm = v_790nm
        self.v_800nm = v_800nm
        self.v_810nm = v_810nm
        self.v_820nm = v_820nm
        self.v_830nm = v_830nm
        self.isUpscale = false
        self.illuminant = illuminant
    }
    
}

extension Spectral {
    
    public func downable() -> Self {
        fatalError("Unimplement...")
    }
    
    public func uppable() -> Self {
        fatalError("Unimplement...")
    }
    
}

/// - Tag: SomeElementInit
extension Spectral: SomeElementInit {

    public init(array: [Element]) {
        self.init()
        let values: [Element]
        if array.count == elementCount {
            values = array
        } else {
            if array.count > elementCount {
                values = .init(array[0 ..< elementCount])
            } else {
                values = array + .init(repeatElement(Element(0), count: elementCount - array.count))
            }
        }
        v_340nm = values[0] ; v_350nm = values[1]
        v_360nm = values[2] ; v_370nm = values[3]
        v_380nm = values[4] ; v_390nm = values[5]
        v_400nm = values[6] ; v_410nm = values[7]
        v_420nm = values[8] ; v_430nm = values[9]
        v_440nm = values[10] ; v_450nm = values[11]
        v_460nm = values[12] ; v_470nm = values[13]
        v_480nm = values[14] ; v_490nm = values[15]
        v_500nm = values[16] ; v_510nm = values[17]
        v_520nm = values[18] ; v_530nm = values[19]
        v_540nm = values[20] ; v_550nm = values[21]
        v_560nm = values[22] ; v_570nm = values[23]
        v_580nm = values[24] ; v_590nm = values[25]
        v_600nm = values[26] ; v_610nm = values[27]
        v_620nm = values[28] ; v_630nm = values[29]
        v_640nm = values[30] ; v_650nm = values[31]
        v_660nm = values[32] ; v_670nm = values[33]
        v_680nm = values[34] ; v_690nm = values[35]
        v_700nm = values[36] ; v_710nm = values[37]
        v_720nm = values[38] ; v_730nm = values[39]
        v_740nm = values[40] ; v_750nm = values[41]
        v_760nm = values[42] ; v_770nm = values[43]
        v_780nm = values[44] ; v_790nm = values[45]
        v_800nm = values[46] ; v_810nm = values[47]
        v_820nm = values[48] ; v_830nm = values[49]
    }
    
    public init(iter elements: Element...) {
        self.init(array: elements)
    }
    
    public var elements: [Element] {
        [
            v_340nm, v_350nm,
            v_360nm, v_370nm,
            v_380nm, v_390nm,
            v_400nm, v_410nm,
            v_420nm, v_430nm,
            v_440nm, v_450nm,
            v_460nm, v_470nm,
            v_480nm, v_490nm,
            v_500nm, v_510nm,
            v_520nm, v_530nm,
            v_540nm, v_550nm,
            v_560nm, v_570nm,
            v_580nm, v_590nm,
            v_600nm, v_610nm,
            v_620nm, v_630nm,
            v_640nm, v_650nm,
            v_660nm, v_670nm,
            v_680nm, v_690nm,
            v_700nm, v_710nm,
            v_720nm, v_730nm,
            v_740nm, v_750nm,
            v_760nm, v_770nm,
            v_780nm, v_790nm,
            v_800nm, v_810nm,
            v_820nm, v_830nm
        ]
    }
    
}
