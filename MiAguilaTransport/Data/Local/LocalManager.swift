//  LocalManager.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/27/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import Foundation

class LocalManager {
    
    static let get = LocalManager()
    
    func getTravelsbyJSON( success:@escaping ([Trip]) -> Void, failure:@escaping (Error) -> Void ){
        if let path = Bundle.main.path(forResource: "trips", ofType: "json") {
            do {
                guard let text = try String(contentsOfFile: path, encoding: .utf8).data(using: .utf8) else { return }
                if let dict = try JSONSerialization.jsonObject(with: text, options: .allowFragments) as? [String: Any] {
                    if let data = TripslList(JSON: dict) {
                        success(data.trips ?? [])
                    }
                }
            }catch {
                failure(error)
            }
        }
    }

}
