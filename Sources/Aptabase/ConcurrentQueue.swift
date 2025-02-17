import SwiftUI


class ConcurrentQueue {
    private var userDefaultsGroup : String?
    private var queue = DispatchQueue(label: "com.aptabase.ConcurrentQueue", attributes: .concurrent)
    private var elements : [Event] {
        get {
            if let array = (UserDefaults(suiteName: userDefaultsGroup) ?? UserDefaults.standard).array(forKey: "aptabase-events"){
                return array.compactMap { any in
                    if let data = any as? Data {
                        return try? JSONDecoder().decode(Event.self, from: data)
                    } else {
                        return nil
                    }
                }
            } else { return [] }

        } set {
            (UserDefaults(suiteName: userDefaultsGroup) ?? UserDefaults.standard).set(
                newValue.compactMap({ event in
                    try? JSONEncoder().encode(event)
                }),
                forKey: "aptabase-events"
            )
        }
    }

    func enqueue(_ element: Event) {
        queue.async(flags: .barrier) {
            self.elements.append(element)
        }
    }

    func enqueue(contentsOf newElements: [Event]) {
        queue.async(flags: .barrier) {
            self.elements.append(contentsOf: newElements)
        }
    }

    func dequeue() -> Event? {
        var result: Event?
        queue.sync {
            if !self.elements.isEmpty {
                result = self.elements.removeFirst()
            }
        }
        return result
    }

    func dequeue(count: Int) -> [Event] {
        var dequeuedElements = [Event]()
        queue.sync {
            for _ in 0 ..< min(count, self.elements.count) {
                dequeuedElements.append(self.elements.removeFirst())
            }
        }
        return dequeuedElements
    }

    var isEmpty: Bool {
        var empty = true
        queue.sync {
            empty = self.elements.isEmpty
        }
        return empty
    }

    var count: Int {
        var count = 0
        queue.sync {
            count = self.elements.count
        }
        return count
    }
    init(userDefaultsGroup: String?) {
        self.userDefaultsGroup = userDefaultsGroup
    }
}
