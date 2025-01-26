CREATE TABLE articles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    game_id UUID NOT NULL,
    submitted_by UUID NOT NULL,
    url TEXT NOT NULL,
    CONSTRAINT fk_game FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
    CONSTRAINT fk_submitted_by FOREIGN KEY (submitted_by) REFERENCES players(id) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX idx_articles_game ON articles(game_id);
CREATE INDEX idx_articles_submitted_by ON articles(submitted_by);
