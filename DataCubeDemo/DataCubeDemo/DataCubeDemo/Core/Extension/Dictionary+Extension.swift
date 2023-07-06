//
//  Dictionary+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

extension Dictionary {
    var jsonSerialization: Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            return jsonData
        } catch {
            return nil
        }
    }
    
    var prettyString: String {
        guard let data = self.jsonSerialization, let jsonString = String(data: data, encoding: .utf8) else {
            return self.description
        }
        
        return jsonString
    }
}
