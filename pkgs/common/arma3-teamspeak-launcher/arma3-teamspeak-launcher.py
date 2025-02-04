#!/usr/bin/env python3
import vdf
import os
import subprocess
import sys
import requests

# Define the version of the script
_SCRIPTVER = "1v18-7"

# Default Variables
PROTON_VERSION = ""
COMPAT_DATA_PATH = ""
ARMA_LIBRARY_PATH = ""


def load_vdf_path(path):
    path_expand = os.path.expanduser(path)
    if not os.path.exists(path_expand):
        print("Error: Steam config file not found!")
        sys.exit(1)

    with open(path_expand, "r") as file:
        config_data = vdf.load(file)

    return config_data


def init_vars():
    # Get the Steam library path
    libraryfolders_data = load_vdf_path("~/.steam/steam/config/libraryfolders.vdf")
    # Get the path to the Library that contains Arma 3
    global ARMA_LIBRARY_PATH
    for key, value in libraryfolders_data["libraryfolders"].items():
        if value["apps"]["107410"]:
            ARMA_LIBRARY_PATH = os.path.join(value["path"], "steamapps")
            break

    # Get the Proton prefix path
    global COMPAT_DATA_PATH
    COMPAT_DATA_PATH = os.path.join(ARMA_LIBRARY_PATH, "compatdata", "107410")


def install_teamspeak():
    # get the latest version of TeamSpeak
    teamspeak_manifest = requests.get(
        "https://www.teamspeak.com/versions/client.json"
    ).json()
    teamspeak_url = teamspeak_manifest["windows"]["x86_64"]["mirrors"]["teamspeak.com"]

    response = requests.get(teamspeak_url)
    file_path = os.path.join(
        COMPAT_DATA_PATH, "pfx", "drive_c", "teamspeak-installer.exe"
    )
    with open(file_path, "wb") as file:
        file.write(response.content)
    # Run the installer
    subprocess.call(f'protontricks-launch --appid 107410 "{file_path}"', shell=True)


# Main Logic
def main():
    init_vars()

    TS_PATH = os.path.join(
        COMPAT_DATA_PATH,
        "pfx",
        "drive_c",
        "Program Files",
        "TeamSpeak 3 Client",
        "ts3client_win64.exe",
    )

    if os.path.exists(TS_PATH):
        print("TeamSpeak is already installed. Launching...")
        subprocess.call(f'protontricks-launch --appid 107410 "{TS_PATH}" /S', shell=True)
    else:
        print("TeamSpeak is not installed. Installing...")
        install_teamspeak()

    return 0


if __name__ == "__main__":
    main()
