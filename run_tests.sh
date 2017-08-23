source /home/$SOURCE_FILE

log_dir="${LOG_DIR:-/home/stepler_reports/}"
mkdir -p $log_dir
report='report_'$SET'_'`date +%F_%H-%M`

py.test stepler$TESTS_GROUP $SPECIFIC_TEST  -v --junit-xml=$log_dir/$report.html --html=$log_dir/$report.html --self-contained-html --force-destructive
