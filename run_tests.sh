#!/bin/bash/

xcodebuild -scheme "Router-Package" test
xcodebuild -scheme "Router-Package" -destination "platform=iOS Simulator,name=iPhone 11" test
xcodebuild -scheme "Router-Package" -destination "platform=tvOS Simulator,name=Apple TV" test
xcodebuild -scheme "Router-Package" -destination "platform=watchOS Simulator,name=Apple Watch Series 6 - 44mm" test

