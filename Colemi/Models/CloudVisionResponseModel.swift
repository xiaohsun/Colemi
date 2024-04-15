//
//  CloudVisionResponseModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/15/24.
//

import Foundation

struct CloudVisionResponse: Codable {
    let responses: [ResponseData]
}

struct ResponseData: Codable {
    let imagePropertiesAnnotation: ImagePropertiesAnnotation
    let cropHintsAnnotation: CropHintsAnnotation
}

struct ImagePropertiesAnnotation: Codable {
    let dominantColors: DominantColors
}

struct DominantColors: Codable {
    let colors: [Color]
}

struct Color: Codable {
    let color: ColorValue
    let score: Float
    let pixelFraction: Float
}

struct ColorValue: Codable {
    let red, green, blue: Int
}

struct CropHintsAnnotation: Codable {
    let cropHints: [CropHint]
}

struct CropHint: Codable {
    let boundingPoly: BoundingPoly
    let confidence: Float
    let importanceFraction: Float
}

struct BoundingPoly: Codable {
    let vertices: [Vertex]
}

struct Vertex: Codable {
    let x, y: Int?
}
