//
//  ChattingUser.swift
//  UIKitChat
//
//  Created by Seunghun Yang on 2022/02/18.
//

import Foundation

struct ChattingUser: DataTransferable {
    let name: String
    let profileImage: URL?
    
    init(name: String, profileImage: URL? = nil) {
        self.name = name
        self.profileImage = profileImage
    }
    
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String else { return nil }
        self.name = name
        self.profileImage = dictionary["profileImage"] as? URL
    }
    
    var dictionary: [String : Any] {
        var dictionary: [String: Any] = [:]
        dictionary["name"] = name
        dictionary["profileImage"] = profileImage
        return dictionary
    }
}
