CREATE TABLE game_stats (
    game_id UUID NOT NULL,
    player_id UUID NOT NULL,
    rounds_won INT NOT NULL DEFAULT 0 CHECK (rounds_won >= 0),
    correct_votes INT NOT NULL DEFAULT 0 CHECK (correct_votes >= 0),
    points INT GENERATED ALWAYS AS (rounds_won * 100 + correct_votes * 20) STORED,
    PRIMARY KEY (game_id, player_id),
    CONSTRAINT fk_game FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
    CONSTRAINT fk_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX idx_game_stats_game ON game_stats(game_id);
CREATE INDEX idx_game_stats_player ON game_stats(player_id);
