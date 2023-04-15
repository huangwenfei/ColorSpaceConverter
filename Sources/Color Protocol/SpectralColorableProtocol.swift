//
//  SpectralColorableProtocol.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

public protocol SpectralColorableProtocol: Colorable {
    var illuminant: SpectralIlluminant { get set }
}
