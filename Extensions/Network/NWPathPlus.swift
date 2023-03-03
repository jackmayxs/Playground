//
//  NWPathPlus.swift
//  GodoxCine
//
//  Created by Choi on 2023/3/3.
//

import Network

/// IPv4配置
struct IPv4Config: CustomStringConvertible {
    /// IP地址
    var ip: IPv4Address?
    /// 子网掩码
    var subnetMask: IPv4Address?
    /// 广播地址
    var broadCastIP: IPv4Address?
    
    init(ip: IPv4Address? = nil, subnetMask: IPv4Address? = nil, broadCastIP: IPv4Address? = nil) {
        self.ip = ip
        self.subnetMask = subnetMask
        self.broadCastIP = broadCastIP
    }
    
    var description: String {
        "\(ip.or(.broadcast).debugDescription)/\(subnetMask.or(.broadcast).debugDescription)/\(broadCastIP.or(.broadcast).debugDescription)"
    }
}

extension NWPath {
    
    var ipv4Config: IPv4Config? {
        
        guard let interfaceName = availableInterfaces.map(\.name).first else { return nil }
        
        /// 最终的IP地址
        var ipAddress: String?
        /// 最终的子网掩码
        var subnetMask: String?
        /// 最终的广播地址
        var broadcast: String?

        /// 获取本地所有的接口列表
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        /// 遍历所有接口
        for ifptr in sequence(first: firstAddr, next: \.pointee.ifa_next) {
            let interface = ifptr.pointee
            
            /// IP版本
            let addrFamily = interface.ifa_addr.pointee.sa_family
            /// IPv4
            if addrFamily == UInt8(AF_INET) {
                /// 接口名称(e.g. :en0 en1 etc.)
                let name = String(cString: interface.ifa_name)
                if name == interfaceName {
                    /// 将接口地址转换为人类可读的字符串
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    var subnetmaskName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    var broadcastName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    
                    /// 获取IP地址信息
                    getnameinfo(interface.ifa_addr,
                                socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname,
                                socklen_t(hostname.count),
                                nil,
                                socklen_t(0),
                                NI_NUMERICHOST)
                    
                    /// 获取子网掩码信息
                    var netmask = interface.ifa_netmask.pointee
                    getnameinfo(&netmask,
                                socklen_t(netmask.sa_len),
                                &subnetmaskName,
                                socklen_t(subnetmaskName.count),
                                nil,
                                socklen_t(0),
                                NI_NUMERICHOST)
                    
                    /// 获取网关信息
                    var broadcastPointee = interface.ifa_dstaddr.pointee
                    getnameinfo(&broadcastPointee,
                                socklen_t(netmask.sa_len),
                                &broadcastName,
                                socklen_t(broadcastName.count),
                                nil,
                                socklen_t(0),
                                NI_NUMERICHOST)
                    ipAddress = String(cString: hostname)
                    subnetMask = String(cString: subnetmaskName)
                    broadcast = String(cString: broadcastName)
                }
            }
        }
        freeifaddrs(ifaddr)

        return IPv4Config(
            ip: IPv4Address(ipAddress.orEmpty),
            subnetMask: IPv4Address(subnetMask.orEmpty),
            broadCastIP: IPv4Address(broadcast.orEmpty)
        )
    }
}
