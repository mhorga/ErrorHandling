
import Foundation

enum Error: ErrorType {
    case InvalidData
    case NoConnection
}

struct User {
    var firstname = ""
    var lastname = ""
    init? (dict: [String : String]) {
        guard let firstname = dict["firstname"], lastname = dict["lastname"] else {return nil}
        self.firstname = firstname
        self.lastname = lastname
    }
}

func parseData(from input: [String : String]) throws -> User {
    guard let firstname = input["firstname"], lastname = input["lastname"] else {
        throw Error.InvalidData
    }
    return User(dict: ["firstname" : firstname, "lastname" : lastname])!
}

func testParsing(dict: [String : String]) -> String {
    var result = ""
    do {
        let item = try parseData(from: dict)
        result = "\(item.firstname) \(item.lastname)"
    } catch Error.InvalidData {
        result = "Invalid data."
    } catch {
        result = "Unknown error."
    }
    return result
}

print(testParsing(["firstname": "Jane", "lastname": "Doe"]))
print(testParsing(["lastname": "Doe"]))

func testConnection(response: Int) throws {
    guard response == 200 else {
        throw Error.NoConnection
    }
}

func testThrowing(dict: [String : String], code: Int) {
    defer {
        print("Testing should be successful, but sometimes errors could be thrown.")
    }
    do {
        try parseData(from: dict)
        try testConnection(code)
        print("All functions completed successfully.")
    } catch {
        print("There is an least one error in the chain!")
    }
}

testThrowing(["firstname": "Jane", "lastname": "Doe"], code: 200)
testThrowing(["firstname": "Jane", "lastname": "Doe"], code: 400)
