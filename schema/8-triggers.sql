-- Prevent self-voting
CREATE OR REPLACE FUNCTION prevent_self_voting() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.voter_id = NEW.voted_for THEN
        RAISE EXCEPTION 'Players cannot vote for themselves';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER self_voting_check
BEFORE INSERT ON votes
FOR EACH ROW EXECUTE FUNCTION prevent_self_voting();

-- Compute is_correct on insert/update
CREATE OR REPLACE FUNCTION compute_is_correct() RETURNS TRIGGER AS $$
DECLARE
    article_owner UUID;
BEGIN
    SELECT submitted_by INTO article_owner
    FROM articles
    WHERE id = (SELECT article_id FROM rounds WHERE id = NEW.round_id);

    NEW.is_correct := (NEW.voted_for = article_owner);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER compute_correct_vote
BEFORE INSERT OR UPDATE ON votes
FOR EACH ROW EXECUTE FUNCTION compute_is_correct();

-- Reassign host if host leaves, else delete lobby
CREATE OR REPLACE FUNCTION reassign_host_or_delete_lobby() RETURNS TRIGGER AS $$
DECLARE
    new_host UUID;
BEGIN
    -- Select a new host randomly if any players remain
    SELECT id INTO new_host FROM players WHERE lobby_id = OLD.lobby_id ORDER BY RANDOM() LIMIT 1;

    IF new_host IS NULL THEN
        -- If no players left, delete the lobby
        DELETE FROM lobbies WHERE id = OLD.lobby_id;
    ELSE
        -- Otherwise, assign the new host
        UPDATE lobbies SET host_id = new_host WHERE id = OLD.lobby_id;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER reassign_host_trigger
AFTER DELETE ON players
FOR EACH ROW EXECUTE FUNCTION reassign_host_or_delete_lobby();

-- Prevent games from being started with fewer than 3 players
CREATE OR REPLACE FUNCTION prevent_game_start_with_few_players() RETURNS TRIGGER AS $$
DECLARE
    player_count INT;
BEGIN
    SELECT COUNT(*) INTO player_count FROM players WHERE lobby_id = NEW.lobby_id;

    IF player_count < 3 THEN
        RAISE EXCEPTION 'Cannot start a game with fewer than 3 players';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_min_players
BEFORE INSERT ON games
FOR EACH ROW EXECUTE FUNCTION prevent_game_start_with_few_players();

-- Correctly assign random articles for each new round
CREATE OR REPLACE FUNCTION assign_new_article() RETURNS TRIGGER AS $$
DECLARE
    new_article UUID;
BEGIN
    -- Get a random article not used in previous rounds for the same game
    SELECT id INTO new_article
    FROM articles
    WHERE game_id = NEW.game_id
    AND id NOT IN (SELECT article_id FROM rounds WHERE game_id = NEW.game_id)
    ORDER BY RANDOM() LIMIT 1;

    -- If no valid article exists, raise an exception
    IF new_article IS NULL THEN
        RAISE EXCEPTION 'No available articles for the round';
    END IF;

    -- Assign the new article
    NEW.article_id := new_article;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER auto_assign_article
BEFORE INSERT ON rounds
FOR EACH ROW EXECUTE FUNCTION assign_new_article();

-- Do not allow voting if game or round not active
CREATE OR REPLACE FUNCTION prevent_invalid_votes() RETURNS TRIGGER AS $$
DECLARE
    game_status lobby_status_enum;
    latest_round_id UUID;
BEGIN
    -- Get the game status
    SELECT status INTO game_status 
    FROM lobbies 
    WHERE id = (SELECT lobby_id FROM games WHERE id = (SELECT game_id FROM rounds WHERE id = NEW.round_id));

    IF game_status <> 'in_game' THEN
        RAISE EXCEPTION 'Cannot vote unless the game is active';
    END IF;

    -- Get the latest round for the game
    SELECT id INTO latest_round_id 
    FROM rounds 
    WHERE game_id = (SELECT game_id FROM rounds WHERE id = NEW.round_id)
    ORDER BY round_number DESC 
    LIMIT 1;

    -- Ensure the vote is for the latest round
    IF NEW.round_id <> latest_round_id THEN
        RAISE EXCEPTION 'Players can only vote in the latest round';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach the trigger to prevent invalid votes
CREATE TRIGGER restrict_votes
BEFORE INSERT ON votes
FOR EACH ROW EXECUTE FUNCTION prevent_invalid_votes();

-- Trigger to delete after 24 hours
CREATE OR REPLACE FUNCTION delete_lobby_after_24_hours() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM lobbies WHERE created_at < NOW() - INTERVAL '24 hours';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_old_lobbies
AFTER INSERT ON lobbies
EXECUTE FUNCTION delete_lobby_after_24_hours();

-- Trigger to delete players after 24 hours
CREATE OR REPLACE FUNCTION delete_players_after_24_hours() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM players WHERE joined_at < NOW() - INTERVAL '24 hours';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_old_players
AFTER INSERT ON players
EXECUTE FUNCTION delete_players_after_24_hours();
