//
//  Crazy8.swift
//  Algorithms
//
//  Created by Barış Deniz Sağlam on 29.03.2020.
//  Copyright © 2020 Barış Deniz Sağlam. All rights reserved.
//

import Foundation


enum Suit: String {
    case club
    case diamond
    case heart
    case spade
}

extension Suit: CustomStringConvertible {
    var description: String {
        switch self {
        case .club:
            return "♣"
        case .diamond:
            return "♦"
        case .heart:
            return "♥"
        case .spade:
            return "♠"
        }
    }
}

enum Rank: Int, CaseIterable {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case joker = 11
    case queen = 12
    case king = 13
}

extension Rank: CustomStringConvertible {
    var description: String {
        switch self {
        case .ace:
            return "A"
        case .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten:
            return "\(self.rawValue)"
        case .joker:
            return "J"
        case .queen:
            return "Q"
        case .king:
            return "K"
        }
    }
    
}

struct Card: Equatable {
    var suit: Suit
    var rank: Rank
}

extension Card: CustomStringConvertible {
    var description: String {
        return "\(rank)\(suit)"
    }
}

fileprivate func canAppend(card: Card, to end: Card) -> Bool {
    return end.rank == .eight
        || card.rank == .eight
        || end.suit == card.suit
        || end.rank == card.rank
}

func crazy8(hand: [Card]) -> (score: Int, subsequence: [Card]) {
    var scores: [Int] = Array(repeating: -1, count: hand.count)
    var parents: [Int] = Array(repeating:-1, count: hand.count)
    
    scores[0] = 1
    parents[0] = 0
    for i in 1 ..< hand.count {
        var bestScore = 1
        var bestPrev = i
        let currentCard = hand[i]
        for j in 0 ..< i {
            let endCard = hand[j]
            if canAppend(card: currentCard, to: endCard) {
                let newScore = scores[j] + 1
                if newScore > bestScore {
                    bestScore = newScore
                    bestPrev = j
                }
            }
        }
        scores[i] = bestScore
        parents[i] = bestPrev
    }
    
    let index = scores.argmax()!
    let bestScore = scores[index]

    var bestSub: [Card] = []
    var i = index
    while true {
        bestSub.append(hand[i])
        let p = parents[i]
        if p == i {
            break
        }
        i = p
    }
    
    return (bestScore, bestSub.reversed())
}

func testCrazy8DP() {
    let hand = [
        Card(suit: .diamond, rank: .ace),
        Card(suit: .club, rank: .seven),
        Card(suit: .heart, rank: .seven),
        Card(suit: .club, rank: .king),
        Card(suit: .spade, rank: .king),
        Card(suit: .heart, rank: .eight),
        Card(suit: .diamond, rank: .five),
        Card(suit: .club, rank: .two),
    ]

    let (score, sub) = crazy8(hand: hand)

    print(hand)
    print(sub)
    print(score)

}
