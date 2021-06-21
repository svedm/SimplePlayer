import Foundation
import NIO

/// SSPD search response
/// #1.3.3 https://openconnectivity.org/upnp-specs/UPnP-arch-DeviceArchitecture-v2.0-20200417.pdf
public struct SSDPSearchResponse {
    /// Field value shall have the max-age directive (“max-age=”)
    /// followed by an integer that specifies the number of seconds the advertisement is valid.
    var cacheControl: String

    /// Field value contains date when response was generated. “rfc1123-date” as defined in RFC 2616.
    var date: String?

    /// Required for backwards compatibility with UPnP 1.0. (Header field name only; no field value.)
    var ext: String?

    /// Field value contains a URL to the UPnP description of the root device.
    var location: String

    /// Specified by UPnP vendor. Value shall begin with the following `product tokens`
    /// For example, “SERVER: unix/5.1 UPnP/2.0 MyProduct/1.0”.
    var server: String

    /// Field value contains Search Target. Single URI
    var st: String

    /// Field value contains Unique Service Name. Identifies a unique instance of a device or service
    var usn: String

    public enum ParsingError: Error {
        case cacheControl
        case location
        case server
        case st
        case usn
    }

    init(response: String) throws {
        let headers = response.split(separator: "\r\n").reduce([String: String]()) { dictionary, string in
            var dictionary = dictionary
            guard let range = string.range(of: ": ") else { return dictionary }

            let name = String(string[..<range.lowerBound]).uppercased()
            let value = String(string[range.upperBound...])
            dictionary[name] = value
            return dictionary
        }

        guard let cacheControl = headers["CACHE-CONTROL"] else { throw ParsingError.cacheControl }
        self.cacheControl = cacheControl

        date = headers["DATE"]
        ext = headers["EXT"]

        guard let location = headers["LOCATION"] else { throw ParsingError.location }
        self.location = location

        guard let server = headers["SERVER"] else { throw ParsingError.server }
        self.server = server

        guard let st = headers["ST"] else { throw ParsingError.st }
        self.st = st

        guard let usn = headers["USN"] else { throw ParsingError.usn }
        self.usn = usn
    }
}
