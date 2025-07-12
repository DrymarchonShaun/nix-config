#!/usr/bin/env python3
import os
from onlykey import OnlyKey
import time


def fixer(onlykey: OnlyKey) -> None:
    onlykey._connect()
    while onlykey.read_string() != "":
        time.sleep(0.2)
    return


def wait_for_unlock(onlykey: OnlyKey):
    errors = 0
    while True:
        try:
            time.sleep(2)
            _ = onlykey.read_string()
            print(f"read_string() returned: {_}")
        except RuntimeError as e:
            print(f"RuntimeError: {e}")  # Key is present but locked
            time.sleep(3)
            onlykey._connect()
        except AttributeError as e:
            print(f"AttributeError: {e}")  # Key not present
            errors += 1
            if errors > 5:
                raise OSError("Security key could not be found, was it removed?")
            time.sleep(3)
            onlykey._connect()
        except OSError as e:
            print(f"OSError: {e}")  # Key not present
            errors += 1
            if errors > 5:
                raise OSError("Security key could not be found, was it removed?")
            time.sleep(3)
            onlykey._connect()
        # FIXME: Not working for some fucking reason
        # except OnlyKeyUnavailableException as e:
        except Exception as e:
            print(f"Exception: {e}")
            errors += 1
            if errors > 5:
                raise OSError("Device is being used by another program")
            time.sleep(3)
            onlykey._connect()
        else:
            """
            Duo is weird and randomly dumps labels when turned on,
            so we need to wait for it to be ready before we can read the labels.
            """
            fixer(onlykey)
            break


def get_id(onlykey: OnlyKey) -> str:
    wait_for_unlock(onlykey)

    while True:
        onlykey.set_time(time.time())
        time.sleep(0.3)
        version_string = onlykey.read_string()
        if version_string.startswith("UNLOCKED"):
            device_type = version_string[19]
            break
        else:
            continue

    _slots = {}
    if device_type == "c":
        label = (
            onlykey.getlabels()[11].to_str().replace("Slot 6b:", "").replace("ÿ", "")
        )
        return label

    else:
        while onlykey.read_string() != "":
            continue
        while True:
            try:
                label = onlykey.getduolabels()[23].to_str()
                if label.startswith("Slot Purple 3b"):
                    break
                else:
                    onlykey._connect()
                    continue
            # Workaround for ord() receiving a string instead of a character for some reason
            except TypeError:
                onlykey._connect()
                continue

        return label.replace("Slot Purple 3b:", "").replace("ÿ", "")


def main():
    onlykey = OnlyKey()
    active_id = get_id(onlykey).lower().strip()
    ssh_path = os.path.expanduser("~/.ssh")

    if os.path.exists(f"{ssh_path}/id_onlykey"):
        os.remove(f"{ssh_path}/id_onlykey")
    if os.path.exists(f"{ssh_path}/id_onlykey.pub"):
        os.remove(f"{ssh_path}/id_onlykey.pub")

    if os.path.exists(f"{ssh_path}/id_{active_id}"):
        os.symlink(f"{ssh_path}/id_{active_id}", f"{ssh_path}/id_onlykey")
    else:
        print(f"SSH key for {active_id} does not exist, skipping symlink creation.")
    if os.path.exists(f"{ssh_path}/id_{active_id}.pub"):
        os.symlink(f"{ssh_path}/id_{active_id}.pub", f"{ssh_path}/id_onlykey.pub")
    else:
        print(
            f"SSH public key for {active_id} does not exist, skipping symlink creation."
        )


if __name__ == "__main__":
    main()
