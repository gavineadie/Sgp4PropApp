//
//  Sgp4PropApp.swift
//  Sgp4PropApp
//
//  Created by Gavin Eadie on 11/11/22.
//

import swift

@main
public struct Sgp4PropApp {

    public static func main() {

// ------------------------------------------------------------------------
        loadAllDlls()
        verifyDLLs()        // and verify by printing their Info strings

// ------------------------------------------------------------------------
// create a satellite from two-line elements and introduce to SGP4 ..
//
        let satKey = tleAddSatFrLines("1 25544U 98067A   22321.90676521  .00009613  00000+0  17572-3 0  9999",
                                      "2 25544  51.6438 295.0836 0006994  86.3588   5.1970 15.50066990369021")  // ISS 2022-11-17

        if 0 == sgp4InitSat(satKey) {
            print("## \(getLastErrMsg()) (after sgp4InitSat) <<<-- MISTAKE")   // shouldn't happen ..
        } else {
            fatalError("## \(getLastErrMsg()) (after sgp4InitSat)")
        }

// ------------------------------------------------------------------------
// propagate the satellite for 4 hours from start time with 6 minute step size
//

        let startTime = dtgToUTC("22321.90676521")
        print("startTime = \(startTime)")

        var llh: [Double] = [0.0, 0.0, 0.0]             // prepare an array to catch 'llh'

        for Δmins in stride(from: 0.0, to: 240.1, by: 6) {
            let Δdays = Δmins / 1440.0

// ------------------------------------------------------------------------
// get the satellite's geodetic latitude (deg), longitude(deg), and height (km)
//
            guard 0 == sgp4PropDs50UtcLLH(satKey, startTime+Δdays, &llh) else {
                print("## \(getLastErrMsg()) (after sgp4PropDs50UtcLLH)")
                fatalError("sgp4PropDs50UTC")
            }

            print(String(format: "Δt = %6.2f mins: %+9.2f°, %+9.2f°, %+9.2f Km",
                         Δmins, llh[0], llh[1], llh[2]))
        }

// ------------------------------------------------------------------------
// check the logging works ..
//
        defer {
            closeLogFile()                              // the log file is closed when app exits
        }

        let code = openLogFile("/Users/gavin/Development/Sgp4Prop/Sgp4/TestMessageFile")
        logMessage("Help!  There are marmots in the capsule .. \(code)")

        print("Sgp4PropApp done ..")
    }
}

func verifyDLLs() {

    print(dllMainGetInfo())
    print(envGetInfo())
    print(timeFuncGetInfo())
    print(astroFuncGetInfo())
    print(tleGetInfo())
    print(sgp4GetInfo())

//    var getNamesString = Array(repeating: Int8(0), count: Int(512))
//    GetInitDllNames(&getNamesString)
//
//    print(getNamesString)

}
