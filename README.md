# A Hand Raising Demonstartion, with Agora RTM

This repository is aimed at giving a quick demonstartion on how Agora RTM can be used to manage a scenario where hand raising functionality between audience and host's is needed.

## To Setup

1) Setup a sample project on the agora console and setup a demo project that makes use of "Use an App ID for authentication" as outlined [here](https://docs.agora.io/en/Real-time-Messaging/rtm_token)

2) Add a `Config.xcconfig` with the following info(Read more about config files [here](https://nshipster.com/xcconfig/)), use your app id from step 1 in place of the `<Your App Id>` below.

```
//
//  Config.xcconfig
//  Host Audience
//
//  Created by shaun on 2/16/22.
//

// Configuration settings file format documentation can be found at:
// https://help.apple.com/xcode/#/dev745c5c974

AGORA_RTM_ID=<Your App Id>
```
