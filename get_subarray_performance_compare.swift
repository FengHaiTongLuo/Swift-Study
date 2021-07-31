import Foundation

let arrayCount = 25000000
var array: [Int] = Array(repeating: 0, count: arrayCount)
for i in 0..<array.count {
    array[i] = i
}

for method in ["t1", "t2", "t3", "t4"] {
    var dest: [Int] = []
    let destCount = 12000000

    let t1 = Date()
    print("engine = \(String(describing: method))")

    if method == "t1" {
        dest = Array(repeating: 0, count: destCount)
        for i in 0..<destCount {
            dest[i] = array[i]
        }
    }
    if method == "t2" {
        dest = array[0..<destCount].map { $0 }
    } else if method == "t3" {
        dest = Array(repeating: 0, count: destCount)
        var i = 0
        while i < destCount {
            dest[i] = array[i]
            i += 1
        }
    } else if method == "t4" {
        dest = Array(repeating: 0, count: destCount)
        memcpy(&dest, &array, destCount*MemoryLayout<Int>.size)
    }

    let t2 = Date()
    print("time = \(t2.timeIntervalSince(t1))")
    print("index of \(1024) = \(dest[1024])")
}


