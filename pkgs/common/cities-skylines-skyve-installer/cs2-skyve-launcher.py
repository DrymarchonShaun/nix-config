#!/usr/bin/env python3
import vdf
import os
import re
import subprocess
import sys
import requests
from zipfile import ZipFile

APPID = "949230"

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
    global LIBRARY_PATH
    for key, value in libraryfolders_data["libraryfolders"].items():
        apps = value.get("apps", {})
        if APPID in apps:
            LIBRARY_PATH = os.path.join(value["path"], "steamapps")

            # Get the Proton prefix path
            global COMPAT_DATA_PATH
            COMPAT_DATA_PATH = os.path.join(LIBRARY_PATH, "compatdata", APPID)
            return  # Stop after finding the first match


def install_skyve():
    # get the latest version of Skyve
    manifest = requests.get(
        "https://api.paradox-interactive.com/mods?modId=75804&os=Windows"
    ).json()

    name = manifest["modDetails"]["name"]
    version =   manifest["modDetails"]["preferredVersion"]

    download_url = f"https://modscontent.paradox-interactive.com/cities_skylines_2/{name}/content/sources/{name}_{version}.zip"

    response = requests.get(download_url)
    zip_path = os.path.join(
        COMPAT_DATA_PATH, "pfx", "drive_c", "skyve.zip"
    )
    with open(zip_path, "wb") as file:
        file.write(response.content)

    extracted_path = os.path.join(COMPAT_DATA_PATH, "pfx", "drive_c", "skyve")

    with ZipFile(zip_path, "r") as zip:
        zip.extractall(
                path=extracted_path)

    # Run the installer

    subprocess.call(
        f'protontricks-launch --appid {APPID} "{extracted_path + "Skyve\ Setup.exe"} /S"', shell=True, cwd="/tmp/"
    )


# WIP: still need to change the path to exe below and put in some logic to figure out if dotnet472 needs to be installed

# Main Logic
def main():
    init_vars()

    EXE_PATH = os.path.join(
        COMPAT_DATA_PATH,
        "pfx",
        "drive_c",
        "Program Files",
        "TeamSpeak 3 Client",
        "ts3client_win64.exe",
    )

    if os.path.exists(EXE_PATH):
        print("Skyve is already installed. Launching...")
        subprocess.call(
            f'protontricks-launch --appid {APPID} "{EXE_PATH}" /S',
            shell=True,
            cwd="/tmp/",
        )
    else:
        print("Skyve is not installed. Installing...")
        install_skyve()

    return 0


if __name__ == "__main__":
    main()
