//
//  ContentDirectory.swift
//  
//
//  Created by Svetoslav on 16.05.2022.
//

import Foundation

public struct ContentDirectory: Decodable {
    public let actionList: ActionList
    
    public struct ActionList: Decodable {
        public let action: [Action]?
    }
    
    public struct Action: Decodable {
        public let name: String

        public var kind: ActionType? {
            ActionType(rawValue: name)
        }
    }
    public enum ActionType: String {
        case browse = "Browse"
    }
}
