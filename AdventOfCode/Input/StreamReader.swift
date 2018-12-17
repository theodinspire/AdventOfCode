//
//  StreamReader.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/1/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

public class StreamReader  {
    public let encoding: String.Encoding
    public let chunkSize: Int
    private(set) public var fileHandle: FileHandle!
    public let delimData: Data
    private(set) public var buffer: Data
    private(set) public var atEndOfFile: Bool

    public var hasNext: Bool { return !atEndOfFile }

    public init?(path: String, delimiter: String = "\n", encoding: String.Encoding = .utf8,
                 chunkSize: Int = 4096) {

        guard let fileHandle = FileHandle(forReadingAtPath: path),
            let delimData = delimiter.data(using: encoding) else {
                return nil
        }
        self.encoding = encoding
        self.chunkSize = chunkSize
        self.fileHandle = fileHandle
        self.delimData = delimData
        self.buffer = Data(capacity: chunkSize)
        self.atEndOfFile = false
    }

    public init?(url: URL, delimiter: String = "\n", encoding: String.Encoding = .utf8,
                 chunkSize: Int = 4096) {
        do {
            let fileHandle = try FileHandle(forReadingFrom: url)
            guard let delimData = delimiter.data(using: encoding) else {
                return nil
            }

            self.encoding = encoding
            self.chunkSize = chunkSize
            self.fileHandle = fileHandle
            self.delimData = delimData
            self.buffer = Data(capacity: chunkSize)
            self.atEndOfFile = false
        } catch {
            print(error)
            return nil
        }
    }

    deinit {
        self.close()
    }

    /// Return next line, or nil on EOF.
    public func nextLine() -> String? {
        precondition(fileHandle != nil, "Attempt to read from closed file")

        // Read data chunks from file until a line delimiter is found:
        while !atEndOfFile {
            if let range = buffer.range(of: delimData) {
                // Convert complete line (excluding the delimiter) to a string:
                let line = String(data: buffer.subdata(in: 0..<range.lowerBound), encoding: encoding)
                // Remove line (and the delimiter) from the buffer:
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
            let tmpData = fileHandle.readData(ofLength: chunkSize)
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                // EOF or read error.
                atEndOfFile = true
                if buffer.count > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = String(data: buffer as Data, encoding: encoding)
                    buffer.count = 0
                    return line
                }
            }
        }
        return nil
    }

    /// Start reading from the beginning of file.
    public func rewind() -> Void {
        fileHandle.seek(toFileOffset: 0)
        buffer.count = 0
        atEndOfFile = false
    }

    /// Close the underlying file. No reading must be done after calling this method.
    public func close() -> Void {
        fileHandle?.closeFile()
        fileHandle = nil
    }
}

extension StreamReader : Sequence {
    public func makeIterator() -> AnyIterator<String> {
        if atEndOfFile { rewind() }

        return AnyIterator {
            return self.nextLine()
        }
    }
}
