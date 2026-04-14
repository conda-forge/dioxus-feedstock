set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=thin
set OPENSSL_DIR=%LIBRARY_PREFIX%
set OPENSSL_NO_VENDOR=1

# ref: https://github.com/conda-forge/git-cliff-feedstock/pull/26#issuecomment-2702015996
copy %PREFIX%\Library\lib\libssh2.lib %PREFIX%\Library\lib\ssh2.lib

:: check licenses
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml || goto :error

:: build
cargo install --bins --no-track --locked --root "%LIBRARY_PREFIX%" --path .\packages\cli || goto :error

# ref: https://github.com/conda-forge/git-cliff-feedstock/pull/26#issuecomment-2702378753
del %PREFIX%\Library\lib\ssh2.lib || exit 1

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
