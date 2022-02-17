//
//  RTM.swift
//  Host Audience
//
//  Created by shaun on 2/16/22.
//

import Foundation
import AgoraRtmKit
import os
import SwiftUI

enum Commands: Codable {
    case raiseHand(String), lowerHand(String), callOn(String), uncallOn(String)
}

let logger = Logger(subsystem: "io.agora.HandRaiseDemo", category: "RTM")

enum AudienceState {
    case raisedHand, calledOn, standBy
}

class RTM: NSObject, ObservableObject {
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()

    @Published var memberCount = 0
    @Published var calledOnUsers: Set<String> = []
    @Published var usersWithRaisedHands: Set<String> = []
    @Published var audienceState: AudienceState = .standBy

    private let userId = UUID().uuidString
    private var rtmKit: AgoraRtmKit?
    private var rtmChannel: AgoraRtmChannel?

    override init() {
        super.init()
        do {
            let rtmId: String = try Configuration.value(for: "AGORA_RTM_ID")

            logger.info("Got api key \(rtmId), token")
            rtmKit = .init(appId: rtmId, delegate: self)

            Task { () -> Void in
                let errorCode = await rtmKit?.login(byToken: rtmId, user: self.userId)
                guard errorCode == .ok else { return logger.error("Error logging into rtm \(errorCode?.rawValue ?? .min)") }
                rtmChannel = rtmKit?.createChannel(withId: "test channel", delegate: self)
                let chanErrorCode = await rtmChannel?.join()
                guard chanErrorCode == .channelErrorOk else { return logger.error("Error joining channel \(errorCode?.rawValue ?? .min)") }

            }
        } catch {
            fatalError("Configuration object failure. See readme for details")
        }
    }

    func raiseHand() {
        audienceState = .raisedHand
        send(cmd: .raiseHand(userId))
    }

    func lowerHand() {
        audienceState = .standBy
        send(cmd: .lowerHand(userId))
    }

    private func send(cmd: Commands) {
        let jsonStr: String
        do {
            guard let maybeStr = String(data: try jsonEncoder.encode(cmd), encoding: .utf8) else { throw NSError(domain: "coding", code: 99, userInfo: .none) }
            jsonStr = maybeStr
        } catch {
            let cmdStr = "\(cmd)"
            return logger.error("Error encoding \(cmdStr) \(error.localizedDescription)")
        }
        Task { () -> Void in
            let sendResult = await rtmChannel?.send(.init(text: jsonStr))
            guard sendResult == .errorOk else {
                return logger.error("Error sending command \(jsonStr) code: \(sendResult?.rawValue ?? .min)")
            }
            logger.info("successfully sent \(jsonStr)")
        }
    }

    func callOn(userId: String) {
        send(cmd: .callOn(userId))
        handleCallon(userId: userId)
    }

    func uncallOn(userId: String) {
        send(cmd: .uncallOn(userId))
        handleUncallon(userId: userId)
    }

    private func handleCallon(userId: String) {
        usersWithRaisedHands.remove(userId)
        calledOnUsers.insert(userId)
    }

    private func handleUncallon(userId: String) {
        calledOnUsers.remove(userId)
    }
}

extension RTM: AgoraRtmDelegate {

}

extension RTM: AgoraRtmChannelDelegate {
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        logger.info("connection state changed \(state.rawValue)")
    }

    func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
        let memeberId = member.userId
        usersWithRaisedHands.remove(memeberId)
    }

    func channel(_ channel: AgoraRtmChannel, memberCount count: Int32) {
        memberCount = Int(count)
    }

    func channel(_ channel: AgoraRtmChannel, messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember) {
        logger.info("Received channel message \(message)")

        guard let data = message.text.data(using: .utf8), let command = try? jsonDecoder.decode(Commands.self, from: data) else {
            return logger.error("Error decoding message \(message) with text \(message.text)")
        }

        switch command {
        case let.raiseHand(peerId):
            usersWithRaisedHands.insert(peerId)
        case let.lowerHand(peerId):
            usersWithRaisedHands.remove(peerId)
        case let.callOn(userId):
            guard self.userId == userId else {
                return handleCallon(userId: userId)
            }
            audienceState = .calledOn
        case let.uncallOn(userId):
            guard self.userId == userId else {
                return handleUncallon(userId: userId)
            }
            audienceState = .standBy
        }
    }
}
