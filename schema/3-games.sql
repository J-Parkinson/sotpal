CREATE TABLE games (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lobby_id UUID NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    guesser_rotation UUID NULL,
    rotating_guesser BOOLEAN NOT NULL DEFAULT FALSE,
    win_condition win_condition_enum DEFAULT 'best_of_rounds',
    max_points INT CHECK (max_points > 0),
    max_rounds INT CHECK (max_rounds > 0),
    CONSTRAINT fk_lobby FOREIGN KEY (lobby_id) REFERENCES lobbies(id) ON DELETE CASCADE,
    CONSTRAINT fk_guesser_rotation FOREIGN KEY (guesser_rotation) REFERENCES players(id) ON DELETE SET NULL,
    CONSTRAINT rotating_guesser_check CHECK (
        (rotating_guesser = TRUE AND guesser_rotation IS NULL) OR 
        (rotating_guesser = FALSE AND guesser_rotation IS NOT NULL)
    ),
    CONSTRAINT only_one_game_per_lobby UNIQUE (lobby_id)
);

-- Indexes
CREATE INDEX idx_games_lobby ON games(lobby_id);
CREATE INDEX idx_games_guesser_rotation ON games(guesser_rotation);
