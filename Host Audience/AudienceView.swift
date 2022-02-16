//
//  AudienceView.swift
//  Host Audience
//
//  Created by shaun on 2/16/22.
//

import os
import SwiftUI



struct AudienceView: View {
    enum HandState {
        case standby, handRaised, calledOn
    }

    @State var handState: HandState = .standby

    let logger = Logger(subsystem: "io.agora.HandRaiseDemo", category: "AudienceView")

    @ViewBuilder
    var body: some View {
        switch handState {
        case .standby:
            Button("Raise Hand") {
                raiseHand()
            }
            .buttonStyle(.borderedProminent)
        case .handRaised:
            Button("Put hand down") {
                lowerHand()
            }
            .buttonStyle(.borderedProminent)
        case .calledOn:
            Text("You have been called on")
        }
    }

    private func raiseHand() {
        logger.info("User raises hand")
        handState = .handRaised
    }

    private func lowerHand() {
        logger.info("User lowers hand")
        handState = .calledOn
    }
}

struct AudienceView_Previews: PreviewProvider {
    static var previews: some View {
        AudienceView()
    }
}
