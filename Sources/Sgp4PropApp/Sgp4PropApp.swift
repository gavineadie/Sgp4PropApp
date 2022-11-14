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

        let satKey = tleAddSatFrLines("1 90021U RELEAS14 00051.47568104  .00000184 +00000+0 +00000-4 0 0814",
                                      "2 90021   0.0222 182.4923 0000720  45.6036 131.8822  1.00271328 1199");
        print(satKey)

        let sgpError = sgp4InitSat(satKey)
        if sgpError == 0 {
            print("## \(GetLastErrMsg()) (after sgp4InitSat) <<<-- MISTAKE")   // shouldn't happen ..
        } else {
            print("## \(GetLastErrMsg()) (after sgp4InitSat)")   // shouldn't happen ..
        }

        let startTime = DTGToUTC("00051.47568104")
        print("startTime = \(startTime) [C version: 18313.475681039999]")
        let endTime = startTime + 10

//
// propagate for 10 days from start time with 0.5 day (720 minute) step size
//
        for time in stride(from: startTime, to: endTime, by: 0.5) {

            var mse = 0.0
            var pos = Real1D()
            var vel = Real1D()
            var llh = Real1D()

            let propError = sgp4PropDs50UTC(satKey, time, &mse, &pos, &vel, &llh)

            guard propError == 0 else {
                print("## \(GetLastErrMsg()) (after Sgp4PropDs50UTC)")
                fatalError("sgp4PropDs50UTC")
            }

            print("pos.x = \(pos.x), pos.y = \(pos.y), pos.z = \(pos.z)")
        }

        let code = OpenLogFile(fileName: "../TestMessageFile")
        LogMessage(message: "Help!  There are marmots in the capsule .. \(code)")
        CloseLogFile()

        print("Sgp4PropApp done ..")
    }
}
