import UIKit

// 没有网络连接的时候会将请求挂起(iOS 11 Only)
URLSessionConfiguration.default.waitsForConnectivity = true
