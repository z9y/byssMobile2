import Foundation

var remoteTodos: [[String : Any]] = [["id": 1, "title": "delectus aut autem", "completed": 0],
                                     ["id": 2, "title": "quis ut nam facilis et officia qui", "completed": 0],
                                     ["id": 3, "title": "fugiat veniam minus", "completed": 1],
                                     ["id": 4, "title": "et porro tempora", "completed": 1],
                                     ["id": 5, "title": "laboriosam mollitia et enim quasi adipisci quia provident illum", "completed": 0],
                                     ["id": 6, "title": "qui ullam ratione quibusdam voluptatem quia omnis", "completed": 0],
                                     ["id": 7, "title": "illo expedita consequatur quia in", "completed": 0],
                                     ["id": 8, "title": "quo adipisci enim quam ut ab", "completed": 1],
                                     ["id": 9, "title": "molestiae perspiciatis ipsa", "completed": 0],
                                     ["id": 10, "title": "illo est ratione doloremque quia maiores aut", "completed": 1]]

enum PossibleErrors: Error {
    case invalidId
}

class ToDo: CustomStringConvertible {
    
    var id: Int
    var title: String
    var completed: Bool
    
    init(id: Int, title: String, completed: Bool) {
        self.id = id
        self.title = title
        self.completed = completed
    }
    
    func toggle() {
        completed = !completed
    }
    
    var description: String {
        return "id: \(id), title: \(title), completed: \(completed)"
    }
}

class ToDoList: CustomStringConvertible {
    
    var todos: [ToDo] = []
    
    init(remoteTodos: [[String : Any]]) {
        for (remoteToDo) in remoteTodos {
            let toDo = ToDo(id: remoteToDo["id"] as! Int, title: remoteToDo["title"] as! String, completed: (remoteToDo["completed"] as! Int != 0))
            todos.append(toDo)
        }
    }
    
    
    var description: String {
        let newList = todos.map { $0.description }
        
        return "\(newList.joined(separator: "\n"))"
    }
    
    func addTodo(todo: ToDo){
        todos.append(todo)
    }
    
    func generateId() -> Int {
        let maxId = todos.map{$0.id}
        let newId = maxId.max()! + 1
        
        return newId
    }
    
    func removeToDo(id: Int) throws {
        var indexToDelete = -1
        
        if let index = todos.firstIndex(where: {$0.id == id}) {
            indexToDelete = index
            todos.remove(at: indexToDelete)
        } else {
            throw PossibleErrors.invalidId
        }
    }
    
    func toggleTodo(id: Int) throws {
        
        if let toggle = todos.first(where: {$0.id == id}) {
            toggle.completed.toggle()
        } else {
            throw PossibleErrors.invalidId
        }
    }
}


class TodoViewControler {
    
    var toDoList = ToDoList(remoteTodos: remoteTodos)
    var title: String?
    var completed: Bool
    
    init(toDoList: ToDoList) {
        self.toDoList = toDoList
        self.title = ""
        self.completed = false
    }
    
    //funkcja imitujaca interfejs zwracania textu z textfield
    func fillImaginaryTextField(with text: String?) {
        self.title = text
    }
    
    //funkcja imitujaca interfejs przelaczenia checkbox
    func toggleImaginaryCheckbox() {
        completed = !self.completed
    }
    
    //funkcja imitujaca przycisniecie przycisku AddNewToDo
    func imaginaryButtonActionAddNewToDo() {
        if self.title == "" || self.title == nil {
            print("Nie podano tytułu !")
        } else {
            toDoList.addTodo(todo: ToDo.init(id: toDoList.generateId(), title: title!, completed: completed))
            self.title = ""
            self.completed = false
        }
    }
    
    //funkcja imitujaca przycisniecie przycisku RemoveTodo dla obiektu z id
    func imaginaryButtonActionRemoveTodo(with id: Int) {
        do {
            try toDoList.removeToDo(id: id)
        } catch PossibleErrors.invalidId {
            print("Nie ma takiego ID !")
        } catch {
            print("Unexpected error")
        }
    }
    
    //funkcja imitujaca przelaczenie checkbox dla obiektu z id
    func imaginaryButtonActionToggleTodo(with id: Int) {
        do {
            try toDoList.toggleTodo(id: id)
        } catch PossibleErrors.invalidId {
            print("Nie ma takiego ID !")
        } catch {
            print("Unexpected error")
        }
    }
}

var test = TodoViewControler(toDoList: ToDoList(remoteTodos: remoteTodos))
print(test.toDoList)
// Usunięcie todo z id #4
test.imaginaryButtonActionRemoveTodo(with: 4)
print("===")
// Błąd - nie istnieje "todo" o numerze 99
test.imaginaryButtonActionRemoveTodo(with: 99)
// Zmiana completed z false na true
test.imaginaryButtonActionToggleTodo(with: 2)
print("===")
// Błąd - nie istnieje "todo" o numerze 99
test.imaginaryButtonActionToggleTodo(with: 99)
print("===")
// Wypełnienie pola text field z nowym "todo"
test.fillImaginaryTextField(with: "Nowe zadanie")
// Zmiana nowego "todo" z false na true
test.toggleImaginaryCheckbox()
//Dodanie nowego "todo" do listy
test.imaginaryButtonActionAddNewToDo()
//Błąd - nie wpisano nic w text field
test.imaginaryButtonActionAddNewToDo()
print("===")
print(test.toDoList)



