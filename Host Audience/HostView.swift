//
//  HostView.swift
//  Host Audience
//
//  Created by shaun on 2/16/22.
//

import os
import SwiftUI

struct HostView: View {
    @StateObject var rtm: RTM = .init()

    let logger = Logger(subsystem: "io.agora.HandRaiseDemo", category: "Host View")


    var body: some View {
        VStack {
            Text("Audience Members")
                .font(.title2.bold())
                .padding()
            Text("\(rtm.memberCount)")
                .font(.callout.bold())
            List {
                Section(header: Text("Called on")) {
                    ForEach(Array(rtm.calledOnUsers), id: \.self) { handRaiser in
                        Button("Dimiss \(handRaiser)") {
                            rtm.uncallOn(userId: handRaiser)
                        }
                    }
                }

                Section(header: Text("Hand Raisers")) {
                    ForEach(Array(rtm.usersWithRaisedHands), id: \.self) { handRaiser in
                        Button("Call on \(handRaiser)") {
                            rtm.callOn(userId: handRaiser)
                        }
                    }
                }
            }
        }.navigationTitle(Text("Host View"))
    }
}

struct HostView_Previews: PreviewProvider {
    static var previews: some View {
        HostView()
    }
}
