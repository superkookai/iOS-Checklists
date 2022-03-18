//
//  Checklist.swift
//  Checklists
//
//  Created by Weerawut Chaiyasomboon on 4/3/2565 BE.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()
    var iconName = "No Icon"
    
    init(name: String){
        self.name = name
        super.init()
    }
    
    func countUncheckedItems() -> Int{
        var count = 0
        
        for item in items where !item.checked{
            count += 1
        }
        
        return count
    }
}
