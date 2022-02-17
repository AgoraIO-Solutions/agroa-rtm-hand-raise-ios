//
//  AudienceView.swift
//  Host Audience
//
//  Created by shaun on 2/16/22.
//

import os
import SwiftUI



struct AudienceView: View {
    @StateObject var rtm: RTM = .init()

    let logger = Logger(subsystem: "io.agora.HandRaiseDemo", category: "AudienceView")

    @ViewBuilder
    var body: some View {
        VStack {
            Text("Audience Members")
                .font(.title2.bold())
                .padding()

            Text("\(rtm.memberCount)").font(.callout.bold())
            switch rtm.audienceState {
            case .standBy:
                Button("Raise Hand") {
                    raiseHand()
                }
                .buttonStyle(.borderedProminent)
            case .raisedHand:
                Button("Put hand down") {
                    lowerHand()
                }
                .buttonStyle(.borderedProminent)
            case .calledOn:
                Text("You have been called on")
            }
        }
    }

    private func raiseHand() {
        logger.info("User raises hand")
        rtm.raiseHand()
    }

    private func lowerHand() {
        logger.info("User lowers hand")
        rtm.lowerHand()
    }
}

struct AudienceView_Previews: PreviewProvider {
    static var previews: some View {
        AudienceView()
    }
}
