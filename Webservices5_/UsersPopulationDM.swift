//
//  UsersPopulationDM.swift
//  Webservices5_
//
//  Created by Smita Kankayya on 17/01/24.
//

import Foundation

struct UsersDM{
    var id : Int
    var name : String
    var gender : String
}

struct PopulationDM : Decodable{
    var data : [Data]
}

struct Data : Decodable{
    var Year : String
    var Population : Int64
}
