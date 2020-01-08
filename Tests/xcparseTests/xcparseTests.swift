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

        guard let parsedChunk = PNGChunk(withPNGChunkData: &pngChunk) else {
            fatalError("Couldn't parse PNG chunk")
        }
        let parsedBytes = parsedChunk.bytes()
//        XCTAssertEqual(parsedBytes, pngChunk)
        XCTAssertEqual(parsedChunk.chunkType, .IHDR)
    }

    func testLoadPNG() throws {
        let pngURL = URL(fileURLWithPath: "/Users/abotkin/Downloads/CPTAutomation_homeChargerStatus_1_A28AEE4D-1724-4F19-92B1-54C7A7557841.png")
        let pngData = try Data(contentsOf: pngURL)
        let pngFile = PNGFile(withPNGData: pngData)
        print("HERE")
    }

    func testCreateAPNG() throws {
        let pngFilePaths = [
            "/Users/abotkin/Downloads/CPTAutomation_homeChargerStatus_1_A28AEE4D-1724-4F19-92B1-54C7A7557841.png",
            "/Users/abotkin/Downloads/CPTAutomation_homeChargerSchedule_1_6A563A85-5EFC-4108-B447-D920791141A9.png",
            "/Users/abotkin/Downloads/CPTAutomation_remindToPlugin_1_7A04D695-F3FE-4ABB-9D93-4FB677023D61.png",
            "/Users/abotkin/Downloads/CPTAutomation_homeChargerSettings_1_0F34735C-B529-4856-8971-52D4C7FF3B5E.png",
            "/Users/abotkin/Downloads/CPTAutomation_mySpots_1_879DA714-FAFF-4A41-BDBC-EEC6E155966A.png"
        ]
        var frames: [PNGFile] = []
        for path in pngFilePaths {
            let url = URL(fileURLWithPath: path)
            let png = PNGFile(withPNGData: try Data(contentsOf: url))
            frames.append(png!)
        }

        let firstFrame = frames.removeFirst()
        firstFrame.createAPNG(frames: frames)
        try firstFrame.save()
    }

    func testCreateAPNGFromJPEG() throws {
        let pngFilePaths = [
            "/Users/abotkin/Downloads/failure/Screenshot_BBE66F7A-4EDC-4967-96F2-25FA30AB9BF3.jpg",
            "/Users/abotkin/Downloads/failure/Screenshot_D8B6E8F0-6BB2-4F6B-8AF0-E3BC88D1605C.jpg",
            "/Users/abotkin/Downloads/failure/Screenshot_292B0539-03C2-4413-89B7-D23C0E5BA301.jpg",
            "/Users/abotkin/Downloads/failure/Screenshot_325D3559-9B09-4020-A20B-92A920566FB0.jpg",
            "/Users/abotkin/Downloads/failure/Screenshot_F22F4A5D-D591-4D1F-B52C-DF4188ED6E83.jpg",
        ]
        var frames: [NSImage] = []
        for path in pngFilePaths {
            let url = URL(fileURLWithPath: path)
            guard let image = NSImage(contentsOf: url) else {
                continue
            }
            frames.append(image)
        }

        let apng = frames.createAPNG()
        try apng.save()
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
