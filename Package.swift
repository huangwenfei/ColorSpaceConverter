// swift-tools-version:5.3
//
//  Copyright (c) 2021, 黄文飞
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its
//     contributors may be used to endorse or promote products derived from
//     this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import PackageDescription

let package = Package(
    name: "ColorSpaceConverter",
    platforms: [
        .iOS("9.1"),
        .macOS(.v10_10)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ColorSpaceConverter",
            type: .dynamic,
            targets: ["ColorSpaceConverter"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
            url: "https://github.com/huangwenfei/AlgorithmX",
            .upToNextMajor(from: .init("0.0.1"))
        )
        
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ColorSpaceConverter",
            dependencies: [
                "AlgorithmX"
            ],
            path: "Sources",
            exclude: [
                "Supporting Files/ColorSpaceConverter.h",
                "Supporting Files/Info.plist"
            ],
            linkerSettings: [
                .linkedFramework(
                    "Accelerate", .when(platforms: [.iOS, .macOS])
                )
//                ,
//                .linkedFramework(
//                    "simd", .when(platforms: [.iOS, .macOS])
//                )
            ]
        ),
        .testTarget(
            name: "ColorSpaceConverterTests",
            dependencies: ["ColorSpaceConverter"],
            path: "Tests",
            exclude: [
                "Supporting Files/Info.plist"
            ]
        ),
    ],
    swiftLanguageVersions: [ .v5 ]
)
