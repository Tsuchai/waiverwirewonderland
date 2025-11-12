from fastapi import FastAPI
from espn_api.basketball import League
import json

app = FastAPI()

@app.get("/get-league/{league_id}")
def get_league(league_id: int):
    try:
        # 1. Fetch the public league
        league = League(league_id=league_id,
                        year=2026)  # Use the year the season ENDS

        # 2. Loop through teams and build a simple response
        all_teams = []
        for team in league.teams:
            player_list = []
            for player in team.roster:
                player_list.append({
                    "name": player.name,
                    "playerId": player.playerId,
                    "position": player.position
                })

            # --- THIS IS THE FIX ---
            # Safely get the owner's name using dictionary access
            owner_name = "Unknown Owner"
            if team.owners and len(team.owners) > 0:
                # Use ['displayName'] instead of .displayName
                owner_name = team.owners[0]['displayName']
            # --- END OF FIX ---

            all_teams.append({
                "team_name": team.team_name,
                "owner": owner_name,  # Use the new safe variable
                "players": player_list
            })

        return {"status": "success", "teams": all_teams}

    except Exception as e:
        return {"status": "error", "message": str(e)}


# vvvvvv  TEST BLOCK UPDATED WITH THE FIX  vvvvvv
if __name__ == "__main__":

    TEST_LEAGUE_ID = 1299003905
    TEST_YEAR = 2026

    print(f"--- Running Test for League {TEST_LEAGUE_ID} (Year {TEST_YEAR}) ---")

    try:
        # 1. Fetch the public league
        league = League(league_id=TEST_LEAGUE_ID,
                        year=TEST_YEAR)

        print(f"Successfully fetched league: {league.settings.name}")

        # 2. Loop through teams and build a simple response
        all_teams = []
        for team in league.teams:
            print(f"  ... processing team: {team.team_name}")
            player_list = []
            for player in team.roster:
                player_list.append({
                    "name": player.name,
                    "playerId": player.playerId,
                    "position": player.position
                })

            # --- THIS IS THE FIX ---
            # Safely get the owner's name using dictionary access
            owner_name = "Unknown Owner"
            if team.owners and len(team.owners) > 0:
                # Use ['displayName'] instead of .displayName
                owner_name = team.owners[0]['displayName']
            # --- END OF FIX ---

            all_teams.append({
                "team_name": team.team_name,
                "owner": owner_name,  # Use the new safe variable
                "players": player_list
            })

        # 3. Create the final dictionary
        final_output = {"status": "success", "teams": all_teams}

        # 4. Pretty-print the JSON to your terminal
        print("\n--- TEST COMPLETE: FINAL OUTPUT ---")
        print(json.dumps(final_output, indent=2))

    except Exception as e:
        print(f"\n--- TEST FAILED ---")
        print(f"An error occurred: {e}")
