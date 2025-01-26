CREATE TABLE votes (
    round_id UUID NOT NULL,
    voter_id UUID NOT NULL,
    voted_for UUID NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (round_id, voter_id),
    CONSTRAINT fk_round FOREIGN KEY (round_id) REFERENCES rounds(id) ON DELETE CASCADE,
    CONSTRAINT fk_voter FOREIGN KEY (voter_id) REFERENCES players(id) ON DELETE CASCADE,
    CONSTRAINT fk_voted_for FOREIGN KEY (voted_for) REFERENCES players(id) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX idx_votes_round ON votes(round_id);
CREATE INDEX idx_votes_voter ON votes(voter_id);
CREATE INDEX idx_votes_voted_for ON votes(voted_for);
