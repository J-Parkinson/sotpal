import { sql, postgresConnectionString } from '@vercel/postgres';

export const createLobbyWithHost = async (username: string, avatar: string | defaultAvatars) => {
  console.log(postgresConnectionString('pool'));
  // Step 1: update DB to create a new lobby and get a lobby code
  const lobbyCodeResult = await sql`INSERT INTO lobbies DEFAULT VALUES RETURNING id, lobby_code`;
  const { lobbyId, lobbyCode } = lobbyCodeResult.rows[0];

  // Step 2: the lobby creator is now a player - create that player and add to the lobby
  const playersResult =
    await sql`INSERT INTO players (username, avatar, lobby_id, is_host) VALUES (${username}, ${avatar}, ${lobbyId}, TRUE) RETURNING id`;
  const { playerId } = playersResult.rows[0];

  console.log(lobbyCode);
  console.log(playerId);
};
