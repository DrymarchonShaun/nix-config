import os
import re
import requests
import subprocess
from termcolor import colored

TOKENS = os.environ.get("TOKENS")
MAX_LINE_WIDTH = 100
CONTEXT = 2
IS_DEBUGGING = os.environ.get("DEBUG", False)

RE_PATTERN = re.compile(
    r"(?<!!)https://(?P<host>[^\.]+)\.[^/]+/(?P<user>[^/]+)/(?P<repo>[^/]+)/(?P<type>pull|issues)/(?P<id>\d+)"
)


def msg_prefix(kind):
    prefixes = {
        "error": colored("error:", "red", attrs=["bold"]),
        "warning": colored("warning:", "yellow", attrs=["bold"]),
        "info": colored("info:", "blue", attrs=["bold"]),
    }
    return prefixes.get(kind, prefixes["info"])


def truncate_line_around_match(line, match_start, match_len, max_width=MAX_LINE_WIDTH):
    """
    Truncate the line so the match (URL) is visible and as much context as possible is shown.
    Returns (truncated_line, pointer_col), where pointer_col is the 0-based col in truncated_line.
    """
    line = line.rstrip("\n\r")
    line_len = len(line)
    match_end = match_start + match_len

    # If no truncation needed
    if line_len <= max_width:
        return line, match_start

    # If the match itself is longer than max_width, just show start of match
    if match_len >= max_width - 6:
        truncated = line[match_start : match_start + max_width - 6] + "..."
        return truncated, 0

    # Try to center the match in the output
    available = max_width
    context_left = (available - match_len) // 2
    # Ensure we don't go out of bounds
    start = max(0, match_start - context_left)
    end = start + available
    if end > line_len:
        end = line_len
        start = max(0, end - available)

    truncated = line[start:end]
    pointer_col = match_start - start

    # Add ellipses if we cut off at the start or end
    if start > 0:
        truncated = "..." + truncated[3:]
        pointer_col += 3
    if end < line_len:
        truncated = truncated[:-3] + "..."

    return truncated, pointer_col


def print_nixos_message(
    msg,
    kind,
    file=None,
    lineno=None,
    col=None,
    code_lines=None,
    match_line_idx=None,
    match_len=None,
):
    prefix = msg_prefix(kind)
    print(f"{prefix} {msg}")
    if (
        file
        and lineno is not None
        and col is not None
        and code_lines is not None
        and match_line_idx is not None
    ):
        print(f"     at {file}:{lineno}:{col + 1}:")
        start = max(0, match_line_idx - CONTEXT)
        end = min(len(code_lines), match_line_idx + CONTEXT + 1)
        for idx in range(start, end):
            gutter = f"{idx + 1:>7}|"
            line_content = code_lines[idx].rstrip("\n\r")
            if idx == match_line_idx:
                truncated, pointer_col = truncate_line_around_match(
                    line_content, col, match_len
                )
                print(f"{gutter} {truncated}")
                pointer = " " * (pointer_col + len(gutter) + 1) + colored(
                    "^", "red" if kind == "error" else "yellow", attrs=["bold"]
                )
                print(pointer)
            else:
                truncated, _ = truncate_line_around_match(line_content, 0, 0)
                print(f"{gutter} {truncated}")


def find_column(line, substring):
    idx = line.find(substring)
    return idx if idx != -1 else 0


def get_status(host, user, repo, link_type, id):
    if host == "github":
        url = f"https://api.github.com/repos/{user}/{repo}/{link_type}/{id}"
    elif host == "codeberg":
        url = f"https://codeberg.org/api/v1/repos/{user}/{repo}/{link_type}/{id}"
    else:
        return None

    headers = {
        "User-Agent": "PR-status-checher",
        "Accept": "application/vnd.github+json",
    }
    if TOKENS:
        pairs = [item.split("=", 1) for item in TOKENS.split(";") if "=" in item]
        tokens_dict = {k: v for k, v in pairs}
        if host in tokens_dict:
            headers["Authorization"] = f"token {tokens_dict[host]}"
    try:
        r = requests.get(url, headers=headers)
    except Exception:
        return None
    if r.status_code == 200:
        data = r.json()
        if link_type == "pulls":
            if data.get("state") == "closed":
                return "merged" if data.get("merged") else "closed"
        return data.get("state")
    return None


def main():
    result = subprocess.run(["git", "ls-files"], stdout=subprocess.PIPE, text=True)
    files = result.stdout.strip().split("\n")
    found = False
    for filepath in files:
        if not filepath or not os.path.isfile(filepath):
            continue
        try:
            with open(filepath, "r", encoding="utf-8") as f:
                lines = f.readlines()
        except Exception:
            continue
        for i, line in enumerate(lines):
            for match in RE_PATTERN.finditer(line):
                host = match.group("host")
                user = match.group("user")
                repo = match.group("repo")
                link_type = "pulls" if "pull" in match.group(0) else "issues"
                id = match.group("id")
                state = get_status(host, user, repo, link_type, id)
                col = find_column(line, match.group(0))
                file = filepath
                lineno = i + 1
                code_lines = lines
                match_line_idx = i
                match_len = len(match.group(0))
                if state == "closed":
                    print_nixos_message(
                        f"undefined or closed {link_type.rstrip('s')} '{match.group(0)}'",
                        "error",
                        file=file,
                        lineno=lineno,
                        col=col,
                        code_lines=code_lines,
                        match_line_idx=match_line_idx,
                        match_len=match_len,
                    )
                    found = True

                elif state == "merged":
                    print_nixos_message(
                        f"{link_type.rstrip('s').capitalize()} '{match.group(0)}' has been merged",
                        "warning",
                        file=file,
                        lineno=lineno,
                        col=col,
                        code_lines=code_lines,
                        match_line_idx=match_line_idx,
                        match_len=match_len,
                    )
                    found = True

                elif state and IS_DEBUGGING:
                    print_nixos_message(
                        f"{link_type.rstrip('s').capitalize()} '{match.group(0)}' is {state}",
                        "info",
                        file=file,
                        lineno=lineno,
                        col=col,
                        code_lines=code_lines,
                        match_line_idx=match_line_idx,
                        match_len=match_len,
                    )
                    found = True
    if not found:
        prefix = msg_prefix("info")
        print(f"{prefix} No issues or pull requests found in tracked files.")


if __name__ == "__main__":
    main()
