//
//  GameView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import SwiftUI

enum GameState {
    case playing
    case menu
    case result
}

struct GameView: View {
    @StateObject var viewModel = GameBoardViewModel()
    @State private var gameState: GameState = .playing
    @State private var dragOffset: CGSize = .zero
    @State private var currentTilePosition: CGPoint = .zero
    @State private var initialTilePosition: CGPoint = .zero
    @State private var currentTileCellID: UUID? = nil
    @State private var animateButton = false

    var isSetComplete: Bool {
        viewModel.cells.filter { !$0.isFixed }.count == 1
    }

    var body: some View {
        ZStack {
            BackgroundView()

            switch gameState {
            case .playing:
                GeometryReader { geo in
                    let boardCenter = CGPoint(
                        x: geo.size.width / 2,
                        y: geo.size.height / 2 - 50
                    )
                    ZStack {
                        BoardGridView(cells: viewModel.cells,
                                      hexSize: viewModel.hexSize,
                                      boardCenter: boardCenter)
                        DraggableTileView(
                            tile: viewModel.currentTile,
                            size: viewModel.hexSize,
                            boardCenter: boardCenter,
                            position: $currentTilePosition,
                            dragOffset: $dragOffset
                        ) { dropPoint in
                            if let targetCell = viewModel.cellForDrop(at: dropPoint) {
                                viewModel.placeTile(viewModel.currentTile, at: targetCell.id)
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                    currentTilePosition = CGPoint(
                                        x: boardCenter.x + targetCell.center.x,
                                        y: boardCenter.y + targetCell.center.y
                                    )
                                    dragOffset = .zero
                                    currentTileCellID = targetCell.id
                                }
                            } else {
                                withAnimation {
                                    dragOffset = .zero
                                }
                            }
                        }
                        ControlPanelView(
                            gameState: $gameState,
                            isSetComplete: isSetComplete,
                            animateButton: animateButton,
                            nextAction: {
                                if let cellID = currentTileCellID {
                                    withTransaction(Transaction(animation: nil)) {
                                        viewModel.fixTile(at: cellID)
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                        viewModel.drawNextTile()
                                        currentTilePosition = initialTilePosition
                                        dragOffset = .zero
                                        currentTileCellID = nil
                                        if viewModel.isGameComplete() {
                                            gameState = .result
                                        }
                                    }
                                }
                            }
                        )
                    }
                    .onAppear {
                        let initPos = CGPoint(
                            x: geo.size.width / 2,
                            y: geo.size.height - viewModel.hexSize * 2.0
                        )
                        currentTilePosition = initPos
                        initialTilePosition = initPos
                    }
                }

            case .menu:
                MenuView(showMenu: .constant(false), showLogoView: .constant(false), showSettingsView: .constant(false))
                    .onDisappear { gameState = .playing }

            case .result:
                GameResultView(viewModel: viewModel, showGameComplete: .constant(true))
                    .onDisappear { gameState = .playing }
            }
        }
    }
}
