CREATE TABLE lobbies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lobby_code TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status lobby_status_enum NOT NULL DEFAULT 'in_lobby'
);

CREATE TABLE players (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username TEXT NOT NULL,
    avatar TEXT NOT NULL,
    lobby_id UUID NOT NULL,
    joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    join_order SERIAL NOT NULL,
    CONSTRAINT fk_lobby FOREIGN KEY (lobby_id) REFERENCES lobbies(id) ON DELETE CASCADE,
    UNIQUE (username, lobby_id),
    UNIQUE (avatar, lobby_id)
);

-- Index for quick lookup
CREATE INDEX idx_players_lobby ON players(lobby_id);

ALTER TABLE lobbies 
ADD COLUMN host_id UUID NULL;

ALTER TABLE lobbies
ADD CONSTRAINT fk_host FOREIGN KEY (host_id) REFERENCES players(id) ON DELETE SET NULL;

-- Index for quick lookup
CREATE INDEX idx_lobbies_host ON lobbies(host_id);
