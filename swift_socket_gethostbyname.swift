import Foundation

let hostName = "www.baidu.com"
print("ping \(hostName)")
guard let host = gethostbyname(hostName) else { exit(-1) }
guard let addr_list = host.pointee.h_addr_list else { exit(-1) }
guard var cs = addr_list.pointee else { exit(-1) }
let size = strlen(cs)
guard size % MemoryLayout<in_addr>.size == 0 else { exit(-1) }

var i = 1
while cs.pointee != 0 {
    var addr = in_addr()
    memcpy(&addr, cs, MemoryLayout<in_addr>.size)
    if let str = inet_ntoa(addr) {
        let string = String(cString: str)
        print("ip \(i) = \(string)")
    }
    cs += MemoryLayout<in_addr>.size
    i += 1
}
print("finish")
