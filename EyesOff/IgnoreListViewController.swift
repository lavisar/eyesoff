import Cocoa

class IgnoreListViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    let ignoredAppsKey = "IgnoredApps"
    var tableView: NSTableView!
    var runningApps: [NSRunningApplication] = []
    var ignoredApps: [String] = []
    var appDelegate: AppDelegate?

    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 450, height: 400))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupTableView()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        // Refresh data when window appears
        setupData()
        tableView.reloadData()
    }

    func setupData() {
        runningApps = NSWorkspace.shared.runningApplications.filter {
            $0.activationPolicy == .regular && $0.bundleIdentifier != nil && !$0.isHidden
        }.sorted(by: { ($0.localizedName ?? "") < ($1.localizedName ?? "") })
        
        ignoredApps = UserDefaults.standard.stringArray(forKey: ignoredAppsKey) ?? []
    }

    func setupTableView() {
        let scrollView = NSScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true

        tableView = NSTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.headerView = nil
        tableView.gridStyleMask = .dashedHorizontalGridLineMask
        tableView.allowsColumnResizing = false
        tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle

        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("AppColumn"))
        tableView.addTableColumn(column)

        scrollView.documentView = tableView
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return runningApps.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let app = runningApps[row]
        guard let bundleIdentifier = app.bundleIdentifier else { return nil }

        let cellView = NSView()

        let checkbox = NSButton(checkboxWithTitle: "", target: self, action: #selector(checkboxToggled(_:)))
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.state = ignoredApps.contains(bundleIdentifier) ? .on : .off
        checkbox.identifier = NSUserInterfaceItemIdentifier(bundleIdentifier)
        
        let imageView = NSImageView(image: app.icon ?? NSImage(named: NSImage.applicationIconName) ?? NSImage())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let textField = NSTextField(labelWithString: app.localizedName ?? "Unknown App")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.lineBreakMode = .byTruncatingTail

        cellView.addSubview(checkbox)
        cellView.addSubview(imageView)
        cellView.addSubview(textField)

        NSLayoutConstraint.activate([
            checkbox.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 5),
            checkbox.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),

            textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -5),
            textField.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
        ])

        return cellView
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }

    @objc func checkboxToggled(_ sender: NSButton) {
        guard let bundleIdentifier = sender.identifier?.rawValue else { return }

        if sender.state == .on {
            if !ignoredApps.contains(bundleIdentifier) {
                ignoredApps.append(bundleIdentifier)
            }
        } else {
            ignoredApps.removeAll { $0 == bundleIdentifier }
        }
        
        UserDefaults.standard.set(ignoredApps, forKey: ignoredAppsKey)
        print("Updated ignore list: \(ignoredApps)")
    }
}
