//
//  MyLocalDatabase+Game.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import RxSwift
import RealmSwift

extension MyLocalDatabase: GameLocalDataSource {
    func insertGame(game: LocalGameEntity) -> RxSwift.Completable {
        Completable.create(subscribe: { observer in
                    guard let realm = try? self.instantiate() else {
                        observer(.error(RealmError(reason: .cantInit, line: 16)))
                        return Disposables.create()
                    }

                    do {
                        try realm.safeWrite {
                            realm.add(game, update: .all)
                        }
                        observer(.completed)
                    } catch {
                        observer(.error(error))
                    }
                    return Disposables.create()
                })
    }
    
    func fetchBy(id: String) -> RxSwift.Single<[LocalGameEntity]> {
        Single.create(subscribe: { observer in
                    do {
                        var query = try self.fetch(
                                        NSPredicate(
                                                format: """
                                                        id == %@
                                                        """,
                                                id
                                        )
                                )
                        observer(.success(Array(query)))
                    } catch {
                        observer(.error(error))
                    }
                    return Disposables.create()
                })
    }
    
    func fetchAll() -> RxSwift.Single<[LocalGameEntity]> {
        Single.create(subscribe: { observer in
            guard let realm = try? self.instantiate() else {
                observer(.error(RealmError(reason: .cantInit, line: 16)))
                return Disposables.create()
            }
            do {
                realm.refresh()
                let result =  realm
                    .objects(LocalGameEntity.self)
                observer(.success(Array(result)))
                
            } catch {
                observer(.error(error))
                
            }
            return Disposables.create()
        })
    }
    
    func deleteBy(id: String) -> RxSwift.Completable {
        Completable.create(subscribe: { observer in
                    do {
                        guard let realm = try? self.instantiate() else {
                            observer(.error(RealmError(reason: .cantInit, line: 56)))
                            return Disposables.create()
                        }

                        realm.refresh()

                        try realm.safeWrite {
                            realm.delete(
                                realm.objects(LocalGameEntity.self)
                                    .filter(
                                        NSPredicate(
                                            format: """
                                                    id == %@
                                                    """,
                                            id
                                        )
                                    )
                            )
                        }

                        observer(.completed)
                    } catch {
                        observer(.error(error))
                    }
                    return Disposables.create()
                })
    }
    
}

private extension MyLocalDatabase {
    private func fetch(_ predicate: NSPredicate) throws -> Results<LocalGameEntity> {
        guard let realm = try? self.instantiate() else {
            throw RealmError(reason: .cantFetch, line: 16)
        }
        realm.refresh()

        let result = realm
                .objects(LocalGameEntity.self)
                .filter(predicate)
        return result
    }
}
