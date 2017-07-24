//
//  ActionHandlerDelegate.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 19/07/17.
//

protocol ActionHandlerDelegate {
    func gameOverAction() -> Void
    func levelUpAction() -> Void
    func nextSubLevelAction() -> Void
}
