//
//  TableViewCollectionViewDiffableDataSource.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/1/20.
//  Copyright © 2022 Choi. All rights reserved.
//

enum Section: CaseIterable {
	case main
}

struct MyModel: Hashable {
	var title: String
	
	private let identifier: UUID
	init(title: String) {
		self.title = title
		self.identifier = UUID()
	}
	func hash(into hasher: inout Hasher) {
		hasher.combine(identifier)
	}
}

import UIKit

final class TableViewCollectionViewDiffableDataSourceExample: UIViewController {
	
	private var dataSource: UITableViewDiffableDataSource<Section, MyModel>! = nil
	
	private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).configure { table in
		table.delegate = self
		table.sectionHeaderTopPadding = .leastNormalMagnitude
		table.translatesAutoresizingMaskIntoConstraints = false
		UITableViewCell.registerFor(table)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		@ArrayBuilder<UIAction>
		var elements: [UIAction] {
			UIAction(title: "添加", image: "plus.circle".systemImage) {
				[unowned self] _ in
				models.insert(MyModel(title: .random), at: 0)
				refillData()
			}
			UIAction(title: "重新生成", image: "arrow.clockwise.circle".systemImage) {
				[unowned self] _ in
				models = (0...10).lazy.map { _ in
					MyModel(title: .random)
				}
				refillData()
			}
			UIAction(title: "清空", image: "minus.circle".systemImage, attributes: .destructive) {
				[unowned self] _ in
				models.removeAll()
				refillData()
			}
		}
		let menu = UIMenu(options: .displayInline, children: elements)
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: "plus".systemImage, menu: menu)
		
		/// 布局TableView
		view.addSubview(tableView)
		NSLayoutConstraint.activate {
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			tableView.topAnchor.constraint(equalTo: view.topAnchor)
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		}
		
		/// 设置数据源
		dataSource = UITableViewDiffableDataSource<Section, MyModel>(tableView: tableView) {
			table, indexPath, model -> UITableViewCell? in
			UITableViewCell.dequeueReusableCell(from: table, indexPath: indexPath).configure { cell in
				var config = cell.defaultContentConfiguration()
				config.text = model.title
				cell.contentConfiguration = config
			}
		}
		dataSource.defaultRowAnimation = .fade
		
		refillData()
	}
	
	private func refillData() {
		/// 填充数据
		var snapshot = NSDiffableDataSourceSnapshot<Section, MyModel>()
		snapshot.appendSections(Section.allCases)
		snapshot.appendItems(models, toSection: .main)
		dataSource.apply(snapshot, animatingDifferences: true) {
			print("刷新成功!")
		}
	}
	
	private lazy var models: [MyModel] = {
		(0...20).lazy.map { _ in
			MyModel(title: .random)
		}
	}()
}

extension TableViewCollectionViewDiffableDataSourceExample: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		/// 方法1:
//		var snapshot = dataSource.snapshot()
//		let item = models[indexPath.row]
//		snapshot.deleteItems([item])
//		models.remove(at: indexPath.row)
//		dataSource.apply(snapshot, animatingDifferences: true)
		
		/// 方法2:
		models.remove(at: indexPath.row)
		refillData()
	}
}
