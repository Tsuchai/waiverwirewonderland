# waiver_wire_wonderland 💎

[![Version][version_badge_img]][version_url]
[![Flutter][flutter_badge_img]][flutter_url]
[![Dart][dart_badge_img]][dart_url]
[![Python][python_badge_img]][python_url]

Waiver Wire Wonderland is an basketball fantasy sports application that helps expedite the process in finding waiver-wire gems.

<div align="center">
  <img src="https://raw.githubusercontent.com/Tsuchai/waiverwirewonderland/master/.github/images/wwwreadme.gif" alt="Waiver Wire Wonderland Demo" />
</div>

## Getting Started 🕺

Before you begin, ensure you have the following installed on your system:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (which includes Dart)
- An IDE like [Android Studio](https://developer.android.com/studio) (with the Flutter plugin) or [Visual Studio Code](https://code.visualstudio.com/) (with the Flutter extension).
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for version control.
- [Python 3.8+](https://www.python.org/downloads/)
- `pip` (Python package installer, usually comes with Python)

### Install and Build 🛠️

**Clone the repository and navigate to the project directory.**
```sh
git clone https://github.com/Tsuchai/waiverwirewonderland
cd waiver_wire_wonderland
```

**Install dependencies:**
Run the following command to download all the necessary packages listed in `pubspec.yaml`.
```sh
flutter pub get
```

### Running the Application 🏃‍♂️

**Select a device:**
Open the project in your IDE and select a target device from the device dropdown (e.g., an Android emulator, iOS simulator, or a connected physical device).

**Run the app:**
You can run the app either by clicking the "Run" button in your IDE or by using the terminal:
```sh
flutter run
```

## Backend API Setup 🖥️

The Import Team function currently utilizes a Python script that you must host yourself.

**Navigate to the `api` directory:**
```sh
cd api
```

**Install Python dependencies:**
```sh
pip install -r requirements.txt
```

### Running the Backend API 👨‍💻

The API needs to be running in a separate terminal window while you use the Flutter app.

**Navigate to the `api` directory (if not already there):**
```sh
cd api
```
**Start the FastAPI server:**
```sh
uvicorn main:app --reload
```
Keep this terminal window open and the server running. If you are using an Android emulator, the Flutter app will access this API at `http://10.0.2.2:8000`.

## Usage 🏀
Currently, you must use the import function on the landing page to import a fantasy team, currently supporting ESPN fantasy teams only.
Manual team input coming in a later release. Place the league ID of the team you want to import (the numbers after the link
<span>https://fantasy.espn.com/basketball/league?leagueId=</span>) and click on the Import League Button. Afterward, you should
see the Team Names, Owners, and players of each team down below. You also have the opportunity to delete
the current league if you want to import a new one via the Delete Current League Option.

### Waiver Wire
This is the main view of the app, where you can view all players in the League. The default view shows available players,
but you also have the option to see all players with the "Show players on fantasy rosters" ticker. You can double tap on player cards to view
their full player statistics, as well as game logs. There are two  viewing modes available, **Best Available** and **Weekly Schedule**.

#### Best Available

This section currently lists players via PPG (Points Per Game). Helpful to see which high-usage guys might still be available.

#### Weekly Schedule

This section allows you to view the week schedule of every NBA team, and allow you to see the rosters of a certain team
to scout available players. This option is perfect to find a player that will give you statistics for 4 days in a week.

### View my Team

This view allows you to quickly view your team, as well as opponents teams. You can use the drop-down to view different
teams, and you can set your team by starring in the top-right. Your team will become the default selection when going
back to *View my Team*.

## Roadmap / Upcoming Features 🗺️
Automatic Daily Updates: Downloads fresh stats and schedules every day so the app's data is never old.

Player Watchlist: Allows the user to save and track intriguing players in a separate "favorites" list.

Advanced Filtering & Sorting: Adds a search bar and new sort options like rebounds, assists, or steals.

ESPN League Import: Connects to your public ESPN league to import all of your league's teams and rosters.

Manual Team Builder: Lets you create a custom fantasy team by manually adding any player you want.

Smart Player Data: Adds filters to hide injured (IR) players and skip "Did Not Play" (DNP) games in logs.

## Documented Journey 📝

If you would like to see my prototype design diagram and the initial draft of the components, you can find that [here](https://docs.google.com/document/d/1OFG6acmsnLfNT7gUApdoP35CjEeEJ-wvR_prJ6WrMUA/edit?tab=t.0).

[version_badge_img]: https://img.shields.io/badge/version-1.0-blue
[version_url]: https://github.com/your-username/your-repo/releases

[flutter_badge_img]: https://img.shields.io/badge/Flutter-0468D7?logo=flutter&logoColor=white
[flutter_url]: https://flutter.dev

[dart_badge_img]: https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white
[dart_url]: https://dart.dev

[python_badge_img]: https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white
[python_url]: https://www.python.org/
