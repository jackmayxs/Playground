//
//  BaseStaticTableViewController.swift
//  zeniko
//
//  Created by Choi on 2022/8/11.
//

import UIKit
import RxSwift

extension UITableViewCell {
    typealias Row = StaticTable.Row
    
    private static var associatedRow = UUID()
    
    var row: Row {
        row(preferredHeight: UITableView.automaticDimension)
    }
    
    func row(preferredHeight: CGFloat) -> Row {
        if let row = objc_getAssociatedObject(self, &Self.associatedRow) as? Row {
            return row
        } else {
            let row = Row(cell: self, preferredHeight: preferredHeight)
            objc_setAssociatedObject(self, &Self.associatedRow, row, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return row
        }
    }
}

protocol StaticTableDelegate: AnyObject {
    func needsReload()
}

class StaticTable: ReactiveCompatible {
    typealias Row = Section.Row
    class Section {
        class Row {
            /// MARK: - Row Implementation
            unowned let cell: UITableViewCell
            let preferredHeight: CGFloat
            fileprivate var didSelect: SimpleCallback?
            init(cell: UITableViewCell, preferredHeight: CGFloat = UITableView.automaticDimension) {
                self.cell = cell
                self.preferredHeight = preferredHeight
            }
            func didSelect(execute: @escaping SimpleCallback) {
                self.didSelect = execute
            }
        }
        
        /// MARK: - Section Implementation
        var rows: [Row] = []
        let topPadding: CGFloat
        let bottomPadding: CGFloat
        init(topPadding: CGFloat = 0, bottomPadding: CGFloat = 0, @ArrayBuilder<Row> _ rowsBuilder: () -> [Row]) {
            self.topPadding = topPadding
            self.bottomPadding = bottomPadding
            let result = rowsBuilder()
            rows.append(contentsOf: result)
        }
        
        subscript(_ row: Int) -> Row {
            rows[row]
        }
    }
    
    weak var delegate: StaticTableDelegate?
    
    /// MARK: - Static Table Implementation
    var sections: [Section] = [] {
        didSet {
            if let delegate {
                delegate.needsReload()
            }
        }
    }
    let tableView: UITableView
    required init(tableView: UITableView) {
        self.tableView = tableView
        prepareSections()
    }
    
    func prepareSections() {
        
    }
    
    subscript(_ section: Int) -> Section {
        sections[section]
    }
    
    func refillSections(@ArrayBuilder<Section> _ sectionsBuilder: () -> [Section]) {
        sections.removeAll()
        appendSections(sectionsBuilder)
    }
    
    func appendSections(@ArrayBuilder<Section> _ sectionsBuilder: () -> [Section]) {
        let result = sectionsBuilder()
        sections.append(contentsOf: result)
    }
}

class BaseStaticTableViewController<Table: StaticTable>: BaseTableViewController {
    
    override var tableViewStyle: UITableView.Style { .grouped }
    
    lazy var staticTable = Table(tableView: tableView)
    
    override func configureTableView() {
        super.configureTableView()
        staticTable.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        staticTable.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        staticTable[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        staticTable[section].topPadding
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.rowHeight > 0 { return tableView.rowHeight }
        return staticTable[indexPath.section][indexPath.row].preferredHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        staticTable[section].bottomPadding
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        staticTable[indexPath.section][indexPath.row].cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let row = staticTable[indexPath.section][indexPath.row]
        row.didSelect?()
    }
}

extension BaseStaticTableViewController: StaticTableDelegate {
    
    func needsReload() {
        tableView.reloadData()
    }
}
