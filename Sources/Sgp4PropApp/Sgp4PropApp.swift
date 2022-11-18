//
//  Sgp4PropApp.swift
//  Sgp4PropApp
//
//  Created by Gavin Eadie on 11/11/22.
//

import swift
import obj_c

var globalHandle: Int64 = 0

@main
public struct Sgp4PropApp {

    public static func main() {

        globalHandle = dllMainInit()
        guard envInit(globalHandle) == 0 else { fatalError("envInit load failure") }
        guard timeFuncInit(globalHandle) == 0 else { fatalError("timeFuncInit load failure") }
        guard astroFuncInit(globalHandle) == 0 else { fatalError("astroFuncInit load failure") }
        guard tleInit(globalHandle) == 0 else { fatalError("tleInit load failure") }
        guard sgp4Init(globalHandle) == 0 else { fatalError("sgp4Init load failure") }

        print(dllMainGetInfo())
        print(envGetInfo())
        print(timeFuncGetInfo())
        print(astroFuncGetInfo())
        print(tleGetInfo())
        print(sgp4GetInfo())

        print(getInitDllNames())

        let satKey = tleAddSatFrLines("1 25544U 98067A   22321.90676521  .00009613  00000+0  17572-3 0  9999",
                                      "2 25544  51.6438 295.0836 0006994  86.3588   5.1970 15.50066990369021")  // ISS 2022-11-17

        let startTime = dtgToUTC("22321.90676521")
        print("startTime = \(startTime)")

        print("UTCToDTG20: \(utcToDTG20(startTime))")
        print("UTCToDTG19: \(utcToDTG19(startTime))")
        print("UTCToDTG17: \(utcToDTG17(startTime))")
        print("UTCToDTG15: \(utcToDTG15(startTime))")

        let sgpError = sgp4InitSat(satKey)
        if sgpError == 0 {
            print("## \(GetLastErrMsg()) (after sgp4InitSat) <<<-- MISTAKE")   // shouldn't happen ..
        } else {
            fatalError("## \(GetLastErrMsg()) (after sgp4InitSat)")
        }

//
// propagate for 4 hours from start time with 6 minute step size
//

        var llh = Real1D()

        for minutes in stride(from: 0.0, to: 240.0, by: 6) {
            let dayΔ = minutes / 1440.0

            let propError = sgp4PropDs50UtcLLH(satKey, startTime+dayΔ, &llh)

            guard propError == 0 else {
                print("## \(GetLastErrMsg()) (after Sgp4PropDs50UTC)")
                fatalError("sgp4PropDs50UTC")
            }

            print(String(format: "Δt = %6.2f mins: %+9.2f°, %+9.2f°, %+9.2f Km",
                         minutes, llh.x, llh.y, llh.z))
        }

        let code = OpenLogFile(fileName: "/Users/gavin/Development/Sgp4Prop/Sgp4/TestMessageFile")
        LogMessage(message: "Help!  There are marmots in the capsule .. \(code)")
        CloseLogFile()

        print("Sgp4PropApp done ..")

    }
}
