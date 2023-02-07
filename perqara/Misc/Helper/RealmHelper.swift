//
//  RealmHelper.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import RealmSwift

enum RealmHelper {
    static func setup() {
        GeneralDatabase.setupDatabase()
    }

    // MARK: - General Database
    enum GeneralDatabase {
        private static var _configuration: Realm.Configuration?
        
        static var configuration: Realm.Configuration {
            if _configuration == nil {
                _configuration = Self.generateConfiguration()
            }
            return _configuration ?? Self.generateConfiguration()
        }
        
        private static func generateConfiguration() -> Realm.Configuration {
            var config = Realm.Configuration.defaultConfiguration
            config.objectTypes = [
                LocalGameEntity.self
            ]
            return config
        }
        
        /**
         Obtains a `Realm` instance with the general configuration.
         
         - parameter queue: An optional dispatch queue to confine the Realm to. If
         given, this Realm instance can be used from within
         blocks dispatched to the given queue rather than on the
         current thread.
         
         - throws: An `NSError` if the Realm could not be initialized.
         */
        static func instantiate(queue: DispatchQueue? = nil) throws -> Realm {
            try Realm(configuration: configuration)
        }
        
        fileprivate static func setupDatabase() {
            do {
                try _ = instantiate()
            } catch {
                print(error)
                
                if let path = configuration.fileURL {
                    do {
                        try FileManager.default.removeItem(at: path)
                        try _ = instantiate()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    
}

extension Realm {
    func safeWrite(_ block: () throws -> Void) throws {
        if isInWriteTransaction {
            try block()
        } else {
            do {
                try write(withoutNotifying: [], block)
            } catch let error {
                throw error
            }
        }
    }
}

struct RealmError: Error {
    enum Reason {
        case cantInit
        case cantFetch
    }
    let reason: Reason
    let line: Int?
    let column: Int?

    init(reason: Reason, line: Int? = nil, column: Int? = nil) {
        self.reason = reason
        self.line = line
        self.column = column
    }
}
