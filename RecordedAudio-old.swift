//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Edilson Junior on 6/7/15.
//  Copyright (c) 2015 Edilson Junior. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!, title: String!){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}