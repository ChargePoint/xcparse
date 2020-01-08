//
//  APNGImage.swift
//  XCParseCore
//
//  Created by Alexander Botkin on 1/7/20.
//

import AppKit
import Foundation

// https://en.wikipedia.org/wiki/APNG
// https://www.w3.org/TR/PNG/#5CRC-algorithm
// https://wiki.mozilla.org/APNG_Specification


// MARK: -
// MARK: CRC
// https://www.w3.org/TR/PNG/#D-CRCAppendix
var crc_table = [UInt64](repeating: 0, count: 256)
var crc_table_computed = false

public func make_crc_table() {
    var c: UInt64 = 0

    for index in 0..<256 {
        c = UInt64(index)
        for _ in 0..<8 {
            if c & UInt64(1) == 1 {
                c = 0xedb88320 ^ (c >> 1)
            } else {
                c = c >> 1
            }
        }
        crc_table[index] = c
    }
    crc_table_computed = true
}

public func update_crc(_ crc: UInt64, _ data: Data) -> UInt64 {
    var c = crc
    if crc_table_computed != true {
        make_crc_table()
    }
    for n in 0..<data.count {
        c = crc_table[Int((c ^ UInt64(data[n])) & 0xFF)] ^ (c >> 8)
    }
    return c
}

public func crc(_ data: Data) -> UInt32 {
    let crc = update_crc(0xffffffff, data) ^ 0xffffffff
    return UInt32(crc)
}

// MARK: -


public extension Data {
    static func pngSignature() -> Data {
        let bytes: [CUnsignedChar] = [ 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A ]
        let byteSize = MemoryLayout.size(ofValue: bytes)
        return Data(bytes: bytes, count: byteSize)
    }
}

// Values correspond to the uppercase & lowercase Latin alphabet letters
// when encoded in hex per ISO-646 - https://en.wikipedia.org/wiki/ISO/IEC_646#Code_page_layout
public enum PNGChunkType: UInt32 {
    case unknown = 0
    case IHDR = 0x49484452 // Hex of decimal values - 73 72 68 82
    case PLTE = 0x504C5445 // Hex of decimal values - 80 76 84 69
    case IDAT = 0x49444154 // Hex of decimal values - 73 68 65 84
    case IEND = 0x49454E44 // Hex of decimal values - 73 69 78 68
    // APNG extension chunks
    case acTL = 0x6163544C // Animation Control Chunk
    case fcTL = 0x6663544C // Frame Control Chunk
    case fdAT = 0x66644154 // Frame Data Chunk
    // Ancillary chunks
    case tRNS = 0x74524E53 // Hex of decimal values - 116 82 78 83
    case cHRM = 0x6348524D // Hex of decimal values - 99 72 82 77
    case gAMA = 0x67414D41 // Hex of decimal values - 103 65 77 65
    case iCCP = 0x69434350 // Hex of decimal values - 105 67 67 80
    case sBIT = 0x73424954 // Hex of decimal values - 115 66 73 84
    case sRGB = 0x73524742 // Hex of decimal values - 115 82 71 66
    case eXIf = 0x65584966
    // Textual information
    case tEXT = 0x74455854 // Hex of decimal values - 116 69 88 116
    case zTXt = 0x7A545874 // Hex of decimal values - 122 84 88 116
    case iTXt = 0x69545874 // Hex of decimal values - 105 84 88 116
    // Misc
    case bKGD = 0x624B4744 // Hex of decimal values - 98 75 71 68
    case hIST = 0x68495354 // Hex of decimal values - 104 73 83 84
    case pHYs = 0x70485973 // Hex of decimal values - 112 72 89 115
    case sPLT = 0x73504C54 // Hex of decimal values - 115 80 76 84
    case tIME = 0x74494D45 // Hex of decimal values - 116 73 77 69
    // Undocumented Apple
    case iDOT = 0x69444f54
}

extension UInt16 {
    public func networkByteOrder() -> [UInt8] {
        var networkByteOrder = self.bigEndian
        let count = MemoryLayout<UInt16>.size
        let bytePtr = withUnsafePointer(to: &networkByteOrder) {
            $0.withMemoryRebound(to: UInt8.self, capacity: count) {
                UnsafeBufferPointer(start: $0, count: count)
            }
        }
        let retval = Array(bytePtr)
        return retval
    }
}

extension UInt32 {
    public func networkByteOrder() -> [UInt8] {
        var networkByteOrder = self.bigEndian
        let count = MemoryLayout<UInt32>.size
        let bytePtr = withUnsafePointer(to: &networkByteOrder) {
            $0.withMemoryRebound(to: UInt8.self, capacity: count) {
                UnsafeBufferPointer(start: $0, count: count)
            }
        }
        let retval = Array(bytePtr)
        return retval
    }
}

open class PNGChunk {
    public var chunkType: PNGChunkType = .unknown
    public var chunk: Data? = nil

    public init(type: PNGChunkType, data: Data?) {
        chunkType = type
        chunk = data
    }

    public init?(withPNGChunkData data: inout Data) {
        var chunkLength: UInt32 = 0
        var bytesCopied = withUnsafeMutableBytes(of: &chunkLength) { data.copyBytes(to: $0, from: 0..<4) } // Need to deal with endianness
        assert(bytesCopied == MemoryLayout.size(ofValue: chunkLength))
        chunkLength = UInt32(bigEndian: chunkLength)

        var type: UInt32 = 0
        bytesCopied = withUnsafeMutableBytes(of: &type) { data.copyBytes(to: $0, from: 4..<8) }
        assert(bytesCopied == MemoryLayout.size(ofValue: type))
        type = UInt32(bigEndian: type)
        chunkType = PNGChunkType(rawValue: type) ?? .unknown

        let lastChunkIndex = 8 + Int(chunkLength)
        chunk = data.subdata(in: 8..<lastChunkIndex)

        let indexAfterCRC = lastChunkIndex + MemoryLayout<UInt32>.size
        data = data.subdata(in: indexAfterCRC..<data.count)
    }

    public func bytes() -> Data {
        var retval = Data()

        let chunkLength = UInt32(chunk?.count ?? 0)
        let lengthBytes = chunkLength.networkByteOrder()
        retval.append(lengthBytes, count: lengthBytes.count)

        var typeAndData = Data()

        let chunkTypeBytes = chunkType.rawValue.networkByteOrder()
        typeAndData.append(chunkTypeBytes, count: chunkTypeBytes.count)

        if let dataChunk = chunk {
            typeAndData.append(dataChunk)
        }

        retval.append(typeAndData)

        let crcBytes = crc(typeAndData).networkByteOrder()
        retval.append(crcBytes, count: crcBytes.count)

        return retval
    }
}

public struct IHDR {
    public let width: UInt32
    public let height: UInt32
//    let bit_depth: UInt8
//    let color_type: UInt8
//    let compression_method: UInt8
//    let filter_method: UInt8
//    let interlace_method: UInt8

    public init(_ data: Data) {
        var w: UInt32 = 0
        var bytesCopied = withUnsafeMutableBytes(of: &w) { data.copyBytes(to: $0, from: 0..<4) } // Need to deal with endianness
        assert(bytesCopied == MemoryLayout.size(ofValue: w))
        width = UInt32(bigEndian: w)

        var h: UInt32 = 0
        bytesCopied = withUnsafeMutableBytes(of: &h) { data.copyBytes(to: $0, from: 4..<8) }
        assert(bytesCopied == MemoryLayout.size(ofValue: h))
        height = UInt32(bigEndian: h)
    }
}

public struct acTL {
    let num_frames: UInt32 // Must be at least one & should match number of frames in file or is error
    let num_plays: UInt32 // Use 0 for infinite looping

    public func bytes() -> Data {
        var retval = Data()

        let frameBytes = num_frames.networkByteOrder()
        retval.append(frameBytes, count: frameBytes.count)

        let playBytes = num_plays.networkByteOrder()
        retval.append(playBytes, count: playBytes.count)

        return retval
    }
}


public enum APNGDisposeOptions: UInt8 {
    case none // no disposal is done on this frame before rendering the next; the contents of the output buffer are left as is
    case background //  the frame's region of the output buffer is to be cleared to fully transparent black before rendering the next frame.
    case previous // the frame's region of the output buffer is to be reverted to the previous contents before rendering the next frame.
}

public enum APNGBlendOptions: UInt8 {
    case source // all color components of the frame, including alpha, overwrite the current contents of the frame's output buffer region
    case over // the frame should be composited onto the output buffer based on its alpha, using a simple OVER operation as described in the "Alpha Channel Processing" section of the PNG specification [PNG-1.2]
}

public struct fcTL {
    let sequence_number: UInt32 // Starts from 0
    let width: UInt32
    let height: UInt32
    let x_offset: UInt32 // x position at which to render frame
    let y_offset: UInt32 // y position at which to render frame
    let delay_num: UInt16 // Frame delay fraction numerator (delay for num/den seconds)
    let delay_den: UInt16 // Frame delay fraction denominator (delay for num/den seconds)
    let dispose_op: APNGDisposeOptions // Type of frame area disposal to be done after rendering
    let blend_op: APNGBlendOptions // Type of frame area rendering for this frame

    public func bytes() -> Data {
        var retval = Data()

        let seqNumBytes = sequence_number.networkByteOrder()
        retval.append(seqNumBytes, count: seqNumBytes.count)

        let widthBytes = width.networkByteOrder()
        retval.append(widthBytes, count: widthBytes.count)

        let heightBytes = height.networkByteOrder()
        retval.append(heightBytes, count: heightBytes.count)

        let xOffsetBytes = x_offset.networkByteOrder()
        retval.append(xOffsetBytes, count: xOffsetBytes.count)

        let yOffsetBytes = y_offset.networkByteOrder()
        retval.append(yOffsetBytes, count: yOffsetBytes.count)

        let delayNumBytes = delay_num.networkByteOrder()
        retval.append(delayNumBytes, count: delayNumBytes.count)

        let delayDenBytes = delay_den.networkByteOrder()
        retval.append(delayDenBytes, count: delayDenBytes.count)

        var disposeBytes = dispose_op.rawValue
        retval.append(&disposeBytes, count: 1)

        var blendBytes = blend_op.rawValue
        retval.append(&blendBytes, count: 1)

        return retval
    }
}

public struct fdAT {
    let sequence_number: UInt32
    let frame_data: Data

    public func bytes() -> Data {
        var retval = Data()

        let seqNumBytes = sequence_number.networkByteOrder()
        retval.append(seqNumBytes, count: seqNumBytes.count)

        retval.append(frame_data)

        return retval
    }
}

/*
 A valid PNG datastream shall begin with a PNG signature, immediately followed by an IHDR chunk, then one or more IDAT chunks, and shall end with an IEND chunk. Only one IHDR chunk and one IEND chunk are allowed in a PNG datastream.
 */
open class PNGFile {
    let PNGSignature: Data // PNG Signature
    var chunks: [PNGChunk]

    public init?(withPNGData data: Data) {
        let dataSignature = data.subdata(in: 0..<8)
        let pngSignature = Data.pngSignature()
        if dataSignature != pngSignature {
            return nil
        }
        PNGSignature = dataSignature

        var chunkData = data.subdata(in: 8..<data.count)
        var parsedChunks: [PNGChunk] = []
        while chunkData.count > 0 {
            if let pngChunk = PNGChunk(withPNGChunkData: &chunkData) {
                parsedChunks.append(pngChunk)
            } else {
                return nil;
            }
        }
        chunks = parsedChunks
    }

    public func bytes() -> Data {
        var retval = Data()

        retval.append(PNGSignature)

        for chunk in chunks {
            let chunkData = chunk.bytes()
            retval.append(chunkData)
        }

        return retval
    }

    public func save() throws {
        let data = self.bytes()
        let url = URL(fileURLWithPath: "/tmp/xcparse/test_apng.png")
        try data.write(to: url)
    }

    public func createAPNG(frames: [PNGFile]) {
        guard let ihdrIndex = chunks.firstIndex(where: { $0.chunkType == .IHDR }) else {
            return
        }
        let firstFrameIHDR = chunks[ihdrIndex]
        let ihdr = IHDR(firstFrameIHDR.chunk!)

        //  Insert an animation control chunk (acTL) after the image header chunk (IHDR)
        let actl = acTL(num_frames: UInt32(frames.count + 1), num_plays: 0)
        let actlChunk = PNGChunk(type: .acTL, data: actl.bytes())
        chunks.insert(actlChunk, at: ihdrIndex + 1)

        var sequenceNumber: UInt32 = 0

        // If the first PNG is to be part of the animation, insert a frame control chunk (fcTL) before the image data chunk (IDAT)
        let firstFctl = fcTL(sequence_number: sequenceNumber,
                             width: ihdr.width,
                             height: ihdr.height,
                             x_offset: 0,
                             y_offset: 0,
                             delay_num: 1,
                             delay_den: 1,
                             dispose_op: .none,
                             blend_op: .source)
        let firstFctlChunk = PNGChunk(type: .fcTL, data: firstFctl.bytes())
        guard let firstIDATIndex = chunks.firstIndex(where: { $0.chunkType == .IDAT }) else {
            return
        }
        chunks.insert(firstFctlChunk, at: firstIDATIndex)
        sequenceNumber += 1

        //  For each of the remaining frames, add a frame control chunk (fcTL) and a frame data chunk (fdAT). The content for the frame data chunks (fdAT) is taken from the image data chunks (IDAT) of their respective source images.
        guard let iendIndex = chunks.firstIndex(where: { $0.chunkType == .IEND }) else {
            return
        }
        var insertIndex = iendIndex

        for png in frames {
            let fctl = fcTL(sequence_number: sequenceNumber,
                            width: ihdr.width,
                            height: ihdr.height,
                            x_offset: 0,
                            y_offset: 0,
                            delay_num: 1,
                            delay_den: 1,
                            dispose_op: .none,
                            blend_op: .source)
            let fctlChunk = PNGChunk(type: .fcTL, data: fctl.bytes())
            chunks.insert(fctlChunk, at: insertIndex)
            insertIndex += 1
            sequenceNumber += 1

            let idats = png.chunks.filter({ $0.chunkType == .IDAT })
            for idat in idats {
                let fdat = fdAT(sequence_number: sequenceNumber, frame_data: idat.chunk!)
                let fdatChunk = PNGChunk(type: .fdAT, data: fdat.bytes())
                chunks.insert(fdatChunk, at: insertIndex)

                insertIndex += 1
                sequenceNumber += 1
            }
        }
    }
}

extension Array where Element:NSImage {
    public func createAPNG() -> PNGFile {
        var pngs: [PNGFile] = []
        for image in self {
            guard let imageData = image.tiffRepresentation else {
                continue
            }
            let bitmap = NSBitmapImageRep(data: imageData)
            guard let pngData = bitmap?.representation(using: .png, properties: [:]) else {
                continue
            }

            guard let png = PNGFile(withPNGData: pngData) else {
                continue
            }
            pngs.append(png)
        }

        let firstFrame = pngs.removeFirst()
        firstFrame.createAPNG(frames: pngs)
        return firstFrame
    }
}
