import Foundation

func sampleUnsafePointer() {
    func call(_ p: UnsafePointer<Int>) {
        print("\(p.pointee)")
    }
    var a = 1234
    call(&a)
}

func sampleUnsafeMutablePointer() {
    func modify(_ p: UnsafeMutablePointer<Int>) {
        p.pointee = 5678
    }
    var a = 1234
    modify(&a)
    print("\(a)")
}

func testWithUnsafePointer() {
    var a = 1234
    let p = withUnsafePointer(to: &a) { $0 }
    print("\(p.pointee)")
}

func testWithUnsafePointer2() {
    var a = [1234, 5678]
    let p = withUnsafePointer(to: &a[0]) { $0 + 1 }
    print("\(p.pointee)")
}

func testWithUnsafePointer3() {
    var a = 1234
    let p = withUnsafePointer(to: &a) { $0.debugDescription }
    print("\(p)")
}

func testWithUnsafeBytes() {
    var a: UInt32 = 0x12345678
    let p = withUnsafeBytes(of: &a) { $0 }
    var log = ""
    for item in p {
        let hex = NSString(format: "%x", item)
        log += "\(hex)"
    }
    print("\(p.count)") // 打印：4
    print("\(log)") // 对于小端机器会打印：78563412
}

func testWithUnsafeBufferPointer() {
    let a: [Int32] = [1, 2, -1, -2, 5, 6]
    let p = a.withUnsafeBufferPointer { $0 }
    print("\(p.count)") // 打印：6
    print("\(p[3])") // 打印：-2
}

func testWithUnsafeBufferPointerConvert() {
    let a: [Int32] = [1, 2, -1, -2, 5, 6]
    // 类型 p: UnsafeBufferPointer<Int32>
    let p = a.withUnsafeBufferPointer { $0 }
    // 类型 p2: UnsafePointer<UInt32>
    let p2 = p.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: p.count) { $0 }
    // 类型 p3: UnsafeBufferPointer<UInt32>
    let p3 = UnsafeBufferPointer(start: p2, count: p.count)
    print("\(p3.count)") // 打印：6
    print("\(p3[3])") // 打印：4294967294
}

func testWithUnsafeBufferPointerConvert2() {
    let a: [Int32] = [1, 2, -1, -2, 5, 6]
    // 类型 p: UnsafeBufferPointer<Int32>
    let p = a.withUnsafeBufferPointer { $0 }
    // 类型 p3: UnsafeBufferPointer<UInt32>
    let p3 = p.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: p.count) {
        UnsafeBufferPointer(start: $0, count: p.count)
    }
    print("\(p3.count)") // 打印：6
    print("\(p3[3])") // 打印：4294967294
}

func testUnsafeRawPointer() {
    let a: [Int32] = [1, 2, -1, -2, 5, 6]
    let p = a.withUnsafeBufferPointer { $0 }
    let p2 = UnsafeRawPointer(p.baseAddress!).assumingMemoryBound(to: UInt32.self)
    let p3 = UnsafeBufferPointer(start: p2, count: p.count)
    print("\(p3.count)") // 打印：6
    print("\(p3[3])") // 打印：4294967294
}

func testCLib() {
    var n = 10086
    // malloc
    let p = malloc(MemoryLayout<Int32>.size)!
    // memcpy
    memcpy(p, &n, MemoryLayout<Int32>.size)
    let p2 = p.assumingMemoryBound(to: Int32.self)
    print("\(p2.pointee)") // 打印：10086
    // strcpy
    let str = "abc".cString(using: .ascii)!
    if str.count != MemoryLayout<Int32>.size {
        return
    }
    let pstr = p.assumingMemoryBound(to: CChar.self)
    strcpy(pstr, str)
    print("\(String(cString: pstr))") // 打印：abc
    // strlen
    print("\(strlen(pstr))") // 打印： 3
    // memset
    memset(p, 0, MemoryLayout<Int32>.size)
    print("\(p2.pointee)") // 打印：0
    // strcat
    strcat(pstr, "h".cString(using: .ascii)!)
    strcat(pstr, "i".cString(using: .ascii)!)
    print("\(String(cString: pstr))") // 打印：hi
    // strstr
    let s = strstr(pstr, "i")!
    print("\(String(cString: s))") // 打印：i
    // strcmp
    print("\(strcmp(pstr, "hi".cString(using: .ascii)!))") // 打印：0
    // free
    free(p)
}

func testMallocAndFree() {
    let p = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
    p.initialize(to: 0) // 初始化
    p.pointee = 32
    print("\(p.pointee)") // 打印：32
    p.deinitialize(count: 1) // 反初始化
    p.deallocate()
}

