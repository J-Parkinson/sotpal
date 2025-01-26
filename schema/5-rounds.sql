CREATE TABLE rounds (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    game_id UUID NOT NULL,
    round_number INT NOT NULL CHECK (round_number > 0),
    guesser_id UUID NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    article_id UUID NOT NULL,
    CONSTRAINT fk_game FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
    CONSTRAINT fk_guesser FOREIGN KEY (guesser_id) REFERENCES players(id) ON DELETE CASCADE,
    CONSTRAINT fk_article FOREIGN KEY (article_id) REFERENCES articles(id),
    UNIQUE (game_id, round_number)
);

-- Indexes
CREATE INDEX idx_rounds_game ON rounds(game_id);
CREATE INDEX idx_rounds_article ON rounds(article_id);
