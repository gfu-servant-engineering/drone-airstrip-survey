//
//  Mission.swift
//  MAF2
//
//  Created by Admin on 2/12/21.
//  Copyright © 2021 Admin. All rights reserved.
//

import Foundation

struct Mission : Codable
{
    var name: String
    var altitude: Float
    var coord1lat: Double
    var coord1lon: Double
    var coord2lat: Double
    var coord2lon: Double
}
