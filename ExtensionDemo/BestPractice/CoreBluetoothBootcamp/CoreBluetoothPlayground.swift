//
//  CoreBluetoothPlayground.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/6/10.
//  Copyright © 2022 Choi. All rights reserved.
//

import Foundation
import CoreBluetooth

// Peripheral包含1个或多个Service和连接信号强度有用的信息
// Service 可以理解成是一个完成指定功能的数据集合
// Service 是由 Characteristic（特征）组成的，Characteristic 为 Peripheral 的 Service 提供更详细的信息
// 例如:心率Service可能包含一个测量不同体位的心率数据的 Characteristic 和一个传输心率数据的 Characteristic
// 当 Central 与 Peripheral 建立成功的连接后，Central 可以发现 Peripheral 提供的全系列的 Service 和 Characteristic，广播数据包中的数据仅仅是可用服务的一小部分而已
// Central 可以通过读取或写入 Service Characteristic 值的方式与 Service 进行交互。你的 APP 也许需要从数字室温计中获取当前室内的温度或者设置一个温度值到数字室温计中
// 当你通过本地 Central 与周边 Peripheral 进行交互时，你只需要调用 Central 方面的方法就可以了，除非你设置一个本地 Peripheral，并用它来响应其他的 Central 的交互请求，实际运用中，你的蓝牙处理大部分会在 Central 方面

// 在 Central 方面，用 CBCentralManager 对象来表示一个Local Central 设备
final class BLEBootcamp: NSObject {
	private(set) var centralManager: CBCentralManager!
	private var foundPeripheral: CBPeripheral?
	private var localPeripheral: CBPeripheralManager?
	
	/// 通过命令行(uuidgen命令)生成uuid | 用于本地外围设备
	let characteristicUUID = CBUUID(string: "4614CB60-C66D-480F-AA2F-7B915CAE4962")
	let serviceUUID = CBUUID(string: "06D650AC-3B03-4AA2-8CC7-28D3ACF79937")
	/// 构建服务特征树
	let myCharacteristicValue = Data()
	/// 如果你指定了 Characteristic 的值，那么该值将被缓存并且该 Characteristic 的 properties 和 permissions 将被设置为可读的。
	/// 因此，如果你需要 Characteristic 的值是可写的，或者你希望在 Service 发布后，Characteristic 的值在 lifetime（生命周期）中依然可以更改，你必须将该 Characteristic 的值指定为 nil。
	/// 通过这种方式可以确保 Characteristic 的值,在 Peripheral Manager 收到来自连接的 Central 的读或者写请求的时候，能够被动态处理
	lazy var myCharacteristic = CBMutableCharacteristic(type: characteristicUUID, properties: .read, value: myCharacteristicValue, permissions: .readable)
	override init() {
		super.init()
		let options: [String: Any] = [CBCentralManagerOptionShowPowerAlertKey: true]
		self.centralManager = CBCentralManager(delegate: self, queue: .global(qos: .background), options: options)
	}
	
	func overview() {
		/// 常用的类
		//CBUUID
		//CBPeripheral
		//CBService
		//CBCharacteristic
		/// 当你设置并与 Local Peripheral 进行数据交互时，你处理的是它的可变的 Service 和 Characteristic，在 CoreBluetooth 框架中，用 CBMutableService 对象来表示 Local Peripheral 中的服务，同样地，用 CBMutableCharacteristic 对象来表示Local Peripheral 服务中的特征。
		//CBMutableService
		//CBMutableCharacteristic
		/// 自身作为外围设备时使用, 这个对象被用来管理发布包含的服务，包括组织构建 Peripheral 的数据结构以及向中心设备广播数据，Peripheral Manager 也对 Remote Central的读写交互请求做出响应。
		//CBPeripheralManager
	}
	
	func connectDisconnectPeripheral() {
		if let foundPeripheral = foundPeripheral {
			let options: [String: Any] = [
				CBConnectPeripheralOptionNotifyOnConnectionKey: true,
				CBConnectPeripheralOptionNotifyOnDisconnectionKey: true,
				CBConnectPeripheralOptionNotifyOnNotificationKey: true,
				CBConnectPeripheralOptionEnableTransportBridgingKey: true,
				CBConnectPeripheralOptionRequiresANCS: true,
				CBConnectPeripheralOptionStartDelayKey: 2
			]
			/// 连接外围设备
			centralManager.connect(foundPeripheral, options: options)
			/// 取消连接
			centralManager.cancelPeripheralConnection(foundPeripheral)
		}
	}
	
	func scanPeripheral() {
		let services: [CBUUID] = [
		]
		let options: [String: Any] = [
			/// The value for this key is an NSNumber object.
			/// If true, the central disables filtering and generates a discovery event each time it receives an advertising packet from the peripheral.
			/// If false (the default), the central coalesces multiple discoveries of the same peripheral into a single discovery event.
			/// Important: Disabling this filtering can have an adverse effect on battery life; use it only if necessary.
			CBCentralManagerScanOptionAllowDuplicatesKey: true,
			/// Specifying this scan option causes the central manager to also scan for peripherals soliciting any of the services contained in the array.
			CBCentralManagerScanOptionSolicitedServiceUUIDsKey: services
		]
		centralManager.scanForPeripherals(withServices: services, options: options)
	}
	
	func localCentral() {
		let localPeripheral = CBPeripheralManager(delegate: self, queue: .main, options: nil)
		/// 一个 Primary Service 用来描述这个设备的主要功能，还可以用来引用其他的 Service。
		/// 一个 Secondary Service 用来描述的是上下文中相关的或者被引用的 Service
		/// 举个例子，从心率传感器中获取心率的服务是 primary Service，而获取传感器电量的服务就可以被视为 secondary Service
		let service = CBMutableService(type: serviceUUID, primary: true)
		/// 将特征值赋值个服务
		service.characteristics = [
			myCharacteristic
		]
		/// 发布服务
		/// 提示：当你发布 Service 和相关的 Characteristic 到 Peripheral 的数据库中后，设备已经将数据缓存，你不能再改变它了。
		localPeripheral.add(service)
		/// 广播Service
		let advertisementData: [String: Any] = [ /// 只接受以下两种Key值
			CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
			CBAdvertisementDataLocalNameKey: ""
		]
		localPeripheral.startAdvertising(advertisementData)
		
		self.localPeripheral = localPeripheral
	}
}

extension BLEBootcamp: CBPeripheralManagerDelegate {
	
	func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
		
	}
	
	func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
		let updated = Data()
		peripheral.updateValue(updated, for: myCharacteristic, onSubscribedCentrals: nil)
	}
	
	/// 相应中心设备的订阅
	func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
		print("Subscribed.")
		/// 更新订阅
		let newValue = Data()
		/// 当你调用这个方法给订阅的 Central 发送通知时，你可以通过最后的那个参数来指定要发送的 Central
		/// 示例代码中的参数为 nil，表明将会发送通知给所有连接且订阅的 Central，没有订阅的 Central 则会被忽略
		/// 方法会返回一个 Boolean 类型的值来表示通知是否成功的发送给订阅的 Central 了，如果 base queue （基础队列）满载，该方法会返回 false
		/// 当传输队列存在更多空间时，Peripheral Manager 则会调用 peripheralManagerIsReadyToUpdateSubscribers: 代理方法进行回调。
		/// 你可以实现这个代理方法，在方法中再次调用 updateValue:forCharacteristic:onSubscribedCentrals: 方法发送通知给订阅的 Central
		/// Note: Use notifications to send a single packet of data to subscribed centrals.
		/// That is, when you update a subscribed central, you should send the entire updated value in a single notification,
		/// by calling the updateValue:forCharacteristic:onSubscribedCentrals: method only once.
		
		/// Depending on the size of your characteristic’s value, not all of the data may be transmitted by the notification.
		/// If this happens, the situation should be handled on the central side through a call to the readValueForCharacteristic: method of the CBPeripheral class, which can retrieve the entire value.
		let didSendValue = peripheral.updateValue(newValue, for: myCharacteristic, onSubscribedCentrals: nil)
		print(didSendValue)
	}
	
	/// 相应外围设备的写入请求
	func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
		for request in requests {
			myCharacteristic.value = request.value
			peripheral.respond(to: request, withResult: .invalidHandle)
		}
	}
	
	/// 相应外围设备的读取请求
	func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
		if request.characteristic.uuid == characteristicUUID {
			/// 如果 Characteristic 的 UUID 能够匹配，下一步就是确保读取请求的位置没有超出 Characteristic 的值的边界。
			/// 如下面代码所示，你可以通过使用 CBATTRequest 对象的 offset 属性来确保读取请求没有尝试读取范围之外的数据。
			guard request.offset <= myCharacteristicValue.count else {
				peripheral.respond(to: request, withResult: .invalidOffset)
				return
			}
			request.value = myCharacteristicValue.subdata(in: request.offset..<myCharacteristicValue.count - request.offset)
			peripheral.respond(to: request, withResult: .success)
		} else {
			peripheral.respond(to: request, withResult: .invalidHandle)
		}
	}
	
	/// 开始广播
	func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
		
	}
	
	/// 本地外围设备发布服务
	func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
		
	}
	
	func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
		
	}
}

extension BLEBootcamp: CBPeripheralDelegate {
	
	/// 成功写入值的回调
	func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
		if let error = error {
			print(error.localizedDescription)
			return
		}
	}
	
	/// 对于动态变化的Characteristic监听其返回值
	func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
		if let data = characteristic.value {
			print(data)
		}
	}
	
	/// 取得Characteristic的静态值
	func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		if let data = characteristic.value {
			print(data)
		}
	}
	
	/// 发现特征值
	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		if let characteristics = service.characteristics {
			for characteristic in characteristics {
				print(characteristic)
			}
			/// 读取Characteristic的值
			if let firstCharacteristic = characteristics.first {
				let characterProperties = firstCharacteristic.properties
				/// 并不是所有的 Characteristic 的值都是可读的
				/// 决定一个 Characteristic 的值是否可读是通过检查 Characteristic 的 Properties 属性是否包含 CBCharacteristicPropertyRead 常量来判断的
				/// 当你尝试去读取一个值不可读的 Characteristic 时，Peripheral 会通过 peripheral:didUpdateValueForCharacteristic:error: 给你返回一个合适的错误。
				if characterProperties.contains(.read) {
					peripheral.readValue(for: firstCharacteristic)
				}
				/// 通过上面方法读取一个 Characteristic 的静态值是有效的
				/// 但是，对于动态的值，就不是一个有效的方法，因为 Characteristic 的值在实时改变，比如你的心率数据。只有通过订阅才能获取实时的改变值
				/// 订阅Characteristic值
				/// 并不是所有的 Characteristic 都提供订阅功能，决定一个 Characteristic
				/// 是否能订阅是通过检查 Characteristic 的 properties 属性是否包含 CBCharacteristicPropertyNotify 或者 CBCharacteristicPropertyIndicate  常量来判断的
				if characterProperties.contains(.notify) || characterProperties.contains(.indicate) {
					peripheral.setNotifyValue(true, for: firstCharacteristic)
				}
				/// 为特征值写入数据
				/// 如果你指定写入类型为 CBCharacteristicWriteWithoutResponse 时，不能保证写入操作是否有效的执行了。这时 Peripheral 不会调用任何代理方法
				let writeInValue = Data()
				if characterProperties.contains(.write) {
					peripheral.writeValue(writeInValue, for: firstCharacteristic, type: .withResponse)
				}
				if characterProperties.contains(.writeWithoutResponse) {
					peripheral.writeValue(writeInValue, for: firstCharacteristic, type: .withoutResponse)
				}
			}
		}
	}
	
	/// 发现服务
	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		if let services = peripheral.services {
			for service in services {
				print(service)
			}
			/// 搜索指定的 Service 的 Characteristic
			if let firstService = services.first {
				let characteristics: [CBUUID] = []
				peripheral.discoverCharacteristics(characteristics, for: firstService)
			}
		}
	}
}

extension BLEBootcamp: CBCentralManagerDelegate {
	
	func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
		
	}
	
	/// 连接成功
	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		/// 设置外围设备代理
		peripheral.delegate = self
		/// 搜索Service
		let services: [CBUUID] = []
		peripheral.discoverServices(services)
	}
	
	/// 连接失败
	func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		
	}
	
	/// 发现外围设备回调
	/// - Parameters:
	///   - peripheral: 外围设备
	///   - advertisementData: 数据
	///   - RSSI: 信号强度
	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		foundPeripheral = peripheral
		
		/// 停止搜索
		central.stopScan()
	}
	
	/// 蓝牙状态更新
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		switch central.state {
		case .unknown:
			break
		case .resetting:
			break
		case .unsupported:
			break
		case .unauthorized:
			break
		case .poweredOff:
			break
		case .poweredOn:
			break
		@unknown default:
			fatalError("NEW STATE TO HANDLE.")
		}
	}
}
