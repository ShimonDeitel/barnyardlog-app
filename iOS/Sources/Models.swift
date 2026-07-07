import Foundation

struct LogEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var group: String
    var status: String
    var notes: String
    var date: Date = Date()
}
