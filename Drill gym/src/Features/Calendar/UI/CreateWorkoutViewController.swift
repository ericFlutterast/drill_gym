import UIKit

class CreateWorkoutViewController: UIViewController{
    private enum CellIdentifier: String{
        case exersice
    }
    
    //MARK: TABLE VIEW STATE
    private var tableViewState: [String] = []
    
    //MARK: VIEWS
    private lazy var scrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    } ()
    
    private lazy var scrollContainer = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var saveButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Save", comment: "save"), for: .normal)
        button.backgroundColor = .systemYellow
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.systemYellow.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
        button.addTarget(self, action: #selector(saveWorkout), for: .touchUpInside)
        return button
    }()
    
    private lazy var workoutNameTextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray2
        textField.attributedPlaceholder = NSAttributedString(string: "Workout name")
        textField.keyboardType = .default
        textField.textColor = .white
        textField.tintColor = .systemYellow
        textField.layer.cornerRadius = 12
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        textField.leftView = .init(frame: .init(x: 0, y: 0, width: 10, height: 5))
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        return textField
    }()
    
    private lazy var addExercisesButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Add exercise", comment: "add exercise"), for: .normal)
        button.setTitleColor(.systemYellow, for: .normal)
        button.tintColor = .systemYellow
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(addExercise), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ExerciseCell.self, forCellReuseIdentifier: CellIdentifier.exersice.rawValue)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false
        tableView.showsVerticalScrollIndicator = false
        tableView.contentSize = .init(width: view.bounds.height, height: 400)
        tableView.allowsSelection = false
        return tableView
    }()
    
    private func title(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = NSLocalizedString(text, comment: "add workout name")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        return label
    }
    
    override func loadView() {
        super.loadView()
        print("load create workout controller")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        
        configurateNavigationItem()
        configurateUI()
    }
    
    private func configurateNavigationItem() {
        navigationItem.title = NSLocalizedString("Create workout", comment: "сreate workout")
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(backButton))
        navigationItem.leftBarButtonItem?.tintColor = .systemYellow
    }
    
    //MARK: BUTTON HANDLERS
    @objc private func backButton() {
        guard let navigationController = navigationController else{return}
        navigationController.popViewController(animated: true)
    }
    
    @objc private func saveWorkout() {
        print("saveWorkout")
        print(workoutNameTextField.text ?? "")
    }
    
    @IBAction private func addExercise() {
        print("addExercise")
        
        tableViewState.append("100 выходов")
        print(tableViewState.count)
        tableView.insertRows(at: [IndexPath(row: tableViewState.count - 1, section: 0)], with: .left)
    }
    
    //MARK: CONSTRAINST
    private func configurateUI() {
        let workoutNameTitle = title(text: "Add workout name")
        let addExercisesTitle = title(text: "Add exercises")
        
        view.addSubview(scrollView)
        view.addSubview(saveButton)
        scrollContainer.addSubview(workoutNameTitle)
        scrollContainer.addSubview(workoutNameTextField)
        scrollContainer.addSubview(addExercisesTitle)
        scrollContainer.addSubview(addExercisesButton)
        scrollContainer.addSubview(tableView)
        scrollView.addSubview(scrollContainer)
       
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            workoutNameTitle.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 16),
            workoutNameTitle.topAnchor.constraint(equalTo: scrollContainer.topAnchor, constant: 16),
            
            workoutNameTextField.topAnchor.constraint(equalTo: workoutNameTitle.bottomAnchor, constant: 10),
            workoutNameTextField.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 16),
            workoutNameTextField.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: -16),
            
            addExercisesTitle.topAnchor.constraint(equalTo: workoutNameTextField.bottomAnchor, constant: 20),
            addExercisesTitle.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 16),
            addExercisesTitle.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: -16),
            
            addExercisesButton.topAnchor.constraint(equalTo: addExercisesTitle.bottomAnchor, constant: 20),
            addExercisesButton.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 16),
            addExercisesButton.heightAnchor.constraint(equalToConstant: 30),
            
            tableView.topAnchor.constraint(equalTo: addExercisesButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}

//MARK: TABLE VIEW EXTENSION
extension CreateWorkoutViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewState.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  CellIdentifier.exersice.rawValue, for: indexPath)
        
        guard let cell = cell as? ExerciseCell else {return cell}
        
        cell.setName(name: "\(indexPath.row + 1). \(tableViewState[indexPath.row])")
        
        return cell
    }
}

extension CreateWorkoutViewController: UITableViewDelegate{
    func tableView(_: UITableView, indentationLevelForRowAt: IndexPath) -> Int{
        0
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Save") {
            (action, view, success) in
            print("Save")
            success(true)
        }
        action.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration.init(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Delete") {
            (action, view, success) in
            print("Delete")
            self.tableViewState.remove(at: indexPath.row)
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .left)
            success(true)
        }
        action.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration.init(actions: [action])
    }
}

//MARK: TABLE VIEW CELL
private class ExerciseCell: UITableViewCell{
    private var name: String?
    
    private lazy var title = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(title)
        self.frame = .init(x: 0, y: 0, width: 300, height: 50)
        self.backgroundColor = .systemGray
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("has not been implemented")
    }
    
    func setName(name: String) {
        self.title.text = name
    }
}
