//
//  RTM.swift
//  Host Audience
//
//  Created by shaun on 2/16/22.
//

import Foundation
import AgoraRtmKit


enum Commands: Codable {
    case joinChannelHost, joinChannelAudience, raiseHand, lowerHand, callOn, uncallOn
}

struct Command: Codable {
    let uid: Int
    let command: Commands
}


class RTM: NSObject {

}
