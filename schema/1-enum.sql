-- Enum for lobby status
CREATE TYPE lobby_status_enum AS ENUM ('in_lobby', 'in_game', 'post_game');

-- Enum for game win conditions
CREATE TYPE win_condition_enum AS ENUM ('first_to_rounds', 'first_to_points', 'best_of_rounds');
