//
//  ModelObject.swift
//  MatchEmTab
//
//  Created by Conner Montgomery on 4/19/22.
//

import Foundation


import Foundation

class ModelObject:NSObject{

    
    // scores
 var items = [Item]()
    
    func addItem(test:Item) {
        
        var lowestScore:Int = 0
        
        // Adds score to array of scores (items)
        items.append(test)
        
        // if there are more than 3 scores, remove the lowest
        if (items.count > 3) {
            for i in 1...(items.count-2) {
                if (items[i].score < items[i+1].score) {
                    lowestScore = i
                }
            }
            items.remove(at:lowestScore)
        }
        
       
            
    }
    
    
}
