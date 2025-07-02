#!/usr/bin/env python3
import argparse
import json
import os
from typing import Any

import vdf


def load_vdf_path(path: str) -> dict[str, Any] | None:
    if not os.path.exists(path):
        return None
    with open(path, "r") as file:
        config_data = vdf.load(file)
    return config_data


def get_user_id() -> str:
    accounts_path = os.path.expanduser("~/.steam/steam/userdata")
    accounts = os.listdir(accounts_path)
    for account in accounts:
        if account.isdigit():
            return account
    raise FileNotFoundError("No valid Steam user ID found in userdata directory.")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--launch-options", required=True)
    args = parser.parse_args()

    local_config_path = os.path.expanduser(
        f"~/.steam/steam/userdata/{get_user_id()}/config/localconfig.vdf"
    )
    # Load VDF if exists or create a new structure

    local_config_data = load_vdf_path(local_config_path)
    if local_config_data is None:
        local_config_data = {
            "UserLocalConfigStore": {"Software": {"Valve": {"Steam": {"apps": {}}}}}
        }

    launch_opts = json.loads(args.launch_options)

    # Merge launch options
    apps = local_config_data["UserLocalConfigStore"]["Software"]["Valve"][
        "Steam"
    ].setdefault("apps", {})
    for app_id, opts in launch_opts.items():
        app_entry = apps.setdefault(app_id, {})
        app_entry["LaunchOptions"] = opts

    # Write back modified VDF
    os.makedirs(os.path.dirname(local_config_path), exist_ok=True)
    with open(local_config_path, "w") as f:
        vdf.dump(local_config_data, f, pretty=True)


if __name__ == "__main__":
    main()
