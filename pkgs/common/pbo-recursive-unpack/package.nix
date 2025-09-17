{
  lib,
  writeShellScript,
  steam-run,
  findutils,
  parallel,
  hemtt,
}:
writeShellScript "arma3-recursive-unpack" ''

  unpack_pbo() {
      pbo_file="$1"
      out_dir="''${pbo_file%.pbo}"
      echo "Unpacking $pbo_file -> $out_dir"
      if ${lib.getExe steam-run} ${lib.getExe hemtt} utils pbo unpack "$pbo_file" "$out_dir"; then
          echo "Success: Deleting $pbo_file"
          rm "$pbo_file"
      else
          echo "Failed to unpack $pbo_file"
      fi
  }
  export -f unpack_pbo

  derapify_bin() {
      bin_file="$1"
      echo "Derapifying $bin_file"
  if ${lib.getExe steam-run} ${lib.getExe hemtt} utils config derapify "$bin_file"; then
          echo "Success: Deleting $bin_file"
          rm "$bin_file"
      else
          echo "Failed to derapify $bin_file"
      fi
  }
  export -f derapify_bin

  # === Step 1: Parallel Unpacking ===
  echo "=== Unpacking .pbo files in parallel ==="
  ${lib.getExe findutils} . -type f -name "*.pbo" | ${lib.getExe parallel} --jobs 8 unpack_pbo {}

  # === Step 2: Parallel Derapifying ===
  echo "=== Derapifying .bin files in parallel ==="
  ${lib.getExe findutils} . -type f -name "*.bin" | ${lib.getExe parallel} --jobs 8 derapify_bin {}

  echo "All tasks completed."
''
