//
//  ModBusTests.swift
//  ModBusTests
//
//  Created by Hut on 2022/1/28.
//

import XCTest

class ModBusTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        var lenght:Int = 12
        
        print("1: \(lenght >> 8)")
        print("1: \(lenght)")
        
        let lenBin = Data(bytes: &lenght, count: MemoryLayout<Int>.size)
        
        print("2: \(lenght) lenBin: \(lenBin)")
        
        let len = [UInt8(lenght >> 8), UInt8(lenght & 0xFF)]
        
        print("3: \(lenght) lenBin: \(lenBin) len: \(len)")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
