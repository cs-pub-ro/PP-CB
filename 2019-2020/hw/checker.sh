unzip -qq archive.zip
unzip -qq -o artifact.zip
timeout 10m make run_test
exit $?
