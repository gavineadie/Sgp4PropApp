import XCTest
@testable import Sgp4PropApp
@testable import swift
@testable import obj_c

final class Sgp4PropAppTests: XCTestCase {

    override func setUp() {
        let globalHandle = dllMainInit()
        guard envInit(globalHandle) == 0 else { fatalError("envInit load failure") }
        guard timeFuncInit(globalHandle) == 0 else { fatalError("timeFuncInit load failure") }
        guard astroFuncInit(globalHandle) == 0 else { fatalError("astroFuncInit load failure") }
        guard tleInit(globalHandle) == 0 else { fatalError("tleInit load failure") }
        guard sgp4Init(globalHandle) == 0 else { fatalError("sgp4Init load failure") }
    }
    
    func testDTGToUTC() {
        let startTime = DTGToUTC("00051.47568104")
        print(startTime)
    }
    
}
