//
//  ColorPath.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

import AlgorithmX

public protocol ConverterFunc {
    
    func convert(from: AnyColorable, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> AnyColorable
    
}

public struct PathId: Hashable, CustomStringConvertible {
    public var from: ColorSpaceType
    public var to: ColorSpaceType
    
    public var description: String {
        "\(from) --> \(to)"
    }
    
    public init(from: ColorSpaceType, to: ColorSpaceType) {
        self.from = from
        self.to = to
    }
    
    public var isVaild: Bool {
        from != to
    }
    
}

infix operator ==> : AdditionPrecedence
internal func ==> (from: ColorSpaceType, to: ColorSpaceType) -> PathId {
    .init(from: from, to: to)
}

public struct PathConverter: ConverterFunc, Hashable, CustomStringConvertible {
    
    public private(set) var pathId: PathId
    
    public typealias Selector = ColorPathConverterSelector.Selector
    public private(set) var converter: Selector
    
    public var description: String {
        pathId.description + " \(String(describing: converter))"
    }
    
    public init(from: ColorSpaceType, to: ColorSpaceType, converter: @escaping Selector) {
        self.pathId = .init(from: from, to: to)
        self.converter = converter
    }
    
    public init(pathId: PathId, converter: @escaping Selector) {
        self.pathId = pathId
        self.converter = converter
    }
    
    public init(_ pathId: PathId, converter: @escaping Selector) {
        self.pathId = pathId
        self.converter = converter
    }
    
    public func convert<Light>(from: AnyColorable, illuminant: Light?, infos: [AnyHashable: Any]?) -> AnyColorable where Light: IlluminantProtocol {
        guard pathId.isVaild else { return from }
        
        var infos = infos
        if let illuminant = illuminant {
            if infos == nil { infos = [:] }
            infos?["\(Light.self)"] = illuminant
        }
        
        return converter(from, infos)
    }
    
    /// - Tag: Equlable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.pathId == rhs.pathId
    }
    
    /// - Tag: Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(pathId)
    }
}

/// Gen [Left -> Right] Color Path, Result: Left -> ... -> Right
public struct ColorPath {
    
    public private(set) var pathId: PathId
    
    public typealias Vertex = ColorSpaceType
    public static var graph = graphCreator()
    
    public init<To: Colorable>(from: ColorSpaceType, to: To.Type) {
        self.pathId = .init(from: from, to: .init(color: to))
    }
    
    public init<From: Colorable, To: Colorable>(from: From.Type, to: To.Type) {
        self.pathId = .init(from: .init(color: from), to: .init(color: to))
    }
    
    public func generate() -> [PathConverter] {
        converters(pathId: pathId)
    }
    
    public func generate(througthRGB rgb: ColorSpaceType.RGB) -> [PathConverter] {
        
        /// - Tag: From === To
        guard pathId.isVaild else { return [] }
        
        /// - Tag: From ==> To, Ignore througthRGB
        if pathId.from.isRgb || pathId.to.isRgb {
            return converters(pathId: pathId)
        }
        
        /// - Tag: From ==> througthRGB ==> To
        
        /// from ==> rgb
        let fromToRgb = converters(pathId: pathId.from ==> rgb.colorSpace)
        // print(fromToRgb)
        /// rgb ==> to
        let rgbToTo = converters(pathId: rgb.colorSpace ==> pathId.to)
        // print(rgbToTo)
        return fromToRgb + rgbToTo
    }
    
}

extension ColorPath {
    
    private func converters(pathId: PathId) -> [PathConverter] {
        guard pathId.isVaild else { return [] }
        
        if let path = ColorPathConverterSelector.selectors[pathId] {
            return [path]
        }
        
        if let paths = ColorPathConverterSelector.rgbSelectors[pathId] {
            return paths
        }
        
        guard
            let path = Self.graph.bidirectionalShortestPath(
                begin: pathId.from, end: pathId.to
        ) else {
            return []
        }

        return path.edgeInfos.map { $0.weight.converter }

    }
    
}

extension ColorPath {
    
    public struct Weight: ListGraphWeightable, CustomStringConvertible {

        public var weight: Int
        public var converter: PathConverter!
        
        public var description: String {
            weight.description
          + " "
          + (converter == nil ? "None" : converter.description)
        }
        
        /// for path calculate
        public init(weight: Int) {
            self.weight = weight
            self.converter = nil
        }
        
        /// real init
        public init(converter: PathConverter) {
            self.weight = 1
            self.converter = converter
        }
        
        /// Tag: GraphWeight
        public static var zero: Self { .init(weight: 0) }
        
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.weight < rhs.weight
        }
        
        public static func + (lhs: Self, rhs: Self) -> Self {
            .init(weight: lhs.weight + rhs.weight)
        }
        
        public static func - (lhs: Self, rhs: Self) -> Self {
            .init(weight: lhs.weight - rhs.weight)
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.weight == rhs.weight
        }
        
    }
    
}

extension ColorPath {
    
    private static func graphCreator() -> ListDigraph<Vertex, Weight> {
        
        var graph: ListDigraph<Vertex, Weight> = .init()
        
        typealias Selector = ColorPathConverterSelector
        func selector(_ pathId: PathId) -> Weight {
            .init(converter: Selector.selectors[pathId]!)
        }
        
        func addEdge(byFrom from: Vertex, to: Vertex) {
            graph.add(
                edgeByFrom: from, to: to,
                weight: selector(from ==> to)
            )
        }
        
        addEdge(byFrom: .Spectral, to: .XYZ)
        
        addEdge(byFrom: .Lab, to: .LCHab)
        addEdge(byFrom: .Lab, to: .XYZ)
        
        addEdge(byFrom: .Luv, to: .LCHuv)
        addEdge(byFrom: .Luv, to: .XYZ)
        
        addEdge(byFrom: .LCHab, to: .Lab)
        addEdge(byFrom: .LCHuv, to: .Luv)
        
        addEdge(byFrom: .xyY, to: .XYZ)
        addEdge(byFrom: .XYZ, to: .xyY)
        
        addEdge(byFrom: .XYZ, to: .Luv)
        addEdge(byFrom: .XYZ, to: .Lab)
        addEdge(byFrom: .XYZ, to: .sRGB)
        addEdge(byFrom: .XYZ, to: .AppleRGB)
        addEdge(byFrom: .XYZ, to: .AdobeRGB)
        addEdge(byFrom: .XYZ, to: .BT2020RGB)
        addEdge(byFrom: .XYZ, to: .IPT)
        
        addEdge(byFrom: .sRGB, to: .XYZ)
        addEdge(byFrom: .AppleRGB, to: .XYZ)
        addEdge(byFrom: .AdobeRGB, to: .XYZ)
        addEdge(byFrom: .BT2020RGB, to: .XYZ)
        
        addEdge(byFrom: .sRGB, to: .HSV)
        addEdge(byFrom: .AppleRGB, to: .HSV)
        addEdge(byFrom: .AdobeRGB, to: .HSV)
        addEdge(byFrom: .BT2020RGB, to: .HSV)
        
        addEdge(byFrom: .sRGB, to: .HSL)
        addEdge(byFrom: .AppleRGB, to: .HSL)
        addEdge(byFrom: .AdobeRGB, to: .HSL)
        addEdge(byFrom: .BT2020RGB, to: .HSL)
        
        addEdge(byFrom: .sRGB, to: .CMY)
        addEdge(byFrom: .AppleRGB, to: .CMY)
        addEdge(byFrom: .AdobeRGB, to: .CMY)
        addEdge(byFrom: .BT2020RGB, to: .CMY)
        
        addEdge(byFrom: .sRGB, to: .Hex)
        addEdge(byFrom: .AppleRGB, to: .Hex)
        addEdge(byFrom: .AdobeRGB, to: .Hex)
        addEdge(byFrom: .BT2020RGB, to: .Hex)
        
        addEdge(byFrom: .Hex, to: .sRGB)
        addEdge(byFrom: .Hex, to: .AppleRGB)
        addEdge(byFrom: .Hex, to: .AdobeRGB)
        addEdge(byFrom: .Hex, to: .BT2020RGB)
        
        addEdge(byFrom: .HSV, to: .sRGB)
        addEdge(byFrom: .HSV, to: .AppleRGB)
        addEdge(byFrom: .HSV, to: .AdobeRGB)
        addEdge(byFrom: .HSV, to: .BT2020RGB)
        
        addEdge(byFrom: .HSL, to: .sRGB)
        addEdge(byFrom: .HSL, to: .AppleRGB)
        addEdge(byFrom: .HSL, to: .AdobeRGB)
        addEdge(byFrom: .HSL, to: .BT2020RGB)
        
        addEdge(byFrom: .CMY, to: .sRGB)
        addEdge(byFrom: .CMY, to: .AppleRGB)
        addEdge(byFrom: .CMY, to: .AdobeRGB)
        addEdge(byFrom: .CMY, to: .BT2020RGB)
        
        addEdge(byFrom: .CMY, to: .CMYK)
        addEdge(byFrom: .CMYK, to: .CMY)
        
        addEdge(byFrom: .IPT, to: .XYZ)
        
        return graph
        
    }
    
}
