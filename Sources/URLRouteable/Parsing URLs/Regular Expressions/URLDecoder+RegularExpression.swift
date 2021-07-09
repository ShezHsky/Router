import Foundation.NSRegularExpression
import Foundation.NSURL

extension URLDecoding {
    
    /// Namespace for types that decode `URL`s into other types by way of regular expressions.
    public struct RegularExpression { }
    
}

// MARK: - One Capture Group

extension URLDecoding.RegularExpression {
    
    /// A type that decodes `URL`s into another type, with one value parsed from the url.
    public struct OneCaptureGroup<CaptureGroup>: URLComponentsDecoder where CaptureGroup: ExpressibleByString {
        
        public typealias Representation = CaptureGroup
        
        public var regularExpression: NSRegularExpression
        
        public init(regularExpression: NSRegularExpression) {
            self.regularExpression = regularExpression
        }
        
        public func decode(from url: URL) throws -> CaptureGroup {
            let absoluteString = url.absoluteString
            let range = NSRange(location: 0, length: absoluteString.count)
            guard let match = regularExpression.firstMatch(in: absoluteString, options: [], range: range) else {
                throw URLParsingError()
            }
            
            let r = match.range(at: max(0, match.numberOfRanges - 1))
            guard let captureGroupRange = Range(r, in: absoluteString) else {
                throw URLParsingError()
            }
            
            let captureGroupContents = String(absoluteString[captureGroupRange])
            guard let captureGroupValue = CaptureGroup(stringValue: captureGroupContents) else {
                throw URLParsingError()
            }
            
            return captureGroupValue
        }
        
    }
    
}

// MARK: - Two Capture Groups

extension URLDecoding.RegularExpression {
    
    /// A type that decodes `URL`s into another type, with two values parsed from the url.
    public struct TwoCaptureGroups<
        FirstCaptureGroup: ExpressibleByString,
        SecondCaptureGroup: ExpressibleByString
    >: URLComponentsDecoder {
        
        public typealias Representation = (FirstCaptureGroup, SecondCaptureGroup)
        
        public var regularExpression: NSRegularExpression
        
        public init(regularExpression: NSRegularExpression) {
            self.regularExpression = regularExpression
        }
        
        public func decode(from url: URL) throws -> (FirstCaptureGroup, SecondCaptureGroup) {
            let absoluteString = url.absoluteString
            let range = NSRange(location: 0, length: absoluteString.count)
            guard let match = regularExpression.firstMatch(in: absoluteString, options: [], range: range) else {
                throw URLParsingError()
            }
            
            let firstCaptureGroupNSRange = match.range(at: 1)
            guard let firstCaptureGroupRange = Range(firstCaptureGroupNSRange, in: absoluteString) else {
                throw URLParsingError()
            }
            
            let secondCaptureGroupNSRange = match.range(at: 2)
            guard let secondCaptureGroupRange = Range(secondCaptureGroupNSRange, in: absoluteString) else {
                throw URLParsingError()
            }
            
            let firstCaptureGroupContents = String(absoluteString[firstCaptureGroupRange])
            let secondCaptureGroupContents = String(absoluteString[secondCaptureGroupRange])
            
            guard let firstCaptureGroupValue = FirstCaptureGroup(stringValue: firstCaptureGroupContents) else {
                throw URLParsingError()
            }
            
            guard let secondCaptureGroupValue = SecondCaptureGroup(stringValue: secondCaptureGroupContents) else {
                throw URLParsingError()
            }
            
            return (firstCaptureGroupValue, secondCaptureGroupValue)
        }
        
    }
    
}
