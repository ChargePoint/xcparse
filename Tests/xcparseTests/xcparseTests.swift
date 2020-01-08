import XCParseCore
import XCTest
import class Foundation.Bundle

final class xcparseTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let fooBinary = productsDirectory.appendingPathComponent("xcparse")

        let process = Process()
        process.executableURL = fooBinary

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "Hello, world!\n")
    }

    func testPNGChunk() throws {
        let pngSig = Data.pngSignature()
        print("\(pngSig as NSData)")

        let bytes: [CUnsignedChar] = [ 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x02, 0x00, 0x00, 0x00 ]
        let chunkData = Data(bytes: bytes, count: bytes.count)

        let pngChunk = PNGChunk(type: .IHDR, data: chunkData)
        let pngData = pngChunk.bytes()
        print("Data: \(pngData as NSData)")

        let expectedBytes: [UInt8] = [ 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
                                       0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
                                       0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77, 0x53,
                                       0xDE ]
        let expectedData = Data(bytes: expectedBytes, count: expectedBytes.count)
        XCTAssertEqual(pngData, expectedData)
    }

    func testCRCCalculationforIHDR() throws {
        let bytes: [CUnsignedChar] = [ 0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x02, 0x00, 0x00, 0x00 ]
        let chunkTypeAndData = Data(bytes: bytes, count: bytes.count)
        let crcValue = crc(chunkTypeAndData).networkByteOrder() // Looking for 0x907753DE
        let expectedCRCValue: [UInt8] = [ 0x90, 0x77, 0x53, 0xDE ]
        XCTAssertEqual(crcValue, expectedCRCValue)
    }

    func testPNGChunkParse() throws {
        let bytes: [CUnsignedChar] = [ 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, // IHDR
                                       0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
                                       0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77, 0x53,
                                       0xDE,
                                       // IDAT
                                       0x00, 0x00, 0x00, 0x0E, 0x49, 0x44, 0x41, 0x54,
                                       0x78, 0xDA, 0x62, 0xF8, 0xCF, 0xC0, 0x00, 0x10,
                                       0x60, 0x00, 0x03, 0x01, 0x01, 0x00, 0x66, 0xFD,
                                       0x9F, 0x24,
        ]
        var pngChunk = Data(bytes: bytes, count: bytes.count)

        let parsedChunk = PNGChunk(withPNGChunkData: &pngChunk)
        let parsedBytes = parsedChunk.bytes()
//        XCTAssertEqual(parsedBytes, pngChunk)
        XCTAssertEqual(parsedChunk.chunkType, .IHDR)
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
